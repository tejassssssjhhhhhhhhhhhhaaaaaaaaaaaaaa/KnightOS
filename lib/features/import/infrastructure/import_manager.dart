import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/hashing_service.dart';
import '../../../core/intelligence/engines/memory_engine.dart';
import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../core/intelligence/domain/memory_category.dart';
import '../../../core/intelligence/domain/memory_domain.dart';
import '../../../core/domain/models/models.dart';
import '../domain/import_models.dart';
import '../domain/import_provider.dart';
import '../domain/import_manifest.dart';

/// Orchestrates the lifecycle of an ingestion mission.
class ImportManager {
  const ImportManager._();

  /// Processes a file through the pipeline using background logic.
  static Future<ImportJob> executeMission(
    File file,
    ImportProvider provider,
    MemoryEngine memoryEngine,
  ) async {
    final jobId = const Uuid().v4();
    final startedAt = DateTime.now();

    // 1. DEDUPLICATION (SHA-256)
    final hash = await HashingService.calculateFileHash(file);
    final isDuplicate = await HashingService.isDuplicate(hash);

    if (isDuplicate) {
      return ImportJob(
        id: jobId,
        sourceId: provider.id,
        status: ImportStatus.failed,
        progress: 0.0,
        startedAt: startedAt,
        error: 'IDEMPOTENCY ALERT: Duplicate file detected.',
      );
    }

    // 2. PARSING
    try {
      final result = await provider.parse(file, jobId: jobId);
      final completedAt = DateTime.now();
      final duration = completedAt.difference(startedAt).inMilliseconds;

      if (result.success) {
        final List<KnightMemory> memoriesToSave = [];

        // 3. MAP TO MEMORY ENGINE
        for (final event in result.timelineEvents) {
          if (event is TimelineEvent) {
            memoriesToSave.add(
              KnightMemory.create(
                memoryId: event.id,
                category: _mapTimelineToBook(event.category),
                domain: _mapTimelineToDomain(event.category),
                source: MemorySource.imported,
                content: event.content,
                summary: event.title,
                effectiveAt: event.timestamp,
                tags: event.tags,
                verified: true,
                provenance: file.path.split(Platform.pathSeparator).last,
              ),
            );
          }
        }

        for (final doc in result.documents) {
          if (doc is Document) {
            memoriesToSave.add(
              KnightMemory.create(
                memoryId: doc.id,
                category: _mapDocumentToBook(doc.category),
                domain: _mapDocumentToDomain(doc.category),
                source: MemorySource.imported,
                content: {
                  'title': doc.title,
                  'path': doc.sourcePath,
                  'size': doc.fileSize,
                },
                summary: 'Document: ${doc.title}',
                effectiveAt: doc.addedAt,
                tags: doc.tags,
                verified: true,
                provenance: file.path.split(Platform.pathSeparator).last,
              ),
            );
          }
        }

        for (final tx in result.transactions) {
          if (tx is FinancialTransaction) {
            memoriesToSave.add(
              KnightMemory.create(
                memoryId: tx.id,
                category: BookCategory.finance,
                domain: MemoryDomain.finance,
                source: MemorySource.imported,
                content: {
                  'amount': tx.amount,
                  'description': tx.description,
                  'type': tx.type.name,
                  'merchant': tx.merchant,
                },
                summary: 'Transaction: ${tx.description} (${tx.amount})',
                effectiveAt: tx.date,
                tags: tx.tags,
                verified: true,
                provenance: file.path.split(Platform.pathSeparator).last,
              ),
            );
          }
        }

        // COMMIT IN BULK
        if (memoriesToSave.isNotEmpty) {
          await memoryEngine.saveAll(memoriesToSave);
        }
      }

      // 4. GENERATE MANIFEST
      final manifest = ImportManifest(
        jobId: jobId,
        sourceId: provider.id,
        fileName: file.path.split(Platform.pathSeparator).last,
        fileHash: hash,
        importedAt: completedAt,
        recordCount:
            result.timelineEvents.length +
            result.documents.length +
            result.transactions.length,
        durationMs: duration,
        status: result.success ? ImportStatus.completed : ImportStatus.failed,
        errorMessage: result.message,
      );

      debugPrint('--- IMPORT MANIFEST ---');
      debugPrint('JOB: ${manifest.jobId}');
      debugPrint('FILE: ${manifest.fileName}');
      debugPrint('RECORDS: ${manifest.recordCount}');
      debugPrint('-----------------------');

      return ImportJob(
        id: jobId,
        sourceId: provider.id,
        status: manifest.status,
        progress: 1.0,
        startedAt: startedAt,
        completedAt: completedAt,
        processedCount: manifest.recordCount,
        totalCount: manifest.recordCount,
      );
    } catch (e) {
      return ImportJob(
        id: jobId,
        sourceId: provider.id,
        status: ImportStatus.failed,
        progress: 0.0,
        startedAt: startedAt,
        error: 'PIPELINE CRITICAL: $e',
      );
    }
  }

