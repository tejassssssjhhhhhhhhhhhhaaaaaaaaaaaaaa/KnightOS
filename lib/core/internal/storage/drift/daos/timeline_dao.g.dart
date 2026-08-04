// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_dao.dart';

// ignore_for_file: type=lint
mixin _$TimelineDaoMixin on DatabaseAccessor<KnightDatabase> {
  $ImportHistoryTableTable get importHistoryTable =>
      attachedDatabase.importHistoryTable;
  $TimelineEventTableTable get timelineEventTable =>
      attachedDatabase.timelineEventTable;
  TimelineDaoManager get managers => TimelineDaoManager(this);
}

class TimelineDaoManager {
  final _$TimelineDaoMixin _db;
  TimelineDaoManager(this._db);
  $$ImportHistoryTableTableTableManager get importHistoryTable =>
      $$ImportHistoryTableTableTableManager(
        _db.attachedDatabase,
        _db.importHistoryTable,
      );
  $$TimelineEventTableTableTableManager get timelineEventTable =>
      $$TimelineEventTableTableTableManager(
        _db.attachedDatabase,
        _db.timelineEventTable,
      );
}
