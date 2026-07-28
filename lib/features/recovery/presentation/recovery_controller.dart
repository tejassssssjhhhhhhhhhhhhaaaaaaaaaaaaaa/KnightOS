import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../data/memory_recovery_repository.dart';
import '../domain/recovery_metric.dart';
import '../domain/recovery_repository.dart';
import '../domain/recovery_state.dart';

/// Provider for the [RecoveryRepository] implementation.
final recoveryRepositoryProvider = Provider<RecoveryRepository>((ref) {
  final memoryEngine = ref.watch(memoryEngineProvider);
  return MemoryRecoveryRepository(memoryEngine: memoryEngine);
});

/// Provider for the recovery state notifier.
final recoveryStateProvider =
    AsyncNotifierProvider<RecoveryController, RecoveryState>(
      RecoveryController.new,
    );

/// Controller for managing recovery metrics reactively.
class RecoveryController extends AsyncNotifier<RecoveryState> {
  late final RecoveryRepository _repository;

  @override
  Future<RecoveryState> build() async {
    _repository = ref.watch(recoveryRepositoryProvider);
    final metrics = await _repository.getRecoveryMetrics();
    return RecoveryState(
      metrics: metrics,
      overallScore: _calculateOverallScore(metrics),
    );
  }

  /// Refreshes recovery metrics from the repository.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final metrics = await _repository.getRecoveryMetrics();
      return RecoveryState(
        metrics: metrics,
        overallScore: _calculateOverallScore(metrics),
      );
    });
  }

  /// Updates a specific recovery metric and persists it.
  Future<void> updateMetric(RecoveryMetric metric) async {
    await _repository.updateMetric(metric);
    await refresh();
  }

  double _calculateOverallScore(List<RecoveryMetric> metrics) {
    if (metrics.isEmpty) return 0.0;
    // Simple average as established in previous sprints.
    return metrics.map((m) => m.value).reduce((a, b) => a + b) / metrics.length;
  }
}
