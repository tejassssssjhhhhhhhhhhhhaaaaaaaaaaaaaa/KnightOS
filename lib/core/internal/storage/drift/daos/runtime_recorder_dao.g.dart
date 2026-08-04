// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runtime_recorder_dao.dart';

// ignore_for_file: type=lint
mixin _$RuntimeRecorderDaoMixin on DatabaseAccessor<KnightDatabase> {
  $RuntimeEventsTableTable get runtimeEventsTable =>
      attachedDatabase.runtimeEventsTable;
  RuntimeRecorderDaoManager get managers => RuntimeRecorderDaoManager(this);
}

class RuntimeRecorderDaoManager {
  final _$RuntimeRecorderDaoMixin _db;
  RuntimeRecorderDaoManager(this._db);
  $$RuntimeEventsTableTableTableManager get runtimeEventsTable =>
      $$RuntimeEventsTableTableTableManager(
        _db.attachedDatabase,
        _db.runtimeEventsTable,
      );
}
