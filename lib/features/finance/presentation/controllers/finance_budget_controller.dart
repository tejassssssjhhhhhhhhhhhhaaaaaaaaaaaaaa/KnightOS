import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/finance_budget_models.dart';
import '../../platform/providers/finance_platform_providers.dart';
import '../../../../core/providers/database_provider.dart';
import '../../platform/sync/finance_budget_service.dart';

final financeBudgetServiceProvider = Provider<FinanceBudgetService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = ref.watch(financePlatformDaoProvider);
  return FinanceBudgetService(db: db, dao: dao);
});

final financeBudgetProvider = AsyncNotifierProvider<FinanceBudgetController, BudgetSummary>(
  FinanceBudgetController.new,
);

class FinanceBudgetController extends AsyncNotifier<BudgetSummary> {
  @override
  Future<BudgetSummary> build() async {
    return _fetchSummary();
  }

  Future<BudgetSummary> _fetchSummary() async {
    final service = ref.watch(financeBudgetServiceProvider);
    
    final reports = await service.calculateBudgetStatus();
    final safeSpend = await service.calculateDailySafeSpend();

    return BudgetSummary(
      budgetReports: reports,
      dailySafeSpend: safeSpend['daily_limit'] ?? 0,
      remainingMonthlyAllowance: safeSpend['remaining_monthly'] ?? 0,
      recommendations: _generateRecommendations(reports, safeSpend),
    );
  }

  List<PlanningInsight> _generateRecommendations(List<BudgetReport> reports, Map<String, double> safeSpend) {
    final insights = <PlanningInsight>[];
    
    for (final report in reports) {
      if (report.percentageUsed > 0.8 && report.percentageUsed < 1.0) {
        insights.add(PlanningInsight(
          title: 'High Burn Rate',
          message: 'You have used ${(report.percentageUsed * 100).toInt()}% of your ${report.budget.name} budget.',
          evidence: 'Spent ₹${report.spent.toStringAsFixed(0)} out of ₹${report.budget.allocatedAmount.toStringAsFixed(0)}.',
          confidence: 0.98,
          reasoning: 'Calculated from verified transaction ledger vs budget allocation.',
        ));
      } else if (report.percentageUsed >= 1.0) {
         insights.add(PlanningInsight(
          title: 'Budget Exceeded',
          message: 'Your ${report.budget.name} budget is overdrawn by ₹${(report.spent - report.budget.allocatedAmount).toStringAsFixed(0)}.',
          evidence: 'Actual spend has surpassed the allocation threshold.',
          confidence: 1.0,
          reasoning: 'System detected a terminal overdraw state.',
        ));
      }
    }

    if (insights.isEmpty) {
      insights.add(PlanningInsight(
        title: 'Plan Optimal',
        message: "You're on track to stay within your monthly limits.",
        evidence: 'Burn rate is sustainable for the remaining ${DateTime.now().day} days.',
        confidence: 0.9,
        reasoning: 'Linear projection of current spending patterns.',
      ));
    }

    return insights;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSummary());
  }
}
