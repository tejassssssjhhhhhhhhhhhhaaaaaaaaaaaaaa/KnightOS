import '../engines/reasoning_engine.dart';
import '../engines/context_engine.dart';
import '../engines/optimization_engine.dart';
import '../domain/reasoning_models.dart';
import '../domain/cognitive_models.dart';
import '../domain/intelligence_models.dart';
import '../engines/memory_engine.dart';
import '../knight_context_service.dart';
import '../../internal/utils/knight_logger.dart';
import 'world_service.dart';
import '../../platform/engine/engine_interfaces.dart';

/// The public analytical API for KnightOS.
/// Assembles data from Context and Memory layers to feed the Reasoning Engine.
class ReasoningService {
  const ReasoningService({
    required this.engine,
    required this.memoryEngine,
    required this.contextService,
    required this.worldService,
    required this.contextEngine,
    required this.optimizationEngine,
  });

  final ReasoningEngine engine;
  final MemoryEngine memoryEngine;
  final KnightContextService contextService;
  final WorldService worldService;
  final ContextEngine contextEngine;
  final OptimizationEngine optimizationEngine;

  /// Performs a full reasoning cycle based on current system state.
  Future<ReasoningResult> performReasoningCycle({
    required List<KnightFeatureModule> featureModules,
  }) async {
    KnightLogger.info('[REASONING] Cycle started', category: KnightLogCategory.intelligence);
    // 1. Fetch relevant memories (e.g., identity, goals, recent history)
    final memories = await contextEngine.buildActiveContext(
      intent: KnightIntent.analysis,
      worldState: worldService.currentState,
    );

    // 2. Build current context
    final context = contextService.buildContext(
      featureModules: featureModules,
      recentMemories: memories,
      worldState: worldService.currentState,
    );

    // 3. Reason with learned weights
    final result = engine.reason(
      context: context, 
      memories: memories,
      weights: optimizationEngine.state.domainWeights,
    );
    KnightLogger.info('[REASONING] Cycle complete: ${result.insights.length} insights', category: KnightLogCategory.intelligence);
    return result;
  }

  /// Registers user feedback on an intelligence item to optimize future cycles.
  void provideFeedback(String domain, IntelligenceFeedback feedback) {
    optimizationEngine.processFeedback(domain, feedback);
  }

  /// Specialized: Evaluate specific risk of an action.
  Future<List<String>> evaluateActionRisks(String actionLabel) async {
    // Placeholder for targeted rule evaluation
    return [];
  }
}
