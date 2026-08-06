import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import 'controllers/finance_analytics_controller.dart';
import 'widgets/finance_analytics_widgets.dart';

class FinanceAnalyticsScreen extends ConsumerWidget {
  const FinanceAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(financeAnalyticsProvider);

    return KnightPageScaffold(
      title: 'Intelligence',
      showBackButton: true,
      body: reportAsync.when(
        data: (report) => RefreshIndicator(
          onRefresh: () => ref.read(financeAnalyticsProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text('SYSTEM INSIGHTS', style: KnightTokens.label),
              ...report.insights.map((insight) => InsightTile(insight: insight)),
              const SizedBox(height: 32),
              
              IntelligenceModuleCard(
                title: 'Spending Trends',
                child: Column(
                  children: [
                    TrendSparkline(points: report.spending.monthlyTrend, color: Colors.redAccent),
                    const SizedBox(height: 24),
                    SpendingPieChart(data: report.spending.categoryBreakdown),
                  ],
                ),
              ),

              IntelligenceModuleCard(
                title: 'Cash Flow',
                child: Column(
                  children: [
                    _MetricSummaryRow(label: 'MONTHLY INFLOW', value: '₹${report.cashFlow.inflow.toStringAsFixed(0)}', color: Colors.greenAccent),
                    _MetricSummaryRow(label: 'MONTHLY OUTFLOW', value: '₹${report.cashFlow.outflow.toStringAsFixed(0)}', color: Colors.redAccent),
                    _MetricSummaryRow(label: 'DAILY BURN RATE', value: '₹${report.cashFlow.burnRate.toStringAsFixed(0)}', color: Colors.blueAccent),
                  ],
                ),
              ),

              IntelligenceModuleCard(
                title: 'Savings Engine',
                child: Column(
                  children: [
                    _MetricSummaryRow(
                      label: 'SAVINGS RATE', 
                      value: '${(report.savings.currentSavingsRate.isNaN || report.savings.currentSavingsRate.isInfinite) ? 0 : (report.savings.currentSavingsRate * 100).toInt()}%', 
                      color: Colors.blueAccent
                    ),
                    _MetricSummaryRow(label: 'AVG MONTHLY SAVINGS', value: '₹${report.savings.averageMonthlySavings.toStringAsFixed(0)}', color: Colors.cyanAccent),
                    const SizedBox(height: 16),
                    TrendSparkline(points: report.savings.savingsTrend, color: Colors.blueAccent),
                  ],
                ),
              ),

              IntelligenceModuleCard(
                title: 'Income Breakdown',
                child: Column(
                  children: [
                    _MetricSummaryRow(label: 'LIFETIME INCOME', value: '₹${report.income.totalIncome.toStringAsFixed(0)}', color: Colors.greenAccent),
                    const SizedBox(height: 16),
                    SpendingPieChart(data: report.income.sourceBreakdown),
                  ],
                ),
              ),

              IntelligenceModuleCard(
                title: 'Top Merchants',
                child: MerchantIntelligenceList(merchants: report.topMerchants),
              ),

              IntelligenceModuleCard(
                title: 'Category Deep Dive',
                child: CategoryIntelligenceList(categories: report.categories),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Analytics Error: $e')),
      ),
    );
  }
}

class _MetricSummaryRow extends StatelessWidget {
  const _MetricSummaryRow({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(label, style: KnightTokens.label.copyWith(fontSize: 8, color: Colors.white24)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
