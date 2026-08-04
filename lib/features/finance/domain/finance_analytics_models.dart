import '../../../../core/internal/storage/drift/knight_database.dart';

class SpendingIntelligence {
  final Map<String, double> categoryBreakdown;
  final Map<String, double> merchantBreakdown;
  final List<TrendPoint> monthlyTrend;
  final List<TransactionData> recurringExpenses;
  final List<TransactionData> unexpectedSpending;

  SpendingIntelligence({
    required this.categoryBreakdown,
    required this.merchantBreakdown,
    required this.monthlyTrend,
    required this.recurringExpenses,
    required this.unexpectedSpending,
  });
}

class IncomeIntelligence {
  final double totalIncome;
  final List<TrendPoint> incomeTrend;
  final List<TransactionData> salaryHistory;
  final List<TransactionData> refunds;
  final Map<String, double> sourceBreakdown;

  IncomeIntelligence({
    required this.totalIncome,
    required this.incomeTrend,
    required this.salaryHistory,
    required this.refunds,
    required this.sourceBreakdown,
  });
}

class SavingsIntelligence {
  final double currentSavingsRate;
  final List<TrendPoint> savingsTrend;
  final double projectedEndOfMonth;
  final double averageMonthlySavings;

  SavingsIntelligence({
    required this.currentSavingsRate,
    required this.savingsTrend,
    required this.projectedEndOfMonth,
    required this.averageMonthlySavings,
  });
}

class CashFlowIntelligence {
  final double inflow;
  final double outflow;
  final double netCashFlow;
  final double burnRate; // daily average

  CashFlowIntelligence({
    required this.inflow,
    required this.outflow,
    required this.netCashFlow,
    required this.burnRate,
  });
}

class TrendPoint {
  final DateTime date;
  final double value;
  TrendPoint(this.date, this.value);
}

class FinanceInsight {
  final String title;
  final String message;
  final String impact;
  final List<String> evidenceIds;
  final double confidence;
  final String reasoning;

  FinanceInsight({
    required this.title,
    required this.message,
    required this.impact,
    required this.evidenceIds,
    required this.confidence,
    required this.reasoning,
  });
}

class MerchantIntelligence {
  final String merchant;
  final double lifetimeSpend;
  final double averagePurchase;
  final int frequency;
  final DateTime? lastPurchase;
  final bool isRecurring;
  final List<TrendPoint> yearlyTrend;

  MerchantIntelligence({
    required this.merchant,
    required this.lifetimeSpend,
    required this.averagePurchase,
    required this.frequency,
    this.lastPurchase,
    required this.isRecurring,
    required this.yearlyTrend,
  });
}

class CategoryIntelligence {
  final String category;
  final double lifetimeSpend;
  final List<TrendPoint> monthlyTrend;
  final double averageMonthlySpend;
  final DateTime? largestMonth;

  CategoryIntelligence({
    required this.category,
    required this.lifetimeSpend,
    required this.monthlyTrend,
    required this.averageMonthlySpend,
    this.largestMonth,
  });
}

class FinanceIntelligenceReport {
  final SpendingIntelligence spending;
  final IncomeIntelligence income;
  final SavingsIntelligence savings;
  final CashFlowIntelligence cashFlow;
  final List<MerchantIntelligence> topMerchants;
  final List<CategoryIntelligence> categories;
  final List<FinanceInsight> insights;

  FinanceIntelligenceReport({
    required this.spending,
    required this.income,
    required this.savings,
    required this.cashFlow,
    required this.topMerchants,
    required this.categories,
    required this.insights,
  });
}
