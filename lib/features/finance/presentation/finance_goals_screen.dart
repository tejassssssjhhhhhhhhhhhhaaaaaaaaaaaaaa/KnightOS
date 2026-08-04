import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import 'controllers/finance_goal_controller.dart';
import 'widgets/finance_goal_widgets.dart';
import 'widgets/finance_scenario_simulator.dart';

class FinanceGoalsScreen extends ConsumerWidget {
  const FinanceGoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financeGoalProvider);

    return KnightPageScaffold(
      title: 'Wealth Builder',
      showBackButton: true,
      body: summaryAsync.when(
        data: (summary) => RefreshIndicator(
          onRefresh: () => ref.read(financeGoalProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const WealthBuilderHero(),
              const SizedBox(height: 32),
              const Text('ACTIVE GOALS', style: KnightTokens.label),
              const SizedBox(height: 16),
              if (summary.goalReports.isEmpty)
                _buildNoGoals(context, ref)
              else
                ...summary.goalReports.map((report) => GoalProgressCard(report: report)),
              const SizedBox(height: 32),
              const FinanceScenarioSimulator(),
              const SizedBox(height: 32),
              const Text('GOAL COACH', style: KnightTokens.label),
              const SizedBox(height: 16),
              ...summary.insights.map((insight) => GoalInsightTile(insight: insight)),
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Goal Error: $e')),
      ),
    );
  }

  Widget _buildNoGoals(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: KnightTokens.glass(accentColor: Colors.blueAccent),
      child: Column(
        children: [
          const Icon(Icons.stars_rounded, size: 48, color: Colors.white10),
          const SizedBox(height: 16),
          const Text('No financial goals defined.', style: TextStyle(color: Colors.white38)),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {},
            child: const Text('CREATE FIRST GOAL'),
          ),
        ],
      ),
    );
  }
}
