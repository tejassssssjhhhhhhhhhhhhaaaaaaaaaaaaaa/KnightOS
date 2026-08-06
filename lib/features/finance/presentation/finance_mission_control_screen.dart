import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/router/app_routes.dart';
import '../domain/finance_mission_control_data.dart';
import 'controllers/finance_mission_control_controller.dart';
import 'widgets/finance_mission_control_widgets.dart';

class FinanceMissionControlScreen extends ConsumerWidget {
  const FinanceMissionControlScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(financeMissionControlProvider);

    return KnightPageScaffold(
      title: 'Mission Control',
      showBackButton: true,
      body: dataAsync.when(
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.read(financeMissionControlProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildOverallHealth(data),
              const SizedBox(height: 32),
              const Text('PLATFORM COMPONENTS', style: KnightTokens.label),
              const SizedBox(height: 16),
              PlatformStatusGrid(statuses: data.componentStatuses),
              const SizedBox(height: 32),
              const Text('PIPELINE VISUALIZATION', style: KnightTokens.label),
              const SizedBox(height: 16),
              PipelineVisualization(statuses: data.componentStatuses),
              const SizedBox(height: 32),
              const Text('GMAIL AUDIT', style: KnightTokens.label),
              const SizedBox(height: 16),
              AuditMetricGrid(report: data.auditReport),
              const SizedBox(height: 32),
              const Text('PLATFORM ACTIVITY', style: KnightTokens.label),
              const SizedBox(height: 16),
              ActivityFeedList(history: data.syncHistory),
              const SizedBox(height: 32),
              _buildControlActions(context, ref),
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Load Error: $e')),
      ),
    );
  }

  Widget _buildOverallHealth(FinanceMissionControlData data) {
    final color = data.healthScore > 80 ? Colors.greenAccent : (data.healthScore > 50 ? Colors.orangeAccent : Colors.redAccent);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: KnightTokens.glass(accentColor: color, opacity: 0.1),
      child: Column(
        children: [
          Text('${data.healthScore}%', style: KnightTokens.headline.copyWith(fontSize: 48, color: color)),
          const Text('OVERALL ENGINE HEALTH', style: KnightTokens.label),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
            child: Text(data.overallStatus.name.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildControlActions(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => ref.read(financeMissionControlProvider.notifier).runSync(),
                icon: const Icon(Icons.sync_rounded),
                label: const Text('RUN SMART SYNC'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => ref.read(financeMissionControlProvider.notifier).runRepair(),
                icon: const Icon(Icons.build_circle_outlined),
                label: const Text('RUN REPAIR'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.financeInbox),
            icon: const Icon(Icons.inbox_rounded),
            label: const Text('OPEN FINANCE INBOX'),
          ),
        ),
      ],
    );
  }
}
