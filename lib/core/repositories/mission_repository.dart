import '../internal/storage/drift/knight_database.dart';
import '../intelligence/services/knowledge_graph_weaver.dart';

class MissionWithProgress {
  final MissionData mission;
  final double progress;
  final int totalTasks;
  final int completedTasks;

  MissionWithProgress({
    required this.mission,
    required this.progress,
    required this.totalTasks,
    required this.completedTasks,
  });
}

class MissionRepository {
  final KnightDatabase db;
  final KnowledgeGraphWeaver weaver;
  MissionRepository({required this.db, required this.weaver});

  Future<List<MissionWithProgress>> getMissionsWithProgress() async {
    final missions = await db.missionDao.getAllMissions();
    final List<MissionWithProgress> results = [];

    for (final m in missions) {
      final goals = await db.missionDao.getGoalsForMission(m.id);
      int total = 0;
      int completed = 0;

      for (final g in goals) {
        final tasks = await db.missionDao.getTasksForGoal(g.id);
        total += tasks.length;
        completed += tasks.where((t) => t.isCompleted).length;
      }

      final progress = total == 0 ? 0.0 : completed / total;
      results.add(MissionWithProgress(
        mission: m,
        progress: progress,
        totalTasks: total,
        completedTasks: completed,
      ));
    }

    return results;
  }

  Future<void> createMission(MissionTableCompanion m, List<GoalTableCompanion> goals, List<TaskTableCompanion> tasks) async {
    await db.transaction(() async {
      await db.missionDao.upsertMission(m);
      for (final g in goals) {
        await db.missionDao.upsertGoal(g);
      }
      for (final t in tasks) {
        await db.missionDao.upsertTask(t);
      }
    });
    
    // Weave into graph
    // (Fetch back as Data classes to weave)
    final missionData = await (db.select(db.missionTable)..where((t) => t.id.equals(m.id.value))).getSingle();
    final goalsData = await db.missionDao.getGoalsForMission(missionData.id);
    final tasksData = await (db.select(db.taskTable)..where((t) => t.goalId.isIn(goalsData.map((g) => g.id).toList()))).get();
    
    await weaver.weaveMission(missionData, goalsData, tasksData);
  }
}
