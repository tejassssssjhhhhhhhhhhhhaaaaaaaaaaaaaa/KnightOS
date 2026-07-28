import 'money_metric.dart';

/// Repository interface for financial metrics.
abstract class MoneyRepository {
  /// Retrieves all financial metrics.
  Future<List<MoneyMetric>> getMoneyMetrics();

  /// Updates a specific financial metric.
  Future<void> updateMetric(MoneyMetric metric);
}
