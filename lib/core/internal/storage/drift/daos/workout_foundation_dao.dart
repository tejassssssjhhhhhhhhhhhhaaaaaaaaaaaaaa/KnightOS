import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/workout_foundation.dart';
import '../tables/workout_sessions.dart';

part 'workout_foundation_dao.g.dart';

@DriftAccessor(tables: [ExerciseLibraryTable, EquipmentProfileTable, WorkoutSessionTable, WorkoutSetTable])
class WorkoutFoundationDao extends DatabaseAccessor<KnightDatabase> with _$WorkoutFoundationDaoMixin {
  WorkoutFoundationDao(super.db);

  Future<List<ExerciseData>> getAllExercises() => select(exerciseLibraryTable).get();

  Future<List<EquipmentData>> getOwnedEquipment() =>
      (select(equipmentProfileTable)..where((t) => t.isOwned.equals(true))).get();

  Future<void> logWorkout(WorkoutSessionTableCompanion session) =>
      into(workoutSessionTable).insert(session);

  Future<void> updateWorkout(WorkoutSessionTableCompanion session) =>
      (update(workoutSessionTable)..where((t) => t.id.equals(session.id.value))).write(session);

  Future<void> logSet(WorkoutSetTableCompanion set) =>
      into(workoutSetTable).insert(set);

  Future<List<WorkoutSessionData>> getRecentWorkouts({int limit = 10}) {
    return (select(workoutSessionTable)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
  }

  Future<List<WorkoutSetData>> getSetsForSession(String sessionId) {
    return (select(workoutSetTable)..where((t) => t.sessionId.equals(sessionId))).get();
  }

  Future<WorkoutSetData?> getLastSetForExercise(String exerciseName) {
    return (select(workoutSetTable)
          ..where((t) => t.exerciseName.equals(exerciseName))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(1))
        .getSingleOrNull();
  }
}
