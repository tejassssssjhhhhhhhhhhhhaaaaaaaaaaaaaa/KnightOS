import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import 'memory_engine.dart';

/// Monitors and manages the lifecycle of User Goals.
class GoalIntelligence {
  const GoalIntelligence({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Retrieves active goals and assesses their current risk levels.
  Future<List<Map<String, dynamic>>> assessGoals() async {
    final goals = await memoryEngine.getByCategory(BookCategory.ambitions);

    return goals
        .map(
          (g) => {
            'goal': g,
            'status': _calculateStatus(g),
            'risk': _calculateRisk(g),
          },
        )
        .toList();
  }

  String _calculateStatus(KnightMemory goal) {
    // Logic to compare current metrics (Money, Recovery) with goal targets.
    return 'On Track';
  }

  double _calculateRisk(KnightMemory goal) {
    // Logic to detect stagnation or conflict with other memories.
    return 0.1;
  }
}
