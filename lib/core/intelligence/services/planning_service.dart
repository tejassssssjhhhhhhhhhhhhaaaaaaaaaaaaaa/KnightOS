import '../engines/planning_engine.dart';
import '../domain/planning_models.dart';
import '../engines/memory_engine.dart';
import '../knight_context_service.dart';
import '../services/reasoning_service.dart';
import '../../platform/engine/engine_interfaces.dart';

/// The public planning API for KnightOS.
/// Coordinates between Memory, Context, and Reasoning to generate executable strategy.
class PlanningService {
  const PlanningService({
    required this.engine,
    required this.memoryEngine,
    required this.contextService,
    required this.reasoningService,
  });

  final PlanningEngine engine;
  final MemoryEngine memoryEngine;
  final KnightContextService contextService;
  final ReasoningService reasoningService;

  /// Generates an adaptive daily plan based on the latest intelligence state.
  Future<PlanningResult> generateDailyPlan({
    required List<KnightFeatureModule> featureModules,
  }) async {
    // 1. Fetch relevant context and reasoning
    final reasoning = await reasoningService.performReasoningCycle(
      featureModules: featureModules,
    );

    // 2. Fetch memories (using same logic as reasoning for consistency)
    final memories = await memoryEngine.search('');

    // 3. Build context
    final context = contextService.buildContext(
      featureModules: featureModules,
      recentMemories: memories,
    );

    // 4. Plan
    return engine.plan(
      context: context,
      memories: memories,
      reasoning: reasoning,
    );
  }

  /// Specialized: Decompose a specific goal into atomic tasks.
  Future<List<KnightTask>> decomposeGoal(String goalTitle) async {
    // Rule-based placeholder
    return [];
  }
}
