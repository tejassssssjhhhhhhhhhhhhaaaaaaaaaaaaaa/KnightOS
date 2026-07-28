import '../../domain/mission_models.dart';
import '../memory_retrieval_engine.dart';
import '../../domain/memory_category.dart';

class ProgressIntelligenceEngine {
  const ProgressIntelligenceEngine({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  /// Calculates the completion percentage for a mission.
  Future<double> calculateCompletion(String missionId) async {
    final goals = await _getGoals(missionId);
    if (goals.isEmpty) return 0.0;

    final completedCount = goals.where((g) => g.isCompleted).length;
    return completedCount / goals.length;
  }

  /// Calculates a momentum score (0.0 to 1.0) based on recent activity.
  Future<double> calculateMomentum(String missionId) async {
    // Logic: Look at task completions in the last 7 days.
    return 0.75; // Placeholder
  }

  Future<List<Goal>> _getGoals(String missionId) async {
    final memories = await retrieval.getByCategory(BookCategory.ambitions);
    return memories
        .where(
          (m) =>
              m.missionDataType == 'goal' &&
              m.content['missionId'] == missionId,
        )
        .map((m) => m.toGoal()!)
        .toList();
  }
}
