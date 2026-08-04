import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
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
              NetWorthCard(amount: data.netWorth, period: period),
              const SizedBox(height: 24),
              FinanceMetricGrid(
                income: data.monthlyIncome,
                expenses: data.monthlyExpenses,
                savings: data.monthlySavings,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => context.push(AppRoutes.financeExplorer),
                        icon: const Icon(Icons.explore_rounded, size: 16),
                        label: const Text('EXPLORER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => context.push(AppRoutes.financeTimeline),
                        icon: const Icon(Icons.history_rounded, size: 16),
                        label: const Text('TIMELINE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => context.push(AppRoutes.financeAnalytics),
                        icon: const Icon(Icons.analytics_rounded, size: 16),
                        label: const Text('ANALYTICS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => context.push(AppRoutes.financePlanning),
                        icon: const Icon(Icons.calendar_today_rounded, size: 16),
                        label: const Text('PLANNING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => context.push(AppRoutes.financeGoals),
                        icon: const Icon(Icons.stars_rounded, size: 16),
                        label: const Text('GOALS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => context.push(AppRoutes.financeAdvisor),
                        icon: const Icon(Icons.assistant_rounded, size: 16),
                        label: const Text('ADVISOR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => context.push(AppRoutes.financeReports),
                        icon: const Icon(Icons.summarize_rounded, size: 16),
                        label: const Text('REPORTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
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
