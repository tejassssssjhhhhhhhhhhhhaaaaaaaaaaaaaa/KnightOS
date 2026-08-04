import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:knight_os/core/router/app_routes.dart';
import 'package:knight_os/app/widgets/knight_page_scaffold.dart';
import 'package:knight_os/core/design_system/knight_tokens.dart';
import 'package:knight_os/core/design_system/design_constants.dart';
import 'package:knight_os/core/intelligence/services/provider_sync_stats_provider.dart';
import 'package:knight_os/core/intelligence/services/extraction_stats_provider.dart';
import 'package:knight_os/core/intelligence/services/system_health_service.dart';
import 'package:knight_os/core/intelligence/services/diagnostics_export_service.dart';
import 'package:knight_os/core/intelligence/knight_context_provider.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/intelligence/domain/health_models.dart';
import 'package:knight_os/core/intelligence/domain/reminder_models.dart';
import 'package:knight_os/core/intelligence/services/snapshot_service.dart';
import 'package:knight_os/core/intelligence/services/sync_task_service.dart';
import 'package:knight_os/core/intelligence/services/graph_stats_provider.dart';
import 'package:knight_os/core/intelligence/services/device_intelligence_service.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import 'package:knight_os/core/services/internal_log_service.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/features/finance/platform/engine/finance_audit_provider.dart';

class DeveloperModeScreen extends ConsumerWidget {
  const DeveloperModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      title: 'Developer Mode',
      showBackButton: true,
      body: DefaultTabController(
        length: 9,
        initialIndex: 8,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              indicatorColor: DesignColors.accentBlue,
              labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'SYSTEM'),
                Tab(text: 'HEALTH'),
                Tab(text: 'CONTEXT'),
                Tab(text: 'GRAPH'),
                Tab(text: 'SYNC'),
                Tab(text: 'TRAVEL'),
                Tab(text: 'DATABASE'),
                Tab(text: 'SIMULATOR'),
                Tab(text: 'LIVE LOGS'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _SystemTab(),
                  _HealthTab(),
                  _ContextTab(),
                  _GraphTab(),
                  _SyncTab(),
                  _TravelTab(),
                  _DatabaseTab(),
                  _SimulatorTab(),
                  _LogsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _info('Application Version', '5.0.0'),
        _info('Build Number', '2026.08.02.01'),
        _info('Database Version', '13'),
        _info('Architecture Version', 'M3.5'),
        _info('Environment', 'Production Validation'),
        const SizedBox(height: 32),
        const Text('DEBUG UTILITIES', style: KnightTokens.label),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _exportDiagnostics(context, ref),
          icon: const Icon(Icons.share_rounded),
          label: const Text('EXPORT DIAGNOSTICS'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => ref.read(snapshotServiceProvider).capture('Manual'),
          icon: const Icon(Icons.camera_rounded),
          label: const Text('CAPTURE SNAPSHOT'),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.providerHealth),
          icon: const Icon(Icons.monitor_heart_rounded),
          label: const Text('PROVIDER HEALTH'),
        ),
      ],
    );
  }

  Future<void> _exportDiagnostics(BuildContext context, WidgetRef ref) async {
    final report = await ref.read(diagnosticsExportServiceProvider).generateMarkdownReport();
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignColors.surfaceHigh,
        title: const Text('Diagnostics Export'),
        content: SingleChildScrollView(child: Text(report, style: const TextStyle(fontSize: 10, fontFamily: 'monospace'))),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('CLOSE'))],
      ),
    );
  }
}

class _HealthTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(systemHealthReportProvider);
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return healthAsync.when(
      data: (report) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _ScoreCard(score: report.score),
          const SizedBox(height: 32),
          const Text('HEALTH INTELLIGENCE AUDIT', style: KnightTokens.label),
          const SizedBox(height: 16),
          contextAsync.when(
            data: (ctx) => _HealthIntelligenceAudit(context: ctx),
            loading: () => const LinearProgressIndicator(),
            error: (e, s) => Text('Context unavailable: $e'),
          ),
          const SizedBox(height: 32),
          const Text('SUBSYSTEM STATUS', style: KnightTokens.label),
          const SizedBox(height: 16),
          ...report.subsystems.map((s) => _SubsystemTile(health: s)),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => ref.invalidate(systemHealthReportProvider),
            child: const Text('RUN FULL DIAGNOSTIC'),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}

