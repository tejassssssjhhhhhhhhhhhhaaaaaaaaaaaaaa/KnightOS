import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../domain/finance_goal_models.dart';

class FinanceGoalService {
  FinanceGoalService({required this.db, required this.dao});

  final KnightDatabase db;
  final FinancePlatformDao dao;

  Future<List<FinanceGoalReport>> calculateGoalProgress() async {
    final goals = await dao.getActiveGoals();
    
    // For automatic tracking, we need to know what to track.
    // trackingRules could contain: {"type": "account", "id": "main-savings"} 
    // or {"type": "category", "id": "Investments"}
    
    final reports = <FinanceGoalReport>[];

    for (final goal in goals) {
      double currentAmount = goal.currentAmount;
      
      // Auto-tracking logic would go here if rules exist
      // For now, using currentAmount in DB which can be updated by SmartSync or manually.
      
      final remaining = goal.targetAmount - currentAmount;
      final progress = currentAmount / goal.targetAmount;
      
      // Forecasting
      // We need savings rate from Milestone 6 or 7
      // Using a placeholder of average savings ₹5000/month if not available
      const double avgMonthlySavings = 5000.0; 
      final monthsToTarget = remaining / avgMonthlySavings;
      final expectedCompletion = DateTime.now().add(Duration(days: (monthsToTarget * 30).toInt()));

      reports.add(FinanceGoalReport(
        goal: goal,
        currentProgress: progress,
        expectedCompletion: expectedCompletion,
        monthlyContributionRequired: remaining / (goal.targetDate?.difference(DateTime.now()).inDays ?? 365) * 30,
        status: progress >= 1.0 ? 'Completed' : 'On Track',
      ));
    }

    return reports;
  }
}
