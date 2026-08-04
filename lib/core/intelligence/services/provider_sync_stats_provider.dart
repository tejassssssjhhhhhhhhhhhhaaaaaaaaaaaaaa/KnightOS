import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../providers/database_provider.dart';

class ProviderSyncStats {
  final String status;
  final DateTime? lastSync;
  final DateTime? lastStart;
  final Duration? lastDuration;
  final int totalIndexed;
  final int duplicatesPrevented;
  final int pendingTasks;
  final int failedTasks;
  final String? lastError;
  final Map<String, String> metadata;

  ProviderSyncStats({
    required this.status,
    this.lastSync,
    this.lastStart,
    this.lastDuration,
    required this.totalIndexed,
    required this.duplicatesPrevented,
    required this.pendingTasks,
    required this.failedTasks,
    this.lastError,
    required this.metadata,
  });
}

final providerSyncStatsProvider = StreamProvider.family<ProviderSyncStats, String>((ref, providerId) async* {
  final db = ref.watch(knightDatabaseProvider);
  
  // Watch metadata table for real-time updates for this specific provider
  final metadataStream = db.select(db.providerSyncMetadataTable).watch();

  yield* metadataStream.asyncMap((_) async {
    final status = await db.syncMetadataDao.getValue(providerId, 'sync_status') ?? 'idle';
    final totalIndexedStr = await db.syncMetadataDao.getValue(providerId, 'total_emails_indexed') ?? 
                           await db.syncMetadataDao.getValue(providerId, 'total_events_indexed') ?? '0';
    final duplicatesStr = await db.syncMetadataDao.getValue(providerId, 'total_duplicates_prevented') ?? '0';
    final lastSyncStr = await db.syncMetadataDao.getValue(providerId, 'last_successful_sync');
    final lastStartStr = await db.syncMetadataDao.getValue(providerId, 'sync_start_time');
    final durationStr = await db.syncMetadataDao.getValue(providerId, 'sync_duration_ms');
    final lastError = await db.syncMetadataDao.getValue(providerId, 'last_sync_error');

    final pending = await db.customSelect("SELECT COUNT(*) as c FROM sync_task_queue WHERE status = 'pending' AND provider_id = ?", 
        variables: [Variable.withString(providerId)]).getSingle();
    final failed = await db.customSelect("SELECT COUNT(*) as c FROM sync_task_queue WHERE status = 'failed' AND provider_id = ?", 
        variables: [Variable.withString(providerId)]).getSingle();

    return ProviderSyncStats(
      status: status,
      totalIndexed: int.tryParse(totalIndexedStr) ?? 0,
      duplicatesPrevented: int.tryParse(duplicatesStr) ?? 0,
      lastSync: lastSyncStr != null ? DateTime.tryParse(lastSyncStr) : null,
      lastStart: lastStartStr != null ? DateTime.tryParse(lastStartStr) : null,
      lastDuration: durationStr != null ? Duration(milliseconds: int.tryParse(durationStr) ?? 0) : null,
      pendingTasks: pending.read<int>('c'),
      failedTasks: failed.read<int>('c'),
      lastError: lastError,
      metadata: {},
    );
  });
});
