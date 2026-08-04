import 'dart:io';
import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../importers/timeline_parser.dart';
import '../importers/financial_parser.dart';
import '../importers/base_parser.dart';
import '../engines/memory_engine.dart';
import '../domain/knight_memory.dart';
import 'document_hash_service.dart';
import 'import_preference_service.dart';
import 'knowledge_graph_service.dart';
import 'knowledge_graph_weaver.dart';
import '../../internal/utils/knight_logger.dart';

class DataIngestionService {
  DataIngestionService({
    required this.db,
    required this.hashService,
    required this.prefsService,
    required this.graphService,
    required this.graphWeaver,
    required this.memoryEngine,
  });

  final KnightDatabase db;
  final DocumentHashService hashService;
  final ImportPreferenceService prefsService;
  final KnowledgeGraphService graphService;
  final KnowledgeGraphWeaver graphWeaver;
  final MemoryEngine memoryEngine;

  final _timelineParser = TimelineParser();
  final _financialParser = FinancialParser();

  Future<void> runFullIngestion() async {
    final paths = prefsService.getImportPaths();
    KnightLogger.info('[INGESTION] Starting full scan for paths: $paths');

    for (final path in paths) {
      final dir = Directory(path);
      if (!await dir.exists()) {
        KnightLogger.warn('[INGESTION] Path does not exist: $path');
        continue;
      }

      final files = dir.listSync();
      for (final entity in files) {
        if (entity is File) {
          await _processFile(entity);
        }
      }
    }
    KnightLogger.info('[INGESTION] Full scan complete.');
  }

  /// Ingests structured data from cloud providers (Gmail, Calendar, etc.)
  Future<void> ingestCloudData(String providerId, ParsedData data) async {
    KnightLogger.info('[INGESTION] Ingesting cloud data from $providerId');
    final importId = 'cloud-$providerId-${DateTime.now().millisecondsSinceEpoch}';
    
    await _saveCloudData(importId, providerId, data);
    
    // Weave into Graph
    await _weaveCloudIntoGraph(importId, providerId, data);
  }

  /// Ingests Google Workspace memories and links them to the graph.
  Future<void> ingestWorkspaceMemories(List<KnightMemory> memories) async {
    KnightLogger.info('[INGESTION] Ingesting ${memories.length} workspace memories');
    
    await memoryEngine.saveAll(memories);

    for (final memory in memories) {
      final nodeId = await graphService.ensureNode(
        type: 'workspace_memory',
        label: memory.summary ?? 'Workspace Activity',
        externalTable: 'memories',
        externalId: memory.id,
        metadata: {
          'category': memory.category.name,
          'provenance': memory.metadata.provenance,
        },
      );

      // Link to appropriate graph anchors
      if (memory.metadata.provenance == 'gmail_api') {
        await graphWeaver.linkToEmailSource(nodeId, memory.content['id'] as String);
      } else if (memory.metadata.provenance == 'google_calendar_api') {
        await graphWeaver.linkToCalendarSource(nodeId, memory.content['id'] as String);
      }
    }
  }

  Future<void> _saveCloudData(String importId, String providerId, ParsedData data) async {
     int recordCount = 0;
    
    await db.transaction(() async {
      // 1. Transactions
      for (final tx in data.transactions) {
        final t = tx as TransactionTableCompanion;
        final hash = t.dedupeHash.value;
        
        final existing = await db.financialDao.transactionExists(hash);
        if (!existing) {
          await db.financialDao.insertTransaction(t.copyWith(syncStatus: const Value('synced')));
          recordCount++;
        }
      }

      // 2. Timeline Events
      for (final ev in data.timelineEvents) {
        final comp = ev as TimelineEventTableCompanion;
        final existing = await (db.select(db.timelineEventTable)..where((t) => t.id.equals(comp.id.value))).getSingleOrNull();
        if (existing == null) {
          await db.timelineDao.insertEvents([comp.copyWith(syncStatus: const Value('synced'))]);
          recordCount++;
        }
      }

      // 3. Health Metrics
      for (final m in data.healthMetrics) {
        final comp = m as HealthMetricTableCompanion;
        final existing = await (db.select(db.healthMetricTable)..where((t) => t.id.equals(comp.id.value))).getSingleOrNull();
        if (existing == null) {
          await db.healthDao.insertMetrics([comp.copyWith(syncStatus: const Value('synced'))]);
          recordCount++;
        }
      }
    });

    KnightLogger.info('[INGESTION] Cloud ingest success: $recordCount records from $providerId');
  }

