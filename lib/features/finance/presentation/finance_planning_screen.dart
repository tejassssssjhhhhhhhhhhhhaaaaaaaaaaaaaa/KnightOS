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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ACTIVE BUDGETS', style: KnightTokens.label),
                  TextButton.icon(
                    onPressed: () => _createNewBudget(context, ref),
                    icon: const Icon(Icons.add_rounded, size: 14),
                    label: const Text('ADD', style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (summary.budgetReports.isEmpty)
                _buildNoBudgets(context, ref)
              else
                ...summary.budgetReports.map((report) => BudgetProgressCard(report: report)),
              const SizedBox(height: 32),
              const Text('SMART RECOMMENDATIONS', style: KnightTokens.label),
              const SizedBox(height: 16),
              if (summary.recommendations.isEmpty)
                const Text('Knight AI is analyzing your patterns...', style: TextStyle(color: Colors.white10, fontSize: 11, fontStyle: FontStyle.italic))
              else
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
    showDialog(
      context: context,
      builder: (context) {
        final nameCtrl = TextEditingController();
        final amountCtrl = TextEditingController();
        String category = 'Food';
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('New Budget'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Budget Name')),
                const SizedBox(height: 16),
                TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Allocated Amount'), keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: category,
                  items: ['Food', 'Shopping', 'Transport', 'Bills', 'Others'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => category = v!,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            FilledButton(
              onPressed: () async {
                final name = nameCtrl.text;
                final amount = double.tryParse(amountCtrl.text) ?? 0.0;
                if (name.isNotEmpty && amount > 0) {
                  await ref.read(financeBudgetProvider.notifier).createBudget(
                    name: name,
                    amount: amount,
                    type: 'category',
                    targetId: category,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budget created.')));
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
