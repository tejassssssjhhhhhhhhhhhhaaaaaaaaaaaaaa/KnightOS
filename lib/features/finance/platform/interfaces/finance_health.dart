enum FinanceHealthStatus {
  healthy,
  needsAttention,
  actionRequired,
}

abstract class IFinanceHealthMonitor {
  Future<FinanceHealthStatus> getOverallStatus();
  Future<Map<String, FinanceHealthStatus>> getComponentStatuses();
}
