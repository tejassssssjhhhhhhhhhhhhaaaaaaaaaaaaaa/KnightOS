// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_dao.dart';

// ignore_for_file: type=lint
mixin _$MissionDaoMixin on DatabaseAccessor<KnightDatabase> {
  $MissionTableTable get missionTable => attachedDatabase.missionTable;
  $GoalTableTable get goalTable => attachedDatabase.goalTable;
  $TaskTableTable get taskTable => attachedDatabase.taskTable;
  MissionDaoManager get managers => MissionDaoManager(this);
}

class MissionDaoManager {
  final _$MissionDaoMixin _db;
  MissionDaoManager(this._db);
  $$MissionTableTableTableManager get missionTable =>
      $$MissionTableTableTableManager(_db.attachedDatabase, _db.missionTable);
  $$GoalTableTableTableManager get goalTable =>
      $$GoalTableTableTableManager(_db.attachedDatabase, _db.goalTable);
  $$TaskTableTableTableManager get taskTable =>
      $$TaskTableTableTableManager(_db.attachedDatabase, _db.taskTable);
}
