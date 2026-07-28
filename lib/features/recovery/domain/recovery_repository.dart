import 'recovery_metric.dart';

abstract class RecoveryRepository {
  Future<List<RecoveryMetric>> getRecoveryMetrics();
  Future<void> updateMetric(RecoveryMetric metric);
}
