import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../providers/database_provider.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../domain/memory_metadata.dart';
import '../../internal/utils/stream_utils.dart';

class BrainMetrics {
  final int totalFacts;
  final int confirmed;
  final int inferred;
  final int needsReview;
  final int observed;
  final Map<int, int> domainCounts;

  BrainMetrics({
    this.totalFacts = 0,
    this.confirmed = 0,
    this.inferred = 0,
    this.needsReview = 0,
    this.observed = 0,
    this.domainCounts = const {},
  });
}

final brainMetricsProvider = StreamProvider<BrainMetrics>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = db.memoryDao;

  final totalStream = dao.watchTotalFactsCount();
  final stateCountsStream = dao.watchStateCounts();
  final domainCountsStream = dao.watchDomainCounts();

  return StreamUtils.combineLatest3<int, Map<String, int>, Map<int, int>, BrainMetrics>(
    totalStream,
    stateCountsStream,
    domainCountsStream,
    (total, stateCounts, domainCounts) {
      return BrainMetrics(
        totalFacts: total,
        confirmed: (stateCounts[KnowledgeState.userConfirmed.name] ?? 0),
        inferred: (stateCounts[KnowledgeState.inferred.name] ?? 0),
        needsReview: (stateCounts[KnowledgeState.needsReview.name] ?? 0),
        observed: (stateCounts[KnowledgeState.observed.name] ?? 0),
        domainCounts: domainCounts,
      );
    },
  );
});

enum BrainHealthStatus { optimal, good, fair, poor }

class BrainHealth {
  final BrainHealthStatus status;
  final double coverage;
  final double freshness;
  final int conflicts;
  final int verificationBacklog;
  final bool hasPossibleDataGap;

  BrainHealth({
    required this.status,
    required this.coverage,
    required this.freshness,
    required this.conflicts,
    required this.verificationBacklog,
    this.hasPossibleDataGap = false,
  });
}

final brainDataGapProvider = FutureProvider<bool>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  final allHistory = await db.select(db.syncHistoryTable).get();
  final totalEverFetched = allHistory.fold<int>(0, (sum, h) => sum + h.fetchedCount);
  
  final metrics = await ref.read(brainMetricsProvider.future);
  return totalEverFetched > metrics.totalFacts + 100;
});

final brainConflictsProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  // Real logic: Look for duplicate titles/dates in timeline or similar amounts in finance
  final conflicts = await (db.select(db.memoryTable)..where((t) => t.tags.like('%conflict%'))).get();
  return conflicts.length;
});

final brainFreshnessProvider = FutureProvider<double>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  final memories = await db.memoryDao.searchMemories('', limit: 100);
  if (memories.isEmpty) return 1.0;
  
  final now = DateTime.now();
  final staleCount = memories.where((m) => now.difference(m.updatedAt).inDays > 30).length;
  return (memories.length - staleCount) / memories.length;
});

final brainHealthProvider = Provider<BrainHealth>((ref) {
  final metricsAsync = ref.watch(brainMetricsProvider);
  final gapAsync = ref.watch(brainDataGapProvider);
  final conflictsAsync = ref.watch(brainConflictsProvider);
  final freshnessAsync = ref.watch(brainFreshnessProvider);
  
  return metricsAsync.when(
    data: (metrics) {
      final hasDataGap = gapAsync.value ?? false;
      final conflicts = conflictsAsync.value ?? 0;
      final freshness = freshnessAsync.value ?? 1.0;
      double coverage = metrics.totalFacts > 0 ? (metrics.confirmed + metrics.observed) / metrics.totalFacts : 1.0;
      int backlog = metrics.needsReview;
      
      BrainHealthStatus status = BrainHealthStatus.optimal;
      if (backlog > 50 || coverage < 0.5 || hasDataGap || conflicts > 0 || freshness < 0.6) {
        status = BrainHealthStatus.poor;
      } else if (backlog > 20 || coverage < 0.7 || freshness < 0.8) {
        status = BrainHealthStatus.fair;
      } else if (backlog > 5 || coverage < 0.9) {
        status = BrainHealthStatus.good;
      }

      return BrainHealth(
        status: status,
        coverage: coverage,
        freshness: freshness,
        conflicts: conflicts,
        verificationBacklog: backlog,
        hasPossibleDataGap: hasDataGap,
      );
    },
    loading: () => BrainHealth(status: BrainHealthStatus.good, coverage: 1.0, freshness: 1.0, conflicts: 0, verificationBacklog: 0),
    error: (_, __) => BrainHealth(status: BrainHealthStatus.poor, coverage: 0.0, freshness: 0.0, conflicts: 0, verificationBacklog: 0),
  );
});

class BrainSearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void update(String value) => state = value;
}

final brainSearchQueryProvider = NotifierProvider<BrainSearchQuery, String>(BrainSearchQuery.new);

final brainFilteredMemoriesProvider = FutureProvider((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  final query = ref.watch(brainSearchQueryProvider);
  
  return db.memoryDao.searchMemories(query);
});

class RelatedMemory {
  final MemoryRelationData relation;
  final MemoryTableData? memory;
  RelatedMemory(this.relation, this.memory);
}

final memoryRelationsProvider = FutureProvider.family<List<RelatedMemory>, String>((ref, memoryId) async {
  final db = ref.watch(knightDatabaseProvider);
  final relations = await db.memoryDao.getRelations(memoryId);
  
  final relatedMemories = <RelatedMemory>[];
  for (final r in relations) {
    final otherId = r.sourceId == memoryId ? r.targetId : r.sourceId;
    final otherMemory = await db.memoryDao.getLatestByMemoryId(otherId);
    relatedMemories.add(RelatedMemory(r, otherMemory));
  }
  return relatedMemories;
});
