import '../engines/reasoning_engine.dart';
import '../domain/reasoning_models.dart';
import '../knight_context_models.dart';
import '../domain/knight_memory.dart';
import '../engines/memory_engine.dart';
import '../knight_context_service.dart';
import '../../platform/engine/engine_interfaces.dart';

/// The public analytical API for KnightOS.
/// Assembles data from Context and Memory layers to feed the Reasoning Engine.
class ReasoningService {
  const ReasoningService({
    required this.engine,
    required this.memoryEngine,
    required this.contextService,
  });

  final ReasoningEngine engine;
  final MemoryEngine memoryEngine;
  final KnightContextService contextService;

  /// Performs a full reasoning cycle based on current system state.
  Future<ReasoningResult> performReasoningCycle({
    required List<KnightFeatureModule> featureModules,
  }) async {
    // 1. Fetch relevant memories (e.g., identity, goals, recent history)
    final memories = await memoryEngine.search(''); // Future: Targeted retrieval

    // 2. Build current context
    final context = contextService.buildContext(
      featureModules: featureModules,
      recentMemories: memories,
    );

    // 3. Reason
    return engine.reason(context: context, memories: memories);
  }

  /// Specialized: Evaluate specific risk of an action.
  Future<List<String>> evaluateActionRisks(String actionLabel) async {
    // Placeholder for targeted rule evaluation
    return [];
  }
}
