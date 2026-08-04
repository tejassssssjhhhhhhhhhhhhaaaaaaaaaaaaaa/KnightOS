import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import 'controllers/finance_budget_controller.dart';
import 'widgets/finance_planning_widgets.dart';

class FinancePlanningScreen extends ConsumerWidget {
  const FinancePlanningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financeBudgetProvider);

    return KnightPageScaffold(
      title: 'Planning Center',
      showBackButton: true,
      body: summaryAsync.when(
        data: (summary) => RefreshIndicator(
          onRefresh: () => ref.read(financeBudgetProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              DailySafeSpendCard(amount: summary.dailySafeSpend),
              const SizedBox(height: 32),
              const Text('ACTIVE BUDGETS', style: KnightTokens.label),
              const SizedBox(height: 16),
              if (summary.budgetReports.isEmpty)
                _buildNoBudgets(context, ref)
              else
                ...summary.budgetReports.map((report) => BudgetProgressCard(report: report)),
              const SizedBox(height: 32),
              const Text('SMART RECOMMENDATIONS', style: KnightTokens.label),
              const SizedBox(height: 16),
              ...summary.recommendations.map((insight) => PlanningInsightTile(insight: insight)),
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Planning Error: $e')),
      ),
    );
  }

  Widget _buildNoBudgets(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: KnightTokens.glass(accentColor: Colors.blueAccent),
      child: Column(
        children: [
          const Text('No active budgets found.', style: TextStyle(color: Colors.white38)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _createNewBudget(context, ref),
            child: const Text('CREATE FIRST BUDGET'),
          ),
        ],
      ),
    );
  }

  void _createNewBudget(BuildContext context, WidgetRef ref) {
    // Milestone 7.1 logic
  }
}
