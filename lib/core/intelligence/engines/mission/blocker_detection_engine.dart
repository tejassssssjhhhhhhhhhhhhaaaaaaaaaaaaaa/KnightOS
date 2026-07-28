import '../../domain/knight_memory.dart';
import '../../domain/memory_category.dart';

class BlockerDetectionEngine {
  const BlockerDetectionEngine();

  /// Identifies current blockers based on life context.
  Future<List<String>> detectBlockers(List<KnightMemory> context) async {
    final List<String> blockers = [];

    // 1. Health Blockers (Phase 9 integration)
    final healthMemories = context
        .where((m) => m.category == BookCategory.health)
        .toList();
    if (healthMemories.any((m) => (m.content['severity'] ?? 0) > 5)) {
      blockers.add('Health issue detected');
    }

    // 2. Financial Blockers (Phase 10 integration)
    final financeMemories = context
        .where((m) => m.category == BookCategory.finance)
        .toList();
    // Logic to check if spending exceeds budget
    if (financeMemories.any((m) => (m.content['isOverBudget'] ?? false))) {
      blockers.add('Budget constraint active');
    }

    return blockers;
  }
}
