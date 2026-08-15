import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../domain/cognitive_models.dart';
import '../utils/natural_time_resolver.dart';
import '../../internal/utils/knight_logger.dart';

/// Service responsible for fetching real data from the database to ground AI responses.
class DataRetrievalService {
  const DataRetrievalService({required this.db});

  final KnightDatabase db;

  /// Retrieves evidence based on intent and query context.
  Future<List<Evidence>> retrieveEvidence(KnightIntent intent, String query) async {
    if (intent == KnightIntent.conversation) return [];

    KnightLogger.info('[RETRIEVAL] Fetching evidence for $intent: "$query"');
    final List<Evidence> evidence = [];
    final range = NaturalTimeResolver.resolve(query);

    switch (intent) {
      case KnightIntent.analysis:
      case KnightIntent.question:
      case KnightIntent.search:
        final input = query.toLowerCase();
        if (input.contains('spend') || input.contains('transaction') || input.contains('money') || input.contains('finance')) {
          evidence.addAll(await _retrieveTransactions(range));
        }
        if (input.contains('event') || input.contains('meeting') || input.contains('calendar') || input.contains('appointment')) {
          evidence.addAll(await _retrieveCalendarEvents(range));
        }
        if (input.contains('work') || input.contains('session') || input.contains('job') || input.contains('career')) {
          evidence.addAll(await _retrieveWorkSessions(range));
        }
        if (input.contains('learn') || input.contains('guru') || input.contains('study') || input.contains('education')) {
          evidence.addAll(await _retrieveMissions(range));
        }
        if (input.contains('trip') || input.contains('travel') || input.contains('flight')) {
          evidence.addAll(await _retrieveTrips(range));
        }
        if (input.contains('health') || input.contains('step') || input.contains('activity') || input.contains('sleep')) {
          evidence.addAll(await _retrieveHealthMetrics(range));
        }
        if (input.contains('task') || input.contains('todo') || input.contains('planner')) {
          evidence.addAll(await _retrieveTasks(range));
        }
        if (input.contains('mission') || input.contains('objective')) {
          evidence.addAll(await _retrieveMissions(range));
        }
        if (input.contains('email') || input.contains('gmail') || input.contains('message') || input.contains('inbox')) {
          evidence.addAll(await _retrieveEmails(range));
        }
        if (input.contains('file') || input.contains('drive') || input.contains('document') || input.contains('pdf')) {
          evidence.addAll(await _retrieveDriveFiles(range));
        }
        if (input.contains('goal') || input.contains('target') || input.contains('wealth')) {
          evidence.addAll(await _retrieveGoals(query));
        }
        if (input.contains('extracted') || input.contains('entity') || input.contains('info')) {
          evidence.addAll(await _retrieveExtractedEntities(range));
        }
        if (input.contains('remember') || input.contains('memory') || input.contains('past')) {
          evidence.addAll(await _retrieveMemories(query));
        }
        break;
      case KnightIntent.planning:
        evidence.addAll(await _retrieveCalendarEvents(range));
        evidence.addAll(await _retrieveGoals(query));
        break;
      case KnightIntent.reflection:
        evidence.addAll(await _retrieveGoals(query));
        evidence.addAll(await _retrieveWorkSessions(range));
        evidence.addAll(await _retrieveHealthMetrics(range));
        break;
      default:
        break;
    }

    return evidence;
  }