class _HealthIntelligenceAudit extends StatelessWidget {
  const _HealthIntelligenceAudit({required this.context});
  final KnightContext context;

  @override
  Widget build(BuildContext context) {
    final scores = this.context.healthScores;
    if (scores == null) return const Text('No active health scores in context.', style: TextStyle(color: Colors.white24, fontSize: 12));

    return Column(
      children: [
        _scoreRow('Daily Score', scores.dailyScore),
        _scoreRow('Sleep Score', scores.sleepScore),
        _scoreRow('Hydration', scores.hydrationScore),
        _scoreRow('Stress', scores.stressScore),
        const SizedBox(height: 16),
        const Text('GRAPH KNOWLEDGE NODES', style: TextStyle(fontSize: 10, color: Colors.white24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _info('Tracked Nodes', '7 Domains Active'),
        _info('Last Graph Update', DateFormat('HH:mm:ss').format(scores.timestamp)),
      ],
    );
  }

  Widget _scoreRow(String label, HealthScoreResult result) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70)),
              Text('${result.score}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: result.trace.confidence > 0.8 ? Colors.greenAccent : Colors.orangeAccent)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('Confidence: ${(result.trace.confidence * 100).toInt()}%', style: const TextStyle(fontSize: 10, color: Colors.white24)),
              const SizedBox(width: 12),
              Text('Evidence: ${result.trace.evidence.length} pts', style: const TextStyle(fontSize: 10, color: Colors.white24)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SyncTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gmailStats = ref.watch(providerSyncStatsProvider('gmail_api'));
    final workerState = ref.watch(syncTaskServiceProvider);
    
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('WORKER STATUS', style: KnightTokens.label),
        const SizedBox(height: 16),
        _info('Global Worker State', workerState.name.toUpperCase()),
        const SizedBox(height: 32),
        const Text('GMAIL SYNC STATE', style: KnightTokens.label),
        const SizedBox(height: 16),
        gmailStats.when(
          data: (stats) => Column(
            children: [
              _info('Sync Status', stats.status.toUpperCase()),
              _info('Pending Tasks', stats.pendingTasks.toString()),
              _info('Failed Tasks', stats.failedTasks.toString()),
              _info('Duplicates Prevented', stats.duplicatesPrevented.toString()),
              _info('Last Sync', stats.lastSync?.toString() ?? 'Never'),
            ],
          ),
          loading: () => const LinearProgressIndicator(),
          error: (e, s) => Text('Error: $e'),
        ),
        const SizedBox(height: 32),
        const Text('FINANCE PLATFORM AUDIT', style: KnightTokens.label),
        const SizedBox(height: 16),
        ref.watch(financeAuditProvider).when(
          data: (report) => Column(
            children: [
              _info('Total Gmail Messages', report['total_gmail_messages'].toString()),
              _info('Financial Emails Found', report['financial_emails_found'].toString()),
              _info('Parsed Successfully', report['parsed_successfully'].toString()),
              _info('Needs Review (Inbox)', report['needs_review'].toString()),
              _info('Unsupported Patterns', report['unsupported'].toString()),
              _info('Parser Success Rate', '${((report['parser_success_rate'] as double) * 100).toInt()}%'),
              _info('Institutions Discovered', report['institutions_found'].toString()),
            ],
          ),
          loading: () => const LinearProgressIndicator(),
          error: (e, s) => Text('Audit Error: $e'),
        ),
      ],
    );
  }
}

