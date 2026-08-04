import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/provider_sync_metadata.dart';

part 'sync_metadata_dao.g.dart';

@DriftAccessor(tables: [ProviderSyncMetadataTable])
class SyncMetadataDao extends BaseDao<ProviderSyncMetadataTable, ProviderSyncMetadata>
    with _$SyncMetadataDaoMixin {
  SyncMetadataDao(super.db);

  Future<ProviderSyncMetadata?> getMetadata(String providerId, String key) {
    return (select(providerSyncMetadataTable)
          ..where((t) => t.providerId.equals(providerId))
          ..where((t) => t.stateKey.equals(key)))
        .getSingleOrNull();
  }

  Future<void> upsertMetadata(ProviderSyncMetadataTableCompanion companion) {
    return into(providerSyncMetadataTable).insertOnConflictUpdate(companion);
  }

  Future<String?> getValue(String providerId, String key) async {
    final meta = await getMetadata(providerId, key);
    return meta?.stateValue;
  }
}
