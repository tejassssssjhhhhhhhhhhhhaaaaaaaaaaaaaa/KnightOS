import '../engines/planning_engine.dart';
import '../domain/planning_models.dart';
import '../engines/memory_engine.dart';
import '../knight_context_service.dart';
import 'world_service.dart';
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
    required this.worldService,
  });

  final PlanningEngine engine;
  final MemoryEngine memoryEngine;
  final KnightContextService contextService;
  final ReasoningService reasoningService;
  final WorldService worldService;

  /// Generates an adaptive daily plan based on the latest intelligence state.
  Future<PlanningResult> generateDailyPlan({
    required List<KnightFeatureModule> featureModules,
    ReasoningResult? preCalculatedReasoning,
    List<KnightMemory>? preFetchedMemories,
  }) async {
    // 1. Fetch relevant context and reasoning
    final reasoning = preCalculatedReasoning ?? await reasoningService.performReasoningCycle(
      featureModules: featureModules,
      preFetchedMemories: preFetchedMemories,
    );

    // 2. Fetch memories (using same logic as reasoning for consistency)
    final memories = preFetchedMemories ?? await memoryEngine.search('');

    // 3. Build context
    final context = contextService.buildContext(
      featureModules: featureModules,
      recentMemories: memories,
      worldState: worldService.currentState,
    );

    // 4. Plan
    return engine.plan(
      context: context,
      memories: memories,
      reasoning: reasoning,
    );
  }

  /// High-level API to generate a strategic plan for a complex objective.
  Future<KnightPlan> createStrategicPlan(String objective) async {
    // 1. Perception
    final memories = await memoryEngine.search('');
    final world = worldService.currentState;
    
    // 2. Context
    final context = contextService.buildContext(
      featureModules: [],
      recentMemories: memories,
      worldState: world,
    );

    // 3. AI Decomposition
    return engine.decomposeGoalWithAI(objective: objective, context: context);
  }

  /// Specialized: Decompose a specific goal into atomic tasks.
  Future<List<KnightTask>> decomposeGoal(String goalTitle) async {
    // Rule-based placeholder
    return [];
  }
}
