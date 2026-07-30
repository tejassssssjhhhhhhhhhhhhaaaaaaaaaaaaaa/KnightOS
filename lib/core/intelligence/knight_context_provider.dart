import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../internal/utils/knight_logger.dart';
import 'domain/cognitive_models.dart';
import 'domain/mission_models.dart';
import 'domain/planning_models.dart';
import 'domain/reasoning_models.dart';
import 'knight_context_models.dart';
import 'knight_context_service.dart';
import 'providers/intelligence_providers.dart';

final knightContextServiceProvider = Provider<KnightContextService>((ref) {
  return KnightContextService();
});

/// Reactive notifier that provides the hydrated situational context of the user.
final currentContextNotifierProvider =
    AsyncNotifierProvider<CurrentContextNotifier, KnightContext>(
  CurrentContextNotifier.new,
);

class CurrentContextNotifier extends AsyncNotifier<KnightContext> {
  @override
  Future<KnightContext> build() async {
    KnightLogger.info('[STARTUP 12] CurrentContextNotifier.build() entry', category: KnightLogCategory.startup);
    try {
      final service = ref.watch(knightContextServiceProvider);
      
      // 1. Fetch memories
      KnightLogger.info('[STARTUP 13] Fetching memories...', category: KnightLogCategory.startup);
      final memories = await ref.watch(memoryEngineProvider).search('').timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          KnightLogger.warn('[STARTUP] Fetching memories timed out', category: KnightLogCategory.startup);
          return [];
        },
      );
      KnightLogger.info('[STARTUP 14] Memories fetched: ${memories.length}', category: KnightLogCategory.startup);
      
      // 2. Fetch world state
      KnightLogger.info('[STARTUP] Fetching world state...', category: KnightLogCategory.startup);
      final world = ref.watch(worldServiceProvider).currentState;
      KnightLogger.info('[STARTUP] World state fetched', category: KnightLogCategory.startup);

      // 3. Perform Reasoning Cycle
      KnightLogger.info('[STARTUP 15] Performing Reasoning Cycle...', category: KnightLogCategory.startup);
      final reasoning = await ref.watch(reasoningServiceProvider).performReasoningCycle(
        featureModules: [], // Future: Dynamic registration
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          KnightLogger.warn('[STARTUP] Reasoning Cycle timed out', category: KnightLogCategory.startup);
          return _emptyReasoning();
        },
      );
      KnightLogger.info('[STARTUP 16] Reasoning Cycle complete', category: KnightLogCategory.startup);

      // 4. Perform Planning Cycle
      KnightLogger.info('[STARTUP 17] Performing Planning Cycle...', category: KnightLogCategory.startup);
      final planning = await ref.watch(planningServiceProvider).generateDailyPlan(
        featureModules: [],
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          KnightLogger.warn('[STARTUP] Planning Cycle timed out', category: KnightLogCategory.startup);
          return _emptyPlanning(reasoning);
        },
      );
      KnightLogger.info('[STARTUP 18] Planning Cycle complete', category: KnightLogCategory.startup);
      
      final context = service.buildContext(
        featureModules: [],
        recentMemories: memories,
        worldState: world,
        reasoning: reasoning,
        planning: planning,
      );
      KnightLogger.info('[STARTUP 19] KnightContext built successfully', category: KnightLogCategory.startup);
      return context;
    } catch (e, s) {
      KnightLogger.error('[STARTUP ERR] CurrentContextNotifier.build failed', error: e, stackTrace: s, category: KnightLogCategory.startup);
      rethrow;
    }
  }

  /// Manually triggers a context refresh.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  ReasoningResult _emptyReasoning() {
    return ReasoningResult(
      summary: 'System nominal.',
      insights: [],
      recommendations: [],
      warnings: [],
      opportunities: [],
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: [],
        thoughtChain: ['Timeout fallback'],
        confidence: 0,
      ),
    );
  }

  PlanningResult _emptyPlanning(ReasoningResult reasoning) {
    return PlanningResult(
      dailyPlan: KnightPlan(
        id: 'daily',
        title: 'Daily Plan',
        goalId: 'none',
        tasks: [],
        status: MissionStatus.draft,
        createdAt: DateTime.now(),
      ),
      activePlans: [],
      suggestedTasks: [],
      timestamp: DateTime.now(),
      reasoningUsed: reasoning,
    );
  }
}