class _TravelTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('TRAVEL FOUNDATION DIAGNOSTICS', style: KnightTokens.label),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.travelImport),
          icon: const Icon(Icons.import_export_rounded),
          label: const Text('IMPORT TRACKER'),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.travelQuality),
          icon: const Icon(Icons.high_quality_rounded),
          label: const Text('QUALITY AUDIT'),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.travelMissionControl),
          icon: const Icon(Icons.hub_rounded),
          label: const Text('MISSION CONTROL'),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.travelDevMode),
          icon: const Icon(Icons.bug_report_rounded),
          label: const Text('ENGINE INSPECTOR'),
        ),
      ],
    );
  }
}

class _DatabaseTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extStats = ref.watch(extractionStatsProvider);
    
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('KNOWLEDGE METRICS', style: KnightTokens.label),
        const SizedBox(height: 16),
        extStats.when(
          data: (stats) => Column(
            children: [
              _info('Extracted Entities', stats.entitiesExtracted.toString()),
              _info('Canonical IDs', stats.canonicalIdentities.toString()),
              _info('Evidence Records', stats.evidenceRecords.toString()),
              _info('Validation Failures', stats.validationFailures.toString()),
              _info('Average Confidence', '${(stats.averageConfidence * 100).toInt()}%'),
            ],
          ),
          loading: () => const LinearProgressIndicator(),
          error: (e, s) => Text('Error: $e'),
        ),
      ],
    );
  }
}

class _LogsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<LogEntry>>(
      stream: InternalLogService.instance.logStream,
      initialData: InternalLogService.instance.logs,
      builder: (context, snapshot) {
        final logs = snapshot.data ?? [];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${logs.length} entries captured', style: const TextStyle(fontSize: 10, color: Colors.white24)),
                  TextButton(
                    onPressed: () => InternalLogService.instance.clear(),
                    child: const Text('CLEAR', style: TextStyle(fontSize: 10, color: DesignColors.error)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return _LogTile(log: log);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    final color = score > 80 ? Colors.greenAccent : (score > 50 ? Colors.orangeAccent : Colors.redAccent);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text('$score%', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: color)),
          const Text('OVERALL SYSTEM HEALTH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        ],
      ),
    );
  }
}

class _SubsystemTile extends StatelessWidget {
  const _SubsystemTile({required this.health});
  final SubsystemHealth health;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (health.status) {
      case SubsystemStatus.healthy: color = Colors.greenAccent; break;
      case SubsystemStatus.warning: color = Colors.orangeAccent; break;
      case SubsystemStatus.error: color = Colors.redAccent; break;
      default: color = Colors.white24;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 16),
              Text(health.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          if (health.lastError != null) ...[
            const SizedBox(height: 12),
            Text(health.lastError!, style: const TextStyle(fontSize: 11, color: DesignColors.error)),
            const SizedBox(height: 4),
            Text('FIX: ${health.suggestedAction}', style: const TextStyle(fontSize: 10, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.log});
  final LogEntry log;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white38;
    if (log.level == 'WARN') color = Colors.orangeAccent;
    if (log.level == 'ERROR') color = Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(DateFormat('HH:mm:ss').format(log.timestamp), style: const TextStyle(fontSize: 9, fontFamily: 'monospace', color: Colors.white12)),
              const SizedBox(width: 8),
              Text(log.category.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color.withValues(alpha: 0.5))),
            ],
          ),
          const SizedBox(height: 4),
          Text(log.message, style: TextStyle(fontSize: 11, color: color, height: 1.4)),
          if (log.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(log.error!, style: const TextStyle(fontSize: 10, color: Colors.redAccent, fontFamily: 'monospace')),
            ),
        ],
      ),
    );
  }
}

class _GraphTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(graphStatsProvider);

    return statsAsync.when(
      data: (stats) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('GRAPH METRICS', style: KnightTokens.label),
          const SizedBox(height: 16),
          _info('Total Nodes', stats.totalNodes.toString()),
          _info('Total Edges', stats.totalEdges.toString()),
          _info('Canonical Identities', stats.canonicalNodes.toString()),
          _info('Average Trust Score', '${(stats.averageTrust * 100).toInt()}%'),
          const SizedBox(height: 32),
          const Text('TYPE DISTRIBUTION', style: KnightTokens.label),
          const SizedBox(height: 16),
          ...stats.typeDistribution.entries.map((e) => _info(e.key.toUpperCase(), e.value.toString())),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.knowledgeGraph),
            icon: const Icon(Icons.explore_rounded),
            label: const Text('OPEN GRAPH EXPLORER'),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $statsAsync')),
    );
  }
}

