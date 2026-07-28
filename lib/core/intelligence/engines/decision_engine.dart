import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import 'memory_engine.dart';

/// Specifically tracks choices, reasoning, and outcomes.
class DecisionEngine {
  const DecisionEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Records a decision with its context.
  Future<void> recordDecision({
    required String title,
    required String reasoning,
    required Map<String, dynamic> alternatives,
    required double confidence,
    String? outcome,
    String? lessonsLearned,
  }) async {
    final memory = KnightMemory.create(
      memoryId: 'decision-${DateTime.now().millisecondsSinceEpoch}',
      category: BookCategory.philosophy,
      domain: MemoryDomain.decisionHistory,
      content: {
        'title': title,
        'reasoning': reasoning,
        'alternatives': alternatives,
        'outcome': outcome,
        'lessonsLearned': lessonsLearned,
      },
      confidence: confidence,
      source: MemorySource.aiGenerated, // Usually AI helps structure decisions
      importance: 0.8,
    );
    await memoryEngine.save(memory);
  }
}
