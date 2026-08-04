import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/database_provider.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../services/google_auth_service.dart';
import '../../internal/utils/knight_logger.dart';
import '../providers/intelligence_providers.dart';
import '../domain/data_provider.dart';
import 'sync_task_service.dart';

enum SubsystemStatus { healthy, warning, error, idle }

class SubsystemHealth {
  final String name;
  final SubsystemStatus status;
  final String? lastError;
  final DateTime lastChecked;
  final String? suggestedAction;

  SubsystemHealth({
    required this.name,
    required this.status,
    this.lastError,
    required this.lastChecked,
    this.suggestedAction,
  });
}

class SystemHealthReport {
  final List<SubsystemHealth> subsystems;
  final int score;

  SystemHealthReport({required this.subsystems, required this.score});
}

class SystemHealthService {
  SystemHealthService({required this.ref});
  final Ref ref;

  Future<SystemHealthReport> runFullDiagnostic() async {
    final List<SubsystemHealth> results = [];

    // 1. Google Authentication
    results.add(await _checkAuth());

    // 2. Database Integrity
    results.add(await _checkDatabase());

    // 3. Provider Connectivity
    results.add(await _checkProviders());

    // 4. Background Workers
    results.add(await _checkWorkers());

    int totalScore = (results.where((s) => s.status == SubsystemStatus.healthy).length / results.length * 100).toInt();

    return SystemHealthReport(subsystems: results, score: totalScore);
  }

  Future<SubsystemHealth> _checkAuth() async {
    final auth = GoogleAuthService.instance;
    final user = auth.currentUser;
    if (user == null) {
      return SubsystemHealth(
        name: 'Authentication',
        status: SubsystemStatus.warning,
        lastChecked: DateTime.now(),
        lastError: 'No active Google account connected.',
        suggestedAction: 'Link Google account in Settings.',
      );
    }
    return SubsystemHealth(
      name: 'Authentication',
      status: SubsystemStatus.healthy,
      lastChecked: DateTime.now(),
    );
  }

  Future<SubsystemHealth> _checkDatabase() async {
    try {
      final db = ref.read(knightDatabaseProvider);
      await db.customSelect('SELECT 1').getSingle();
      return SubsystemHealth(
        name: 'Database',
        status: SubsystemStatus.healthy,
        lastChecked: DateTime.now(),
      );
    } catch (e) {
      return SubsystemHealth(
        name: 'Database',
        status: SubsystemStatus.error,
        lastChecked: DateTime.now(),
        lastError: e.toString(),
        suggestedAction: 'Re-initialize system from Recovery.',
      );
    }
  }

  Future<SubsystemHealth> _checkProviders() async {
    final registry = ref.read(dataProviderRegistryProvider);
    final errors = registry.where((p) => p.status == ProviderStatus.error);
    if (errors.isNotEmpty) {
      return SubsystemHealth(
        name: 'Connectors',
        status: SubsystemStatus.warning,
        lastChecked: DateTime.now(),
        lastError: '${errors.length} providers have active errors.',
        suggestedAction: 'Check Sync Center for details.',
      );
    }
    return SubsystemHealth(
      name: 'Connectors',
      status: SubsystemStatus.healthy,
      lastChecked: DateTime.now(),
    );
  }

  Future<SubsystemHealth> _checkWorkers() async {
    final workerState = ref.read(syncTaskServiceProvider);
    if (workerState == WorkerState.failed) {
      return SubsystemHealth(
        name: 'Intelligence Workers',
        status: SubsystemStatus.error,
        lastChecked: DateTime.now(),
        lastError: 'Background workers encountered a critical failure.',
        suggestedAction: 'Restart worker polling from Developer Mode.',
      );
    }
    return SubsystemHealth(
      name: 'Intelligence Workers',
      status: SubsystemStatus.healthy,
      lastChecked: DateTime.now(),
    );
  }

  Future<void> runAutoRepair() async {
    KnightLogger.info('[HEALTH] Starting automatic repair sequence...', category: KnightLogCategory.startup);
    
    // 1. Restart Workers
    ref.read(syncTaskServiceProvider.notifier).stopPolling();
    ref.read(syncTaskServiceProvider.notifier).startPolling();
    
    // 2. Clear stalled 'processing' tasks
    final db = ref.read(knightDatabaseProvider);
    await (db.update(db.syncTaskQueueTable)
          ..where((t) => t.status.equals('processing')))
        .write(SyncTaskQueueTableCompanion(
          status: const Value('pending'),
          updatedAt: Value(DateTime.now()),
        ));
        
    KnightLogger.info('[HEALTH] Auto-repair complete.', category: KnightLogCategory.startup);
  }
}

final systemHealthServiceProvider = Provider<SystemHealthService>((ref) => SystemHealthService(ref: ref));

final systemHealthReportProvider = FutureProvider<SystemHealthReport>((ref) async {
  return await ref.watch(systemHealthServiceProvider).runFullDiagnostic();
});
