import '../interfaces/finance_health.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../auth/gmail_connection_manager.dart';

class FinanceHealthCenter implements IFinanceHealthMonitor {
  FinanceHealthCenter({
    required this.db,
    required this.connectionManager,
    required this.dao,
  });

  final KnightDatabase db;
  final GmailConnectionManager connectionManager;
  final FinancePlatformDao dao;

  @override
  Future<FinanceHealthStatus> getOverallStatus() async {
    final statuses = await getComponentStatuses();
    
    if (statuses.values.contains(FinanceHealthStatus.actionRequired)) {
      return FinanceHealthStatus.actionRequired;
    }
    if (statuses.values.contains(FinanceHealthStatus.needsAttention)) {
      return FinanceHealthStatus.needsAttention;
    }
    return FinanceHealthStatus.healthy;
  }

  @override
  Future<Map<String, FinanceHealthStatus>> getComponentStatuses() async {
    final results = <String, FinanceHealthStatus>{};

    // 1. Gmail & Auth
    final isConnected = await connectionManager.isConnected();
    results['Gmail Connection'] = isConnected ? FinanceHealthStatus.healthy : FinanceHealthStatus.actionRequired;
    results['OAuth'] = isConnected ? FinanceHealthStatus.healthy : FinanceHealthStatus.actionRequired;

    // 2. Engine & Logic
    results['Parser Engine'] = FinanceHealthStatus.healthy; // Placeholder
    results['Duplicate Engine'] = FinanceHealthStatus.healthy;
    results['Verification Engine'] = FinanceHealthStatus.healthy;

    // 3. Sync & Journal
    final unsupported = await dao.getJournalEntriesByResult('Unsupported');
    results['Sync Journal'] = unsupported.length > 5 ? FinanceHealthStatus.needsAttention : FinanceHealthStatus.healthy;
    results['Smart Sync'] = FinanceHealthStatus.healthy;
    results['Historical Scanner'] = FinanceHealthStatus.healthy;

    // 4. Persistence & Audit
    results['Evidence Vault'] = FinanceHealthStatus.healthy;
    results['Gmail Audit Engine'] = FinanceHealthStatus.healthy;
    
    // 5. Inbox & Interaction
    final pendingTasks = await dao.getPendingTasks();
    results['Finance Inbox'] = pendingTasks.isNotEmpty ? FinanceHealthStatus.needsAttention : FinanceHealthStatus.healthy;

    // 6. Infrastructure
    try {
      await dao.getAllInstitutions();
      results['Database'] = FinanceHealthStatus.healthy;
    } catch (_) {
      results['Database'] = FinanceHealthStatus.actionRequired;
    }

    return results;
  }

  Future<int> calculateHealthScore() async {
    final statuses = await getComponentStatuses();
    int score = 100;
    
    for (final status in statuses.values) {
      if (status == FinanceHealthStatus.actionRequired) score -= 25;
      if (status == FinanceHealthStatus.needsAttention) score -= 10;
    }
    
    return score.clamp(0, 100);
  }
}
