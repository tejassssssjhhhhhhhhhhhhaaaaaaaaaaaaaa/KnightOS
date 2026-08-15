import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/missions.dart';
import '../tables/goals.dart';
import '../tables/tasks.dart';

part 'mission_dao.g.dart';

@DriftAccessor(tables: [MissionTable, GoalTable, TaskTable])
class MissionDao extends DatabaseAccessor<KnightDatabase> with _$MissionDaoMixin {
  MissionDao(super.db);

  Future<List<MissionData>> getAllMissions() => select(missionTable).get();
  
  Future<List<GoalData>> getGoalsForMission(String missionId) {
    return (select(goalTable)..where((t) => t.missionId.equals(missionId))).get();
  }

  Future<List<TaskData>> getTasksForGoal(String goalId) {
    return (select(taskTable)..where((t) => t.goalId.equals(goalId))).get();
  }

  Future<List<TaskData>> getTodaysTasks() {
    return select(taskTable).get(); // Simplified for now
  }

  Future<List<TaskData>> getAllTasks() => select(taskTable).get();

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    await (update(taskTable)..where((t) => t.id.equals(taskId)))
      .write(TaskTableCompanion(isCompleted: Value(isCompleted)));
  }

  Future<void> upsertMission(MissionTableCompanion entry) => 
    into(missionTable).insertOnConflictUpdate(entry);

  Future<void> upsertGoal(GoalTableCompanion entry) => 
    into(goalTable).insertOnConflictUpdate(entry);

  Future<void> upsertTask(TaskTableCompanion entry) => 
    into(taskTable).insertOnConflictUpdate(entry);
}
