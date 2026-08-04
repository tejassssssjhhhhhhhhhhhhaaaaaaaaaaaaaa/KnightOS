import '../../../../core/internal/storage/drift/knight_database.dart';

class FinanceGoalSummary {
  final List<FinanceGoalReport> goalReports;
  final List<GoalInsight> insights;

  FinanceGoalSummary({
    required this.goalReports,
    required this.insights,
  });
}

class FinanceGoalReport {
  final FinanceGoalData goal;
  final double currentProgress;
  final DateTime expectedCompletion;
  final double monthlyContributionRequired;
  final String status;

  FinanceGoalReport({
    required this.goal,
    required this.currentProgress,
    required this.expectedCompletion,
    required this.monthlyContributionRequired,
    required this.status,
  });
}

class GoalInsight {
  final String title;
  final String message;
  final String evidence;
  final double confidence;
  final String reasoning;

  GoalInsight({
    required this.title,
    required this.message,
    required this.evidence,
    required this.confidence,
    required this.reasoning,
  });
}
