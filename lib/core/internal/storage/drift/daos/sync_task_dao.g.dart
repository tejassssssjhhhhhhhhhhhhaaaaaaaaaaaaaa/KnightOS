// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_task_dao.dart';

// ignore_for_file: type=lint
mixin _$SyncTaskDaoMixin on DatabaseAccessor<KnightDatabase> {
  $SyncTaskQueueTableTable get syncTaskQueueTable =>
      attachedDatabase.syncTaskQueueTable;
  SyncTaskDaoManager get managers => SyncTaskDaoManager(this);
}

class SyncTaskDaoManager {
  final _$SyncTaskDaoMixin _db;
  SyncTaskDaoManager(this._db);
  $$SyncTaskQueueTableTableTableManager get syncTaskQueueTable =>
      $$SyncTaskQueueTableTableTableManager(
        _db.attachedDatabase,
        _db.syncTaskQueueTable,
      );
}
