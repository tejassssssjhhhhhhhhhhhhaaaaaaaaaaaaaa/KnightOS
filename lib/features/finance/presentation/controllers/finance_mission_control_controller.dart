import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../domain/finance_mission_control_data.dart';
import '../../platform/providers/finance_platform_providers.dart';
import '../../../../core/providers/database_provider.dart';

final financeMissionControlProvider = AsyncNotifierProvider<FinanceMissionControlController, FinanceMissionControlData>(
  FinanceMissionControlController.new,
);

class FinanceMissionControlController extends AsyncNotifier<FinanceMissionControlData> {
  @override
  Future<FinanceMissionControlData> build() async {
    return _fetchData();
  }

  Future<FinanceMissionControlData> _fetchData() async {
    final db = ref.watch(knightDatabaseProvider);
    final healthCenter = ref.watch(financeHealthCenterProvider);
    final auditEngine = ref.watch(gmailAuditEngineProvider);
    final dao = ref.watch(financePlatformDaoProvider);

    final overall = await healthCenter.getOverallStatus();
    final score = await healthCenter.calculateHealthScore();
    final components = await healthCenter.getComponentStatuses();
    final audit = await auditEngine.generateAuditReport();
    final tasks = await dao.getPendingTasks();
    final lastSync = await dao.getLastSyncHistory();
    final history = await (db.select(db.financeSyncHistoryTable)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(10))
        .get();

    return FinanceMissionControlData(
      overallStatus: overall,
      healthScore: score,
      componentStatuses: components,
      auditReport: audit,
      pendingTasks: tasks,
      syncHistory: history,
      lastSync: lastSync,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData());
  }

  Future<void> runSync() async {
    final syncEngine = ref.read(smartSyncEngineProvider);
    await syncEngine.startSync();
    await refresh();
  }

  Future<void> runRepair() async {
    final repairEngine = ref.read(repairEngineProvider);
    await repairEngine.runFullRepair();
    await refresh();
  }
}