class _ContextTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return contextAsync.when(
      data: (ctx) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('ACTIVE CONTEXT', style: KnightTokens.label),
          const SizedBox(height: 16),
          _info('Context Health', '${(ctx.contextHealthScore * 100).toInt()}%'),
          _info('Last Fusion', DateFormat('HH:mm:ss').format(ctx.timestamp)),
          _info('Pending Reminders', ctx.pendingReminders.toString()),
          _info('Steps (Fused)', ctx.steps.toString()),
          const SizedBox(height: 32),
          const Text('DEVICE MESH', style: KnightTokens.label),
          const SizedBox(height: 16),
          if (ctx.deviceHealth.isEmpty) 
            const Text('No devices registered.', style: TextStyle(color: Colors.white24, fontSize: 12)),
          ...ctx.deviceHealth.entries.map((e) => _info(e.key, '${e.value.batteryLevel}% ${e.value.isCharging ? "(Charging)" : ""}')),
          const SizedBox(height: 32),
          const Text('FOUNDATIONS', style: KnightTokens.label),
          const SizedBox(height: 16),
          _info('Active Trips', ctx.activeTrips.length.toString()),
          _info('Finance Balance', ctx.totalBalance.toStringAsFixed(2)),
          const SizedBox(height: 32),
          const Text('CONTEXT TIMELINE', style: KnightTokens.label),
          const SizedBox(height: 16),
          const _ContextTimelineList(),
          const SizedBox(height: 32),
          const Text('REMINDER QUEUE', style: KnightTokens.label),
          const SizedBox(height: 16),
          const _ReminderQueueList(),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => _showFusionLog(context),
            icon: const Icon(Icons.hub_rounded),
            label: const Text('VIEW FUSION LOG'),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  void _showFusionLog(BuildContext context) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignColors.surfaceHigh,
        title: const Text('Context Fusion Log'),
        content: const Text('Audit of real-time context contributions from 18+ sources.', style: TextStyle(fontSize: 12)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('CLOSE'))],
      ),
    );
  }
}

