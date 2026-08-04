// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_metadata_dao.dart';

// ignore_for_file: type=lint
mixin _$SyncMetadataDaoMixin on DatabaseAccessor<KnightDatabase> {
  $ProviderSyncMetadataTableTable get providerSyncMetadataTable =>
      attachedDatabase.providerSyncMetadataTable;
  SyncMetadataDaoManager get managers => SyncMetadataDaoManager(this);
}

class SyncMetadataDaoManager {
  final _$SyncMetadataDaoMixin _db;
  SyncMetadataDaoManager(this._db);
  $$ProviderSyncMetadataTableTableTableManager get providerSyncMetadataTable =>
      $$ProviderSyncMetadataTableTableTableManager(
        _db.attachedDatabase,
        _db.providerSyncMetadataTable,
      );
}
