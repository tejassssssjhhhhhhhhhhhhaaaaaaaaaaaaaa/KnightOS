import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/services/google_data_hub.dart';
import 'controllers/finance_dashboard_controller.dart';
import 'widgets/finance_dashboard_widgets.dart';
import '../platform/providers/finance_platform_providers.dart';
import '../platform/interfaces/finance_sync.dart';

class FinanceTrackerScreen extends ConsumerWidget {
  const FinanceTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(financeDashboardProvider);
    final period = ref.watch(greetingServiceProvider).getDayPeriod();
    final hubStatus = ref.watch(googleDataHubProvider);

    return KnightPageScaffold(
      title: 'Finance',
      showBackButton: true,
      actions: [
        IconButton(
          onPressed: () => context.push(AppRoutes.financeSettings),
          icon: const Icon(Icons.tune_rounded, size: 20),
          tooltip: 'Finance Settings',
        ),
      ],
      body: dashboardAsync.when(
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.read(financeDashboardProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (hubStatus == HubStatus.disconnected)
                _buildConnectBanner(ref),
              
              const SizedBox(height: 16),
              NetWorthCard(
                amount: data.netWorth, 
                period: period,
                cash: data.cashPosition,
                debt: data.cashPosition - data.netWorth,
              ),
              const SizedBox(height: 24),
              FinanceMetricGrid(
                income: data.monthlyIncome,
                expenses: data.monthlyExpenses,
                savings: data.monthlySavings,
              ),
              const SizedBox(height: 16),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              const Text('INSIGHTS', style: KnightTokens.label),
              const SizedBox(height: 16),
              AiInsightCard(insight: data.aiInsight),
              const SizedBox(height: 32),
              const Text('PLATFORM HEALTH', style: KnightTokens.label),
              const SizedBox(height: 16),
              FinanceHealthIndicator(
                healthScore: data.financialHealthScore,
                engineHealth: data.engineHealthScore,
                completeness: data.completenessScore,
                needsReviewCount: data.needsReviewCount,
                onInboxTap: () => context.push(AppRoutes.financeInbox),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => context.push(AppRoutes.importCenter),
                icon: const Icon(Icons.hub_rounded, size: 16),
                label: const Text('OPEN DATA HUB', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _handleSmartSync(context, ref),
                      icon: const Icon(Icons.sync_rounded),
                      label: const Text('SMART SYNC'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(AppRoutes.financeMissionControl),
                      icon: const Icon(Icons.monitor_heart_rounded),
                      label: const Text('MISSION CONTROL'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Dashboard Error: $e')),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _QuickAction(icon: Icons.explore_rounded, label: 'EXPLORER', onTap: () => context.push(AppRoutes.financeExplorer)),
          _QuickAction(icon: Icons.history_rounded, label: 'TIMELINE', onTap: () => context.push(AppRoutes.financeTimeline)),
          _QuickAction(icon: Icons.analytics_rounded, label: 'ANALYTICS', onTap: () => context.push(AppRoutes.financeAnalytics)),
          _QuickAction(icon: Icons.calendar_today_rounded, label: 'PLANNING', onTap: () => context.push(AppRoutes.financePlanning)),
          _QuickAction(icon: Icons.stars_rounded, label: 'GOALS', onTap: () => context.push(AppRoutes.financeGoals)),
          _QuickAction(icon: Icons.assistant_rounded, label: 'ADVISOR', onTap: () => context.push(AppRoutes.financeAdvisor)),
          _QuickAction(icon: Icons.summarize_rounded, label: 'REPORTS', onTap: () => context.push(AppRoutes.financeReports)),
        ],
      ),
    );
  }

  Widget _buildConnectBanner(WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: KnightTokens.glass(accentColor: Colors.orange),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Historical sync paused. Connection required.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          FilledButton(
            onPressed: () => ref.read(googleDataHubProvider.notifier).startUnifiedSync(),
            style: FilledButton.styleFrom(backgroundColor: Colors.orange, visualDensity: VisualDensity.compact),
            child: const Text('CONNECT', style: TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSmartSync(BuildContext context, WidgetRef ref) async {
    final smartSync = ref.read(smartSyncEngineProvider);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (context) => _SyncProgressSheet(smartSync: smartSync),
    );
    
    await smartSync.startSync();
    ref.invalidate(financeDashboardProvider);
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _SyncProgressSheet extends StatelessWidget {
  const _SyncProgressSheet({required this.smartSync});
  final ISmartSyncEngine smartSync;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: 300,
      child: StreamBuilder<SyncProgress>(
        stream: smartSync.progress,
        builder: (context, snapshot) {
          final progress = snapshot.data;
          if (progress == null) return const Center(child: CircularProgressIndicator());
          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(progress.currentStage.toUpperCase(), style: KnightTokens.label),
              const SizedBox(height: 24),
              LinearProgressIndicator(value: progress.percentage),
              const SizedBox(height: 24),
              Text(progress.status, style: KnightTokens.subheadline),
              if (progress.percentage >= 1.0) ...[
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('DONE'),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
