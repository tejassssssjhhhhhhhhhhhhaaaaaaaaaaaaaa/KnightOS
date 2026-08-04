// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_dao.dart';

// ignore_for_file: type=lint
mixin _$SecurityDaoMixin on DatabaseAccessor<KnightDatabase> {
  $SecurityMetadataTableTable get securityMetadataTable =>
      attachedDatabase.securityMetadataTable;
  SecurityDaoManager get managers => SecurityDaoManager(this);
}

class SecurityDaoManager {
  final _$SecurityDaoMixin _db;
  SecurityDaoManager(this._db);
  $$SecurityMetadataTableTableTableManager get securityMetadataTable =>
      $$SecurityMetadataTableTableTableManager(
        _db.attachedDatabase,
        _db.securityMetadataTable,
      );
}