  Future<List<Evidence>> _retrieveTransactions(DateTimeRange range) async {
    final results = await (db.select(db.transactionTable)
      ..where((t) => t.transactionDate.isBetween(Variable(range.start), Variable(range.end)))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)])
      ..limit(20)).get();

    return results.map((t) => Evidence(
      source: 'Finance Platform',
      timestamp: t.transactionDate,
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'transaction',
        'id': t.id,
        'description': t.description,
        'amount': t.amount,
        'category': t.category,
        'merchant': t.merchant,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveCalendarEvents(DateTimeRange range) async {
    final results = await (db.select(db.googleResourceTable)
      ..where((t) => t.resourceType.equals('calendar') & t.resourceDate.isBetween(Variable(range.start), Variable(range.end)))
      ..orderBy([(t) => OrderingTerm.desc(t.resourceDate)])
      ..limit(10)).get();

    return results.map((r) => Evidence(
      source: 'Google Calendar',
      timestamp: r.resourceDate,
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'calendar_event',
        'id': r.id,
        'title': r.title,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveWorkSessions(DateTimeRange range) async {
    // WorkSessionTable uses TextColumn for startTime, so we filter by createdAt or handle string conversion
    final results = await (db.select(db.workSessionTable)
      ..where((t) => t.createdAt.isBetween(Variable(range.start), Variable(range.end)))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(10)).get();

    return results.map((s) => Evidence(
      source: 'Career Module',
      timestamp: DateTime.tryParse(s.startTime) ?? s.createdAt,
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'work_session',
        'id': s.id,
        'shiftType': s.shiftType,
        'notes': s.notes,
        'hours': s.totalHours,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveTrips(DateTimeRange range) async {
    final results = await (db.select(db.tripTable)
      ..where((t) => t.startDate.isBetween(Variable(range.start), Variable(range.end)) | t.endDate.isBetween(Variable(range.start), Variable(range.end)))
      ..orderBy([(t) => OrderingTerm.desc(t.startDate)])
      ..limit(5)).get();

    return results.map((t) => Evidence(
      source: 'Travel Module',
      timestamp: t.startDate,
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'trip',
        'id': t.id,
        'title': t.title,
        'status': t.lifecycleState,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveHealthMetrics(DateTimeRange range) async {
    final results = await (db.select(db.healthMetricTable)
      ..where((t) => t.startTime.isBetween(Variable(range.start), Variable(range.end)))
      ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
      ..limit(20)).get();

    return results.map((m) => Evidence(
      source: 'Health Module',
      timestamp: m.startTime,
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'health_metric',
        'id': m.id,
        'type_label': m.metricType,
        'value': m.value,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveGoals(String query) async {
    final results = await db.select(db.goalTable).get();

    return results.map((g) => Evidence(
      source: 'Wealth Builder',
      timestamp: DateTime.now(),
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'goal',
        'id': g.id,
        'title': g.title,
        'progress': g.progress,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveEmails(DateTimeRange range) async {
    final results = await (db.select(db.gmailMessageTable)
      ..where((t) => t.messageDate.isBetween(Variable(range.start), Variable(range.end)))
      ..orderBy([(t) => OrderingTerm.desc(t.messageDate)])
      ..limit(10)).get();

    return results.map((m) => Evidence(
      source: 'Gmail',
      timestamp: m.messageDate,
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'email',
        'id': m.id,
        'subject': m.subject,
        'sender': m.sender,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveTasks(DateTimeRange range) async {
    final results = await db.missionDao.getAllTasks(); // Assuming this exists or using select directly

    return results.map((t) => Evidence(
      source: 'Planner Module',
      timestamp: DateTime.now(), // Tasks might not have a reliable "timestamp" in the table but we could use a dueDate if added
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'task',
        'id': t.id,
        'title': t.title,
        'isCompleted': t.isCompleted,
        'priority': t.priority,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveMissions(DateTimeRange range) async {
    final results = await db.missionDao.getAllMissions();

    return results.map((m) => Evidence(
      source: 'Mission Control',
      timestamp: m.createdAt,
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'mission',
        'id': m.id,
        'title': m.title,
        'status': m.status,
        'owningDomain': m.owningDomain,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveMemories(String query) async {
    final results = await db.memoryDao.searchMemories(query, limit: 10);

    return results.map((m) => Evidence(
      source: 'Life Atlas',
      timestamp: m.effectiveAt,
      trustWeight: m.confidence,
      isObserved: m.source == 'manual' || m.source == 'sensor',
      freshness: 1.0,
      metadata: {
        'type': 'memory',
        'id': m.memoryId,
        'summary': m.summary,
        'category': m.categoryId,
        'provenance': m.provenance,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveExtractedEntities(DateTimeRange range) async {
    final results = await db.extractedEntityDao.getAllEntities();

    return results.map((e) => Evidence(
      source: 'Extraction Engine',
      timestamp: e.eventTimestamp,
      trustWeight: e.confidenceScore ?? 0.5,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'extracted_entity',
        'id': e.id,
        'title': e.title,
        'summary': e.summary,
        'entityType': e.entityType,
      },
    )).toList();
  }

  Future<List<Evidence>> _retrieveDriveFiles(DateTimeRange range) async {
    final results = await (db.select(db.googleResourceTable)
      ..where((t) => t.resourceType.equals('drive'))
      ..orderBy([(t) => OrderingTerm.desc(t.resourceDate)])
      ..limit(10)).get();

    return results.map((r) => Evidence(
      source: 'Google Drive',
      timestamp: r.resourceDate,
      trustWeight: 1.0,
      isObserved: true,
      freshness: 1.0,
      metadata: {
        'type': 'drive_file',
        'id': r.id,
        'title': r.title,
      },
    )).toList();
  }
}
