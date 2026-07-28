import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../domain/finance_transaction.dart';

class FinanceTrackerScreen extends ConsumerWidget {
  const FinanceTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeService = ref.watch(financeServiceProvider);

    return KnightPageScaffold(
      body: FutureBuilder<List<FinanceTransaction>>(
        future: financeService.loadTransactions(),
        builder: (context, snapshot) {
          final transactions = snapshot.data ?? [];
          final metrics = FinanceTransactionMetrics.fromTransactions(transactions);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(DesignSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildTabs(context),
                const SizedBox(height: 32),
                _buildBalanceCard(context, metrics),
                const SizedBox(height: 32),
                _buildChartSection(context),
                const SizedBox(height: 32),
                _buildQuickActions(context),
                const SizedBox(height: 140),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text('Finance', style: Theme.of(context).textTheme.headlineMedium),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabs = ['Overview', 'Transactions', 'Budgets', 'Goals'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isActive = tab == 'Overview';
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tab,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, FinanceTransactionMetrics metrics) {
    return Card(
      color: DesignColors.surfaceHigh,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TOTAL BALANCE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${NumberFormat('#,##,###').format(metrics.netBalance)}',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white24),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.arrow_upward_rounded, size: 14, color: DesignColors.success),
                const SizedBox(width: 4),
                Text('8.5%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: DesignColors.success)),
                const SizedBox(width: 4),
                const Text('from last month', style: TextStyle(fontSize: 11, color: Colors.white24)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('INCOME VS EXPENSES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
        const SizedBox(height: 20),
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(6, (i) {
              final heights = [0.4, 0.7, 0.5, 0.9, 0.6, 0.8];
              return Container(
                width: 12,
                height: 100 * heights[i],
                decoration: BoxDecoration(
                  color: i == 3 ? DesignColors.accentBlue : Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('QUICK ACTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionItem(Icons.add_rounded, 'Add Expense'),
            _buildActionItem(Icons.add_rounded, 'Add Income'),
            _buildActionItem(Icons.tune_rounded, 'Set Budget'),
            _buildActionItem(Icons.track_changes_rounded, 'Financial Goals'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: DesignColors.surfaceHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignColors.white05),
          ),
          child: Icon(icon, size: 20, color: DesignColors.accentBlue),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: Colors.white38, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
