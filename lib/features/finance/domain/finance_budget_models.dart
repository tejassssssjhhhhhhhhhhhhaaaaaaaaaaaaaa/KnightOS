import '../../../../core/internal/storage/drift/knight_database.dart';

class BudgetSummary {
  final List<BudgetReport> budgetReports;
  final double dailySafeSpend;
  final double remainingMonthlyAllowance;
  final List<PlanningInsight> recommendations;

  BudgetSummary({
    required this.budgetReports,
    required this.dailySafeSpend,
    required this.remainingMonthlyAllowance,
    required this.recommendations,
  });
}

class BudgetReport {
  final FinanceBudgetData budget;
  final double spent;
  final double remaining;
  final double percentageUsed;
  final double projectedEndOfMonth;

  BudgetReport({
    required this.budget,
    required this.spent,
    required this.remaining,
    required this.percentageUsed,
    required this.projectedEndOfMonth,
  });
}

class PlanningInsight {
  final String title;
  final String message;
  final String evidence;
  final double confidence;
  final String reasoning;

  PlanningInsight({
    required this.title,
    required this.message,
    required this.evidence,
    required this.confidence,
    required this.reasoning,
  });
}
