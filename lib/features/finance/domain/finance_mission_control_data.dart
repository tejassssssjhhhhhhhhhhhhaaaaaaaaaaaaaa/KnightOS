import '../platform/interfaces/finance_health.dart';

class FinanceMissionControlData {
  final FinanceHealthStatus overallStatus;
  final int healthScore;
  final Map<String, FinanceHealthStatus> componentStatuses;
  final Map<String, dynamic> auditReport;
  final List<dynamic> pendingTasks;
  final List<dynamic> syncHistory;
  final dynamic lastSync;
  final dynamic lastRepair;

  FinanceMissionControlData({
    required this.overallStatus,
    required this.healthScore,
    required this.componentStatuses,
    required this.auditReport,
    required this.pendingTasks,
    required this.syncHistory,
    this.lastSync,
    this.lastRepair,
  });
}