  Future<void> _weaveCloudIntoGraph(String importId, String providerId, ParsedData data) async {
    // 1. Transactions
    for (final tx in data.transactions) {
      final t = tx as TransactionTableCompanion;
      final txNodeId = await graphService.ensureNode(
        type: 'transaction',
        label: t.description.value,
        externalTable: 'transactions',
        externalId: t.id.value,
      );
      
      final orgName = _extractOrgFromDescription(t.description.value);
      await graphWeaver.linkToOrganization(txNodeId, orgName);
    }

    // 2. Timeline
    for (final ev in data.timelineEvents) {
      final e = ev as TimelineEventTableCompanion;
      final evNodeId = await graphService.ensureNode(
        type: 'timeline_event',
        label: e.title.value,
        externalTable: 'timeline_events',
        externalId: e.id.value,
      );
      
      if (e.type.value == 'visit') {
        await graphWeaver.linkToPlace(evNodeId, e.title.value);
      }
    }
  }

  Future<void> _processFile(File file) async {
    final fileName = file.path.split('/').last;
    final hash = await hashService.calculateHash(file);

    // 1. Check for duplicate FILE
    final existingImport = await db.importDao.getByHash(hash);
    if (existingImport != null) {
      KnightLogger.info('[INGESTION] Skipping duplicate file: $fileName');
      return;
    }

    KnightLogger.info('[INGESTION] Processing: $fileName');
    
    final importId = 'imp-${DateTime.now().millisecondsSinceEpoch}';
    const providerId = 'local_file_provider';
    
    try {
      ParsedData? data;
      if (fileName.endsWith('.json') && fileName.contains('Timeline')) {
        data = await _timelineParser.parse(file);
      } 
      else if (fileName.endsWith('.pdf')) {
        data = await _financialParser.parse(file);
      }

      if (data != null) {
        await _saveParsedData(importId, providerId, hash, file, data);
        await _weaveIntoGraph(importId, providerId, file, data);
      }
    } catch (e) {
      KnightLogger.error('[INGESTION] Failed to process $fileName', error: e);
      await _recordFailure(importId, providerId, hash, file, 'unknown', e.toString());
    }
  }

  Future<void> _weaveIntoGraph(String importId, String providerId, File file, ParsedData data) async {
    // 1. Weave Document Node
    final docNodeId = await graphService.ensureNode(
      type: 'document',
      label: file.path.split('/').last,
      externalTable: 'import_history',
      externalId: importId,
      metadata: {'path': file.path},
    );

    // 2. Weave Transactions
    for (final tx in data.transactions) {
      final t = tx as TransactionTableCompanion;
      final txNodeId = await graphService.ensureNode(
        type: 'transaction',
        label: t.description.value,
        externalTable: 'transactions',
        externalId: t.id.value,
      );
      
      await graphService.link(
        fromId: docNodeId,
        toId: txNodeId,
        relationship: 'attachments',
      );

      // Weave Organization Node
      final orgName = _extractOrgFromDescription(t.description.value);
      await graphWeaver.linkToOrganization(txNodeId, orgName);
    }

    // 3. Weave Timeline
    for (final ev in data.timelineEvents) {
      final e = ev as TimelineEventTableCompanion;
      final evNodeId = await graphService.ensureNode(
        type: 'timeline_event',
        label: e.title.value,
        externalTable: 'timeline_events',
        externalId: e.id.value,
      );

      await graphService.link(
        fromId: docNodeId,
        toId: evNodeId,
        relationship: 'chronology',
      );
      
      if (e.type.value == 'visit') {
        await graphWeaver.linkToPlace(evNodeId, e.title.value);
      }
    }
  }

