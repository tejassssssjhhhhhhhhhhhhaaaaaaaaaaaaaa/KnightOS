import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final service = ref.watch(knightContextServiceProvider);
    
    // 1. Fetch memories
    final memories = await ref.watch(memoryEngineProvider).search('');
    
    // 2. Fetch world state
    final world = ref.watch(worldServiceProvider).currentState;

    // 3. Perform Reasoning Cycle
    final reasoning = await ref.watch(reasoningServiceProvider).performReasoningCycle(
      featureModules: [], // Future: Dynamic registration
    );

    // 4. Perform Planning Cycle
    final planning = await ref.watch(planningServiceProvider).generateDailyPlan(
      featureModules: [],
    );
    
    return service.buildContext(
      featureModules: [],
      recentMemories: memories,
      worldState: world,
      reasoning: reasoning,
      planning: planning,
    );
  }

  /// Manually triggers a context refresh.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
