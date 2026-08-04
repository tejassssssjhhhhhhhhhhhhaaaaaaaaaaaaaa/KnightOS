// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_dao.dart';

// ignore_for_file: type=lint
mixin _$DeviceDaoMixin on DatabaseAccessor<KnightDatabase> {
  $DeviceRegistryTableTable get deviceRegistryTable =>
      attachedDatabase.deviceRegistryTable;
  DeviceDaoManager get managers => DeviceDaoManager(this);
}

class DeviceDaoManager {
  final _$DeviceDaoMixin _db;
  DeviceDaoManager(this._db);
  $$DeviceRegistryTableTableTableManager get deviceRegistryTable =>
      $$DeviceRegistryTableTableTableManager(
        _db.attachedDatabase,
        _db.deviceRegistryTable,
      );
}
