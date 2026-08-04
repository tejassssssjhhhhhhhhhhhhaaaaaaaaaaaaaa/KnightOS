// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_tracker_dao.dart';

// ignore_for_file: type=lint
mixin _$WorkTrackerDaoMixin on DatabaseAccessor<KnightDatabase> {
  $WorkSessionTableTable get workSessionTable =>
      attachedDatabase.workSessionTable;
  WorkTrackerDaoManager get managers => WorkTrackerDaoManager(this);
}

class WorkTrackerDaoManager {
  final _$WorkTrackerDaoMixin _db;
  WorkTrackerDaoManager(this._db);
  $$WorkSessionTableTableTableManager get workSessionTable =>
      $$WorkSessionTableTableTableManager(
        _db.attachedDatabase,
        _db.workSessionTable,
      );
}
