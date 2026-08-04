// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_dao.dart';

// ignore_for_file: type=lint
mixin _$PrivacyDaoMixin on DatabaseAccessor<KnightDatabase> {
  $DataPrivacyMetadataTableTable get dataPrivacyMetadataTable =>
      attachedDatabase.dataPrivacyMetadataTable;
  PrivacyDaoManager get managers => PrivacyDaoManager(this);
}

class PrivacyDaoManager {
  final _$PrivacyDaoMixin _db;
  PrivacyDaoManager(this._db);
  $$DataPrivacyMetadataTableTableTableManager get dataPrivacyMetadataTable =>
      $$DataPrivacyMetadataTableTableTableManager(
        _db.attachedDatabase,
        _db.dataPrivacyMetadataTable,
      );
}
