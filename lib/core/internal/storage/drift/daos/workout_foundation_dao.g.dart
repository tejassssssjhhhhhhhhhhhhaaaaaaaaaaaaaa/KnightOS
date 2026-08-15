// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_foundation_dao.dart';

// ignore_for_file: type=lint
mixin _$WorkoutFoundationDaoMixin on DatabaseAccessor<KnightDatabase> {
  $ExerciseLibraryTableTable get exerciseLibraryTable =>
      attachedDatabase.exerciseLibraryTable;
  $EquipmentProfileTableTable get equipmentProfileTable =>
      attachedDatabase.equipmentProfileTable;
  $WorkoutSessionTableTable get workoutSessionTable =>
      attachedDatabase.workoutSessionTable;
  $WorkoutSetTableTable get workoutSetTable => attachedDatabase.workoutSetTable;
  WorkoutFoundationDaoManager get managers => WorkoutFoundationDaoManager(this);
}

class WorkoutFoundationDaoManager {
  final _$WorkoutFoundationDaoMixin _db;
  WorkoutFoundationDaoManager(this._db);
  $$ExerciseLibraryTableTableTableManager get exerciseLibraryTable =>
      $$ExerciseLibraryTableTableTableManager(
        _db.attachedDatabase,
        _db.exerciseLibraryTable,
      );
  $$EquipmentProfileTableTableTableManager get equipmentProfileTable =>
      $$EquipmentProfileTableTableTableManager(
        _db.attachedDatabase,
        _db.equipmentProfileTable,
      );
  $$WorkoutSessionTableTableTableManager get workoutSessionTable =>
      $$WorkoutSessionTableTableTableManager(
        _db.attachedDatabase,
        _db.workoutSessionTable,
      );
  $$WorkoutSetTableTableTableManager get workoutSetTable =>
      $$WorkoutSetTableTableTableManager(
        _db.attachedDatabase,
        _db.workoutSetTable,
      );
}
