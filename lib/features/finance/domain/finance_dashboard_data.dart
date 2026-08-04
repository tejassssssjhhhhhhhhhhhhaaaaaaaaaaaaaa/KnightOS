class FinanceDashboardData {
  final double netWorth;
  final double cashPosition;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double monthlySavings;
  final double creditUtilization; // 0.0 - 1.0
  final int financialHealthScore;
  final int engineHealthScore;
  final double completenessScore; // 0.0 - 1.0
  final int needsReviewCount;
  final List<String> upcomingBills;
  final String aiInsight;

  FinanceDashboardData({
    required this.netWorth,
    required this.cashPosition,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.monthlySavings,
    required this.creditUtilization,
    required this.financialHealthScore,
    required this.engineHealthScore,
    required this.completenessScore,
    required this.needsReviewCount,
    required this.upcomingBills,
    required this.aiInsight,
  });

  factory FinanceDashboardData.empty() => FinanceDashboardData(
        netWorth: 0,
        cashPosition: 0,
        monthlyIncome: 0,
        monthlyExpenses: 0,
        monthlySavings: 0,
        creditUtilization: 0,
        financialHealthScore: 0,
        engineHealthScore: 0,
        completenessScore: 0,
        needsReviewCount: 0,
        upcomingBills: [],
        aiInsight: 'Initializing financial intelligence...',
      );
}