class _SimulatorTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('HEALTH SIMULATOR', style: KnightTokens.label),
        const SizedBox(height: 16),
        _simulationTile(
          context, 'Simulate Steps', 'Add 5000 steps to today', 
          () => _addMetric(ref, 'steps', 5000),
        ),
        _simulationTile(
          context, 'Simulate Heart Rate', 'Set HR to 120 bpm', 
          () => _addMetric(ref, 'heart_rate', 120),
        ),
        _simulationTile(
          context, 'Simulate Stress', 'Set Stress to 85%', 
          () => _addMetric(ref, 'stress', 85),
        ),
        _simulationTile(
          context, 'Simulate Sleep', 'Log 8h sleep session', 
          () => _simSleep(ref),
        ),
        _simulationTile(
          context, 'Simulate Water', 'Log 500ml of water', 
          () => _addMetric(ref, 'water', 500),
        ),
        _simulationTile(
          context, 'Simulate Weight', 'Log 75.5kg', 
          () => _simWeight(ref, 75.5),
        ),
        _simulationTile(
          context, 'Galaxy Watch Low Battery', 'Simulate 5% battery', 
          () => _simWatchBattery(ref, 5),
        ),
        _simulationTile(
          context, 'Watch Disconnected', 'Set connection status to false', 
          () => _simWatchConnection(ref, false),
        ),
        _simulationTile(
          context, 'Recovery Alert', 'Simulate low recovery (20%)', 
          () => _simRecovery(ref, 20),
        ),
      ],
    );
  }

  Widget _simulationTile(BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white38)),
      trailing: const Icon(Icons.play_circle_fill_rounded, color: DesignColors.accentBlue),
      onTap: onTap,
    );
  }

  Future<void> _addMetric(WidgetRef ref, String type, double value) async {
     final db = ref.read(knightDatabaseProvider);
     await db.healthDao.insertMetrics([
        HealthMetricTableCompanion.insert(
          id: 'sim-$type-${DateTime.now().millisecondsSinceEpoch}',
          metricType: type,
          value: value,
          unit: type == 'steps' ? 'count' : (type == 'heart_rate' ? 'bpm' : (type == 'water' ? 'ml' : 'score')),
          startTime: DateTime.now(),
          source: 'simulator',
        )
     ]);
     ref.invalidate(currentContextNotifierProvider);
  }

  Future<void> _simSleep(WidgetRef ref) async {
    final db = ref.read(knightDatabaseProvider);
    final now = DateTime.now();
    await db.into(db.sleepSessionTable).insert(SleepSessionTableCompanion.insert(
      id: 'sim-sleep-${now.millisecondsSinceEpoch}',
      bedTime: now.subtract(const Duration(hours: 8)),
      wakeTime: now,
      sleepQuality: const Value(9),
      sourceProvider: const Value('simulator'),
    ));
    ref.invalidate(currentContextNotifierProvider);
  }

  Future<void> _simWeight(WidgetRef ref, double weight) async {
    final db = ref.read(knightDatabaseProvider);
    await db.into(db.bodyMeasurementTable).insert(BodyMeasurementTableCompanion.insert(
      id: 'sim-weight-${DateTime.now().millisecondsSinceEpoch}',
      measurementType: 'weight',
      value: weight,
      unit: 'kg',
      measuredAt: Value(DateTime.now()),
      sourceProvider: const Value('simulator'),
    ));
    ref.invalidate(currentContextNotifierProvider);
  }

  Future<void> _simWatchBattery(WidgetRef ref, int level) async {
    await ref.read(deviceIntelligenceServiceProvider).recordDeviceHealth(deviceId: 'galaxy-watch-7', batteryLevel: level, isCharging: false);
    ref.invalidate(currentContextNotifierProvider);
  }

  Future<void> _simWatchConnection(WidgetRef ref, bool connected) async {
    // Future: Update device registry with connection status
  }

  Future<void> _simRecovery(WidgetRef ref, int score) async {
    final db = ref.read(knightDatabaseProvider);
    await db.into(db.healthTrackerTable).insert(HealthTrackerTableCompanion.insert(
      id: 'sim-recovery-${DateTime.now().millisecondsSinceEpoch}',
      trackerType: 'recovery',
      value: Value(score),
      timestamp: Value(DateTime.now()),
    ));
    ref.invalidate(currentContextNotifierProvider);
  }
}

class _ReminderQueueList extends ConsumerWidget {
  const _ReminderQueueList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(_reminderQueueProvider);

    return remindersAsync.when(
      data: (list) {
        if (list.isEmpty) return const Text('No pending reminders.', style: TextStyle(color: Colors.white24, fontSize: 12));
        return Column(
          children: list.map((r) => _info(r.title, DateFormat('HH:mm').format(r.scheduledAt))).toList(),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}

final _reminderQueueProvider = FutureProvider<List<UnifiedReminder>>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  final items = await db.reminderDao.getPendingReminders();
  return items.map((i) => UnifiedReminder(
    id: i.id,
    type: ReminderType.general,
    title: i.title,
    scheduledAt: i.dueDate,
    priority: ReminderPriority.medium,
  )).toList();
});

class _ContextTimelineList extends ConsumerWidget {
  const _ContextTimelineList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(_contextHistoryProvider);

    return historyAsync.when(
      data: (list) {
        if (list.isEmpty) return const Text('No context history recorded.', style: TextStyle(color: Colors.white24, fontSize: 12));
        return Column(
          children: list.map((h) => _info(DateFormat('HH:mm:ss').format(h.timestamp), 'Health: ${(h.healthScore * 100).toInt()}%')).toList(),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}

final _contextHistoryProvider = FutureProvider<List<ContextHistoryData>>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  return (db.select(db.contextHistoryTable)
        ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
        ..limit(5))
      .get();
});

Widget _info(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
