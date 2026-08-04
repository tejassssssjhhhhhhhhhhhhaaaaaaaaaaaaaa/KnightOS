import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import '../../domain/finance_analytics_models.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/providers/database_provider.dart';

final financeAnalyticsProvider = AsyncNotifierProvider<FinanceAnalyticsController, FinanceIntelligenceReport>(
  FinanceAnalyticsController.new,
);

class FinanceAnalyticsController extends AsyncNotifier<FinanceIntelligenceReport> {
  @override
  Future<FinanceIntelligenceReport> build() async {
    return _calculateIntelligence();
  }

  Future<FinanceIntelligenceReport> _calculateIntelligence() async {
    final db = ref.watch(knightDatabaseProvider);
    final txs = await (db.select(db.transactionTable)
          ..where((t) => t.isLatest.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.transactionDate)]))
        .get();

    if (txs.isEmpty) {
      return _emptyReport();
    }

    // 1. Spending Intelligence
    final spendingTxs = txs.where((t) => t.type == 'expense').toList();
    final catBreakdown = groupBy(spendingTxs, (TransactionData t) => t.category)
        .map((k, v) => MapEntry(k, v.fold(0.0, (sum, t) => sum + t.amount)));
    final merchantBreakdown = groupBy(spendingTxs, (TransactionData t) => t.merchant)
        .map((k, v) => MapEntry(k, v.fold(0.0, (sum, t) => sum + t.amount)));

    // 2. Income Intelligence
    final incomeTxs = txs.where((t) => t.type == 'income').toList();
    final salaryHistory = incomeTxs.where((t) => t.category.toLowerCase() == 'salary').toList();
    final refunds = incomeTxs.where((t) => t.category.toLowerCase().contains('refund')).toList();

    // 3. Trends (Group by Month)
    final monthlyGrouped = groupBy(txs, (TransactionData t) => DateTime(t.transactionDate.year, t.transactionDate.month));
    final spendingTrend = <TrendPoint>[];
    final incomeTrend = <TrendPoint>[];
    final savingsTrend = <TrendPoint>[];

    monthlyGrouped.forEach((date, periodTxs) {
      final periodIncome = periodTxs.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
      final periodSpending = periodTxs.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
      
      spendingTrend.add(TrendPoint(date, periodSpending));
      incomeTrend.add(TrendPoint(date, periodIncome));
      savingsTrend.add(TrendPoint(date, periodIncome - periodSpending));
    });

    // 4. Merchant Intelligence
    final merchantGroups = groupBy(spendingTxs, (TransactionData t) => t.merchant);
    final topMerchants = merchantGroups.entries.map((e) {
      final mTxs = e.value;
      final sortedMTxs = mTxs.toList()..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      final yearlyTrend = groupBy(mTxs, (TransactionData t) => t.transactionDate.year)
          .map((year, txs) => MapEntry(year, txs.fold(0.0, (sum, t) => sum + t.amount)))
          .entries
          .map((entry) => TrendPoint(DateTime(entry.key), entry.value))
          .toList();

      return MerchantIntelligence(
        merchant: e.key,
        lifetimeSpend: mTxs.fold(0.0, (sum, t) => sum + t.amount),
        averagePurchase: mTxs.fold(0.0, (sum, t) => sum + t.amount) / mTxs.length,
        frequency: mTxs.length,
        lastPurchase: sortedMTxs.first.transactionDate,
        isRecurring: mTxs.length >= 3, // Simple heuristic for recurring
        yearlyTrend: yearlyTrend,
      );
    }).toList()..sort((a, b) => b.lifetimeSpend.compareTo(a.lifetimeSpend));

    // 5. Category Intelligence
    final categoryGroups = groupBy(spendingTxs, (TransactionData t) => t.category);
    final categoryIntell = categoryGroups.entries.map((e) {
      final cTxs = e.value;
      final monthly = groupBy(cTxs, (TransactionData t) => DateTime(t.transactionDate.year, t.transactionDate.month))
          .map((date, txs) => MapEntry(date, txs.fold(0.0, (sum, t) => sum + t.amount)));
      
      final largestMonthEntry = monthly.entries.isNotEmpty 
          ? monthly.entries.reduce((a, b) => a.value > b.value ? a : b)
          : null;

      return CategoryIntelligence(
        category: e.key,
        lifetimeSpend: cTxs.fold(0.0, (sum, t) => sum + t.amount),
        monthlyTrend: monthly.entries.map((entry) => TrendPoint(entry.key, entry.value)).toList(),
        averageMonthlySpend: cTxs.fold(0.0, (sum, t) => sum + t.amount) / (monthly.isNotEmpty ? monthly.length : 1),
        largestMonth: largestMonthEntry?.key,
      );
    }).toList()..sort((a, b) => b.lifetimeSpend.compareTo(a.lifetimeSpend));

    // 6. Cash Flow (Current Month)
    final now = DateTime.now();
    final currentMonthTxs = txs.where((t) => t.transactionDate.year == now.year && t.transactionDate.month == now.month).toList();
    final monthlyInflow = currentMonthTxs.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
    final monthlyOutflow = currentMonthTxs.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);

    final report = FinanceIntelligenceReport(
      spending: SpendingIntelligence(
        categoryBreakdown: catBreakdown,
        merchantBreakdown: merchantBreakdown,
        monthlyTrend: spendingTrend,
        recurringExpenses: [], 
        unexpectedSpending: spendingTxs.where((t) => t.amount > 10000).toList(),
      ),
      income: IncomeIntelligence(
        totalIncome: incomeTxs.fold(0.0, (sum, t) => sum + t.amount),
        incomeTrend: incomeTrend,
        salaryHistory: salaryHistory,
        refunds: refunds,
        sourceBreakdown: groupBy(incomeTxs, (TransactionData t) => t.institution)
            .map((k, v) => MapEntry(k, v.fold(0.0, (sum, t) => sum + t.amount))),
      ),
      savings: SavingsIntelligence(
        currentSavingsRate: monthlyInflow > 0 ? ((monthlyInflow - monthlyOutflow) / monthlyInflow) : 0,
        savingsTrend: savingsTrend,
        projectedEndOfMonth: monthlyInflow - (monthlyOutflow / now.day * 30),
        averageMonthlySavings: savingsTrend.isEmpty ? 0 : savingsTrend.fold(0.0, (sum, p) => sum + p.value) / savingsTrend.length,
      ),
      cashFlow: CashFlowIntelligence(
        inflow: monthlyInflow,
        outflow: monthlyOutflow,
        netCashFlow: monthlyInflow - monthlyOutflow,
        burnRate: monthlyOutflow / now.day,
      ),
      topMerchants: topMerchants.take(10).toList(),
      categories: categoryIntell,
      insights: _generateInsights(txs, monthlyInflow, monthlyOutflow, catBreakdown),
    );

    return report;
  }

  List<FinanceInsight> _generateInsights(
    List<TransactionData> txs, 
    double currentInflow, 
    double currentOutflow,
    Map<String, double> catBreakdown,
  ) {
    final insights = <FinanceInsight>[];

    // 1. Deficit Check
    if (currentOutflow > currentInflow && currentInflow > 0) {
      insights.add(FinanceInsight(
        title: 'Net Cash Deficit',
        message: 'Your spending exceeds your income this month by ₹${(currentOutflow - currentInflow).toStringAsFixed(0)}.',
        impact: 'Negative cash flow reduces your total net worth and liquidity.',
        evidenceIds: txs.where((t) => t.transactionDate.month == DateTime.now().month).map((t) => t.id).toList(),
        confidence: 1.0,
        reasoning: 'Calculated by aggregating all verified income vs expense transactions for the current billing cycle.',
      ));
    }

    // 2. Spending Concentration
    final sortedCats = catBreakdown.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    if (sortedCats.isNotEmpty) {
      final top = sortedCats.first;
      insights.add(FinanceInsight(
        title: 'Spending Concentration',
        message: '${top.key} accounts for ${((top.value / currentOutflow) * 100).toInt()}% of your total outflow.',
        impact: 'Optimizing this category offers the highest leverage for increasing savings.',
        evidenceIds: [],
        confidence: 0.95,
        reasoning: 'Category-level aggregation identified a high volumetric concentration in ${top.key}.',
      ));
    }

    // 3. Savings Rate Trend
    final monthlyGrouped = groupBy(txs, (TransactionData t) => DateTime(t.transactionDate.year, t.transactionDate.month));
    if (monthlyGrouped.length >= 2) {
      final months = monthlyGrouped.keys.toList()..sort((a, b) => b.compareTo(a));
      final lastMonth = months[1];
      final lastMonthTxs = monthlyGrouped[lastMonth]!;
      final lastInflow = lastMonthTxs.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
      final lastOutflow = lastMonthTxs.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
      final lastRate = lastInflow > 0 ? (lastInflow - lastOutflow) / lastInflow : 0;
      final currentRate = currentInflow > 0 ? (currentInflow - currentOutflow) / currentInflow : 0;

      if (currentRate > lastRate) {
        insights.add(FinanceInsight(
          title: 'Savings Performance',
          message: 'Your savings rate has improved from ${(lastRate * 100).toInt()}% to ${(currentRate * 100).toInt()}% compared to last month.',
          impact: 'Positive trend indicates improved financial discipline and faster goal attainment.',
          evidenceIds: [],
          confidence: 0.9,
          reasoning: 'Comparative analysis of month-over-month net savings yield.',
        ));
      }
    }

    return insights;
  }

  FinanceIntelligenceReport _emptyReport() {
    return FinanceIntelligenceReport(
      spending: SpendingIntelligence(categoryBreakdown: {}, merchantBreakdown: {}, monthlyTrend: [], recurringExpenses: [], unexpectedSpending: []),
      income: IncomeIntelligence(totalIncome: 0, incomeTrend: [], salaryHistory: [], refunds: [], sourceBreakdown: {}),
      savings: SavingsIntelligence(currentSavingsRate: 0, savingsTrend: [], projectedEndOfMonth: 0, averageMonthlySavings: 0),
      cashFlow: CashFlowIntelligence(inflow: 0, outflow: 0, netCashFlow: 0, burnRate: 0),
      topMerchants: [],
      categories: [],
      insights: [],
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _calculateIntelligence());
  }
}
