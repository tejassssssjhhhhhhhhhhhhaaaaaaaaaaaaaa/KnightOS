import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import '../data/drift_money_repository.dart';
import '../domain/money_metric.dart';
import '../domain/money_repository.dart';
import '../domain/money_state.dart';

/// Provider for the [MoneyRepository] implementation.
final moneyRepositoryProvider = Provider<MoneyRepository>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return DriftMoneyRepository(db: db);
});

/// Provider for the money state notifier.
final moneyStateProvider = AsyncNotifierProvider<MoneyController, MoneyState>(
  MoneyController.new,
);

/// Controller for managing financial metrics reactively.
class MoneyController extends AsyncNotifier<MoneyState> {
  late final MoneyRepository _repository;

  @override
  Future<MoneyState> build() async {
    _repository = ref.watch(moneyRepositoryProvider);
    final metrics = await _repository.getMoneyMetrics();
    return MoneyState(
      metrics: metrics,
      netPosition: _calculateNetPosition(metrics),
    );
  }

  /// Refreshes money metrics from the repository.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final metrics = await _repository.getMoneyMetrics();
      return MoneyState(
        metrics: metrics,
        netPosition: _calculateNetPosition(metrics),
      );
    });
  }

  /// Updates a specific money metric and persists it.
  Future<void> updateMetric(MoneyMetric metric) async {
    await _repository.updateMetric(metric);
    await refresh();
  }

  double _calculateNetPosition(List<MoneyMetric> metrics) {
    if (metrics.isEmpty) return 0.0;

    final income = metrics
        .where((m) => m.category == MoneyCategory.income)
        .map((m) => m.amount)
        .fold(0.0, (a, b) => a + b);

    final expenses = metrics
        .where((m) => m.category == MoneyCategory.expenses)
        .map((m) => m.amount)
        .fold(0.0, (a, b) => a + b);

    return income - expenses;
  }
}
