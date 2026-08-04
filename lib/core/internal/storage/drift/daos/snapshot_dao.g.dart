// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snapshot_dao.dart';

// ignore_for_file: type=lint
mixin _$SnapshotDaoMixin on DatabaseAccessor<KnightDatabase> {
  $SystemSnapshotsTableTable get systemSnapshotsTable =>
      attachedDatabase.systemSnapshotsTable;
  SnapshotDaoManager get managers => SnapshotDaoManager(this);
}

class SnapshotDaoManager {
  final _$SnapshotDaoMixin _db;
  SnapshotDaoManager(this._db);
  $$SystemSnapshotsTableTableTableManager get systemSnapshotsTable =>
      $$SystemSnapshotsTableTableTableManager(
        _db.attachedDatabase,
        _db.systemSnapshotsTable,
      );
}