  String _extractOrgFromDescription(String desc) {
    final parts = desc.split(' ');
    if (parts.length > 1) return '${parts[0]} ${parts[1]}';
    return parts[0];
  }

  Future<void> _saveParsedData(
    String importId, 
    String providerId, 
    String fileHash, 
    File file, 
    ParsedData data
  ) async {
    int recordCount = 0;
    
    await db.transaction(() async {
      // 1. Transactions
      if (data.transactions.isNotEmpty) {
        await _ensureAccountsExist();
        for (final tx in data.transactions) {
          final t = tx as TransactionTableCompanion;
          final hash = t.dedupeHash.value;
          
          final existing = await db.financialDao.transactionExists(hash);
          if (!existing) {
             final updated = t.copyWith(
              sourceProvider: Value(providerId),
              sourceIdentifier: Value(file.path),
              contentHash: Value(hash),
              syncStatus: const Value('synced'),
            );
            await db.financialDao.insertTransaction(updated);
            recordCount++;
          }
        }
      }

      // 2. Health Metrics
      if (data.healthMetrics.isNotEmpty) {
        for (final m in data.healthMetrics) {
           final comp = m as HealthMetricTableCompanion;
           final existing = await (db.select(db.healthMetricTable)..where((t) => t.id.equals(comp.id.value))).getSingleOrNull();
           if (existing == null) {
              final updated = comp.copyWith(
                sourceProvider: Value(providerId),
                sourceIdentifier: Value(file.path),
                contentHash: Value(comp.id.value),
                syncStatus: const Value('synced'),
              );
              await db.healthDao.insertMetrics([updated]);
              recordCount++;
           }
        }
      }

      // 3. Timeline Events
      if (data.timelineEvents.isNotEmpty) {
        for (final ev in data.timelineEvents) {
          final comp = ev as TimelineEventTableCompanion;
          final existing = await (db.select(db.timelineEventTable)..where((t) => t.id.equals(comp.id.value))).getSingleOrNull();
          if (existing == null) {
            final updated = comp.copyWith(
              sourceProvider: Value(providerId),
              sourceIdentifier: Value(file.path),
              contentHash: Value(comp.id.value),
              syncStatus: const Value('synced'),
            );
            await db.timelineDao.insertEvents([updated]);
            recordCount++;
          }
        }
      }
    });

    await _recordSuccess(importId, providerId, fileHash, file, 'multi', recordCount);
  }

  Future<void> _ensureAccountsExist() async {
    await db.financialDao.upsertAccount(FinancialAccountTableCompanion.insert(
      id: 'main-savings',
      name: 'Primary Savings',
      institution: 'Knight Bank',
      type: 'savings',
      syncStatus: const Value('local_only'),
    ));
    await db.financialDao.upsertAccount(FinancialAccountTableCompanion.insert(
      id: 'primary-credit',
      name: 'Main Credit Card',
      institution: 'Knight Credit',
      type: 'credit',
      syncStatus: const Value('local_only'),
    ));
  }

  Future<void> _recordSuccess(String id, String providerId, String hash, File file, String type, int count) async {
    await db.importDao.upsert(db.importHistoryTable, ImportHistoryTableCompanion.insert(
      id: id,
      sourceProvider: Value(providerId),
      sourceIdentifier: Value(file.path),
      contentHash: Value(hash),
      fileName: file.path.split('/').last,
      filePath: file.path,
      docType: type,
      recordCount: Value(count),
      status: const Value('success'),
      syncStatus: const Value('synced'),
      createdAt: Value(DateTime.now()),
    ));
  }

  Future<void> _recordFailure(String id, String providerId, String hash, File file, String type, String error) async {
    await db.importDao.upsert(db.importHistoryTable, ImportHistoryTableCompanion.insert(
      id: id,
      sourceProvider: Value(providerId),
      sourceIdentifier: Value(file.path),
      contentHash: Value(hash),
      fileName: file.path.split('/').last,
      filePath: file.path,
      docType: type,
      status: const Value('failed'),
      errorMessage: Value(error),
      syncStatus: const Value('error'),
      createdAt: Value(DateTime.now()),
    ));
  }
}
