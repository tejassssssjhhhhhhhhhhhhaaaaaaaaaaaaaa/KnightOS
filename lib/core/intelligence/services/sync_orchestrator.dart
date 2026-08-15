import 'package:drift/drift.dart';
import '../domain/data_provider.dart';
import '../domain/historical_sync_models.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';

/// Base class for managing synchronization state and lifecycle for any provider.
abstract class SyncOrchestrator {
  SyncOrchestrator({
    required this.db,
    required this.providerId,
  });

  final KnightDatabase db;
  final String providerId;

  int fetchedCount = 0;
  int createdCount = 0;
  int updatedCount = 0;
  int skippedCount = 0;
  int failedCount = 0;
  String? currentSyncId;

  SyncStats get stats => SyncStats(
    fetched: fetchedCount,
    created: createdCount,
    updated: updatedCount,
    skipped: skippedCount,
    failed: failedCount,
  );

  void resetStats() {
    fetchedCount = 0;
    createdCount = 0;
    updatedCount = 0;
    skippedCount = 0;
    failedCount = 0;
  }

  /// Fetches a persistent cursor value for the provider.
  Future<String?> getCursor(String key) async {
    return await db.syncMetadataDao.getValue(providerId, key);
  }

  /// Updates a persistent cursor value.
  Future<void> updateCursor(String key, String value) async {
    await db.syncMetadataDao.upsertMetadata(ProviderSyncMetadataTableCompanion.insert(
      id: '$providerId-$key',
      providerId: providerId,
      stateKey: key,
      stateValue: value,
      lastUpdated: Value(DateTime.now()),
    ));
    KnightLogger.info('[SYNC] Updated cursor: $providerId.$key -> $value');
  }

  /// High-level sync execution.
  Future<void> runSync() async {
    final startTime = DateTime.now();
    currentSyncId = 'sync-$providerId-${startTime.millisecondsSinceEpoch}';
    resetStats();

    await db.syncHistoryDao.insertRecord(SyncHistoryTableCompanion.insert(
      id: currentSyncId!,
      providerId: providerId,
      startTime: startTime,
      status: 'in_progress',
    ));

    try {
      KnightLogger.info('[SYNC] Starting sync for $providerId');
      await executeSync();

      await db.syncHistoryDao.updateRecord(SyncHistoryTableCompanion(
        id: Value(currentSyncId!),
        endTime: Value(DateTime.now()),
        status: const Value('success'),
        fetchedCount: Value(fetchedCount),
        createdCount: Value(createdCount),
        updatedCount: Value(updatedCount),
        skippedCount: Value(skippedCount),
        failedCount: Value(failedCount),
      ));
      KnightLogger.info('[SYNC] Sync completed for $providerId');
    } catch (e) {
      KnightLogger.error('[SYNC] Sync failed for $providerId', error: e);
      String errorMsg = e.toString();
      
      // Sprint V5.2: Detect common auth failures to guide user
      if (errorMsg.contains('UNAUTHENTICATED') || errorMsg.contains('401')) {
         errorMsg = 'AUTH_FAILURE: Session expired or invalid. Please re-connect Google.';
      } else if (errorMsg.contains('PERMISSION_DENIED') || errorMsg.contains('403')) {
         errorMsg = 'SCOPE_FAILURE: Required permissions missing or API disabled.';
      }

      await db.syncHistoryDao.updateRecord(SyncHistoryTableCompanion(
        id: Value(currentSyncId!),
        endTime: Value(DateTime.now()),
        status: const Value('failed'),
        errorSummary: Value(errorMsg),
        fetchedCount: Value(fetchedCount),
        createdCount: Value(createdCount),
        updatedCount: Value(updatedCount),
        skippedCount: Value(skippedCount),
        failedCount: Value(failedCount),
      ));
      rethrow;
    }
  }

  /// Implementation-specific sync logic.
  Future<void> executeSync();

  /// --- Historical Ingestion Model (D1.3.1) ---

  /// Retrieves the current persistent state of historical ingestion.
  Future<HistoricalSyncState> getHistoricalState() async {
    final status = await getCursor('historical_status') ?? 'pending';
    final startStr = await getCursor('historical_range_start');
    final endStr = await getCursor('historical_range_end');
    final cursorStr = await getCursor('historical_cursor');
    final error = await getCursor('historical_error');

    return HistoricalSyncState(
      status: status,
      rangeStart: startStr != null ? DateTime.tryParse(startStr) : null,
      rangeEnd: endStr != null ? DateTime.tryParse(endStr) : null,
      lastSuccessfulSliceEnd:
          cursorStr != null ? DateTime.tryParse(cursorStr) : null,
      error: error,
    );
  }

  /// Initializes or resets a historical job range.
  Future<void> initHistoricalJob(DateTime start, DateTime end) async {
    await updateCursor('historical_range_start', start.toIso8601String());
    await updateCursor('historical_range_end', end.toIso8601String());
    await updateCursor('historical_status', 'pending');
    await updateCursor('historical_cursor', start.toIso8601String());
    await updateCursor('historical_error', '');
    KnightLogger.info(
      '[HISTORICAL] Initialized job for $providerId: ${start.toIso8601String()} to ${end.toIso8601String()}',
    );
  }

  /// Marks a specific slice as completed and updates the checkpoint.
  /// If the slice reaches or exceeds the range end, the job is marked 'completed'.
  Future<void> completeHistoricalSlice(DateTime sliceEnd) async {
    final state = await getHistoricalState();
    await updateCursor('historical_cursor', sliceEnd.toIso8601String());

    final totalEnd = state.rangeEnd;
    if (totalEnd != null &&
        (sliceEnd.isAfter(totalEnd) || sliceEnd.isAtSameMomentAs(totalEnd))) {
      await updateCursor('historical_status', 'completed');
      KnightLogger.info('[HISTORICAL] Job COMPLETED for $providerId');
    } else {
      await updateCursor('historical_status', 'in_progress');
      KnightLogger.info(
        '[HISTORICAL] Slice completed for $providerId. Next start: ${sliceEnd.toIso8601String()}',
      );
    }
  }

  /// Records a failure in the historical job to prevent silent stalling.
  Future<void> recordHistoricalFailure(String error) async {
    await updateCursor('historical_status', 'failed');
    await updateCursor('historical_error', error);
    KnightLogger.error('[HISTORICAL] Job FAILED for $providerId: $error');
  }
}
