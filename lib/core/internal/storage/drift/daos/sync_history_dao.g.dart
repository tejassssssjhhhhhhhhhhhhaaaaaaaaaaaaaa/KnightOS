// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_history_dao.dart';

// ignore_for_file: type=lint
mixin _$SyncHistoryDaoMixin on DatabaseAccessor<KnightDatabase> {
  $SyncHistoryTableTable get syncHistoryTable =>
      attachedDatabase.syncHistoryTable;
  SyncHistoryDaoManager get managers => SyncHistoryDaoManager(this);
}

class SyncHistoryDaoManager {
  final _$SyncHistoryDaoMixin _db;
  SyncHistoryDaoManager(this._db);
  $$SyncHistoryTableTableTableManager get syncHistoryTable =>
      $$SyncHistoryTableTableTableManager(
        _db.attachedDatabase,
        _db.syncHistoryTable,
      );
}
