import 'dart:async';
import 'package:drift/drift.dart';
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
    try {
      KnightLogger.info('[SYNC] Starting sync for $providerId');
      await executeSync();
      KnightLogger.info('[SYNC] Sync completed for $providerId');
    } catch (e) {
      KnightLogger.error('[SYNC] Sync failed for $providerId', error: e);
      rethrow;
    }
  }

  /// Implementation-specific sync logic.
  Future<void> executeSync();
}
