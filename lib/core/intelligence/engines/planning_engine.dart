import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../domain/cognitive_models.dart';
import 'memory_engine.dart';

/// Converts high-level goals into executable step-by-step plans.
class PlanningEngine {
  const PlanningEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Generates a plan for a specific goal.
  Future<CognitivePlan> createPlan(String goalId, List<String> steps) async {
    // In v2, this would involve LLM reasoning.
    // Here we define the structural foundation.
    final plan = CognitivePlan(
      id: 'plan-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Action Plan for Goal',
      steps: steps,
      targetGoalId: goalId,
      createdAt: DateTime.now(),
    );

    // Save plan as a memory
    final memory = KnightMemory.create(
      memoryId: plan.id,
      category: BookCategory.ambitions,
      domain: MemoryDomain.goals,
      content: {
        'title': plan.title,
        'steps': plan.steps,
        'targetGoalId': plan.targetGoalId,
        'status': plan.status,
      },
      source: MemorySource.aiGenerated,
      importance: 0.7,
      reasoning: 'AI-generated plan for goal $goalId',
    );
    await memoryEngine.save(memory);

    return plan;
  }
}