  static BookCategory _mapTimelineToBook(TimelineCategory category) {
    switch (category) {
      case TimelineCategory.health:
        return BookCategory.health;
      case TimelineCategory.finance:
        return BookCategory.finance;
      case TimelineCategory.travel:
        return BookCategory.history;
      case TimelineCategory.learning:
        return BookCategory.skills;
      case TimelineCategory.work:
        return BookCategory.career;
      case TimelineCategory.fitness:
        return BookCategory.health;
      case TimelineCategory.personal:
        return BookCategory.identity;
      case TimelineCategory.achievement:
        return BookCategory.ambitions;
    }
  }

  static MemoryDomain _mapTimelineToDomain(TimelineCategory category) {
    switch (category) {
      case TimelineCategory.health:
        return MemoryDomain.health;
      case TimelineCategory.finance:
        return MemoryDomain.finance;
      case TimelineCategory.travel:
        return MemoryDomain.travel;
      case TimelineCategory.learning:
        return MemoryDomain.knowledge;
      case TimelineCategory.work:
        return MemoryDomain.career;
      case TimelineCategory.fitness:
        return MemoryDomain.habits;
      case TimelineCategory.personal:
        return MemoryDomain.identity;
      case TimelineCategory.achievement:
        return MemoryDomain.achievements;
    }
  }

  static BookCategory _mapDocumentToBook(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.book:
        return BookCategory.skills;
      case DocumentCategory.pdf:
        return BookCategory.history;
      case DocumentCategory.note:
        return BookCategory.history;
      case DocumentCategory.image:
        return BookCategory.history;
      case DocumentCategory.voice:
        return BookCategory.history;
      case DocumentCategory.certificate:
        return BookCategory.ambitions;
      case DocumentCategory.identity:
        return BookCategory.identity;
      case DocumentCategory.career:
        return BookCategory.career;
      case DocumentCategory.medical:
        return BookCategory.health;
      case DocumentCategory.finance:
        return BookCategory.finance;
      case DocumentCategory.other:
        return BookCategory.unknown;
    }
  }

  static MemoryDomain _mapDocumentToDomain(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.book:
        return MemoryDomain.knowledge;
      case DocumentCategory.pdf:
        return MemoryDomain.documents;
      case DocumentCategory.note:
        return MemoryDomain.memories;
      case DocumentCategory.image:
        return MemoryDomain.memories;
      case DocumentCategory.voice:
        return MemoryDomain.memories;
      case DocumentCategory.certificate:
        return MemoryDomain.achievements;
      case DocumentCategory.identity:
        return MemoryDomain.identity;
      case DocumentCategory.career:
        return MemoryDomain.career;
      case DocumentCategory.medical:
        return MemoryDomain.health;
      case DocumentCategory.finance:
        return MemoryDomain.finance;
      case DocumentCategory.other:
        return MemoryDomain.unknowns;
    }
  }
}
