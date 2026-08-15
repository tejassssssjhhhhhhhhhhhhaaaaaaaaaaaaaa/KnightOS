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
      actions: [
        IconButton(
          onPressed: () => _createNewGoal(context, ref),
          icon: const Icon(Icons.add_rounded),
          tooltip: 'Add Goal',
        ),
      ],
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
              if (summary.insights.isEmpty)
                const Text('Knight AI is forecasting your goal completion...', style: TextStyle(color: Colors.white10, fontSize: 11, fontStyle: FontStyle.italic))
              else
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
            onPressed: () => _createNewGoal(context, ref),
            child: const Text('CREATE FIRST GOAL'),
          ),
        ],
      ),
    );
  }

  void _createNewGoal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        final titleCtrl = TextEditingController();
        final targetCtrl = TextEditingController();
        String type = 'emergency_fund';
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('New Life Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Goal Title')),
                const SizedBox(height: 16),
                TextField(controller: targetCtrl, decoration: const InputDecoration(labelText: 'Target Amount'), keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: type,
                  items: [
                    {'id': 'emergency_fund', 'label': 'Emergency Fund'},
                    {'id': 'vehicle', 'label': 'Vehicle'},
                    {'id': 'home', 'label': 'Home'},
                    {'id': 'travel', 'label': 'Travel'},
                    {'id': 'education', 'label': 'Education'},
                    {'id': 'investment', 'label': 'Investment'},
                  ].map((e) => DropdownMenuItem(value: e['id'], child: Text(e['label']!))).toList(),
                  onChanged: (v) => type = v!,
                  decoration: const InputDecoration(labelText: 'Goal Type'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            FilledButton(
              onPressed: () async {
                final title = titleCtrl.text;
                final target = double.tryParse(targetCtrl.text) ?? 0.0;
                if (title.isNotEmpty && target > 0) {
                  await ref.read(financeGoalProvider.notifier).createGoal(
                    name: title,
                    targetAmount: target,
                    type: type,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Goal added to Wealth Builder.')));
                  }
                }
              }, 
              child: const Text('CREATE')
            ),
          ],
        );
      }
    );
  }
}
