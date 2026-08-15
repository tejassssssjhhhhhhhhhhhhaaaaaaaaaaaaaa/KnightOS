import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../domain/finance_goal_models.dart';
import '../../platform/providers/finance_platform_providers.dart';
import '../../../../core/providers/database_provider.dart';
import '../../platform/sync/finance_goal_service.dart';

final financeGoalServiceProvider = Provider<FinanceGoalService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = ref.watch(financePlatformDaoProvider);
  return FinanceGoalService(db: db, dao: dao);
});

final financeGoalProvider = AsyncNotifierProvider<FinanceGoalController, FinanceGoalSummary>(
  FinanceGoalController.new,
);

class FinanceGoalController extends AsyncNotifier<FinanceGoalSummary> {
  @override
  Future<FinanceGoalSummary> build() async {
    return _fetchSummary();
  }

  Future<FinanceGoalSummary> _fetchSummary() async {
    final service = ref.watch(financeGoalServiceProvider);
    final reports = await service.calculateGoalProgress();

    return FinanceGoalSummary(
      goalReports: reports,
      insights: _generateInsights(reports),
    );
  }

  List<GoalInsight> _generateInsights(List<FinanceGoalReport> reports) {
    final insights = <GoalInsight>[];
    
    for (final report in reports) {
      if (report.currentProgress < 0.2) {
         insights.add(GoalInsight(
          title: 'Goal Started',
          message: "You've begun your journey towards ${report.goal.name}.",
          evidence: "Progress is at ${(report.currentProgress * 100).toInt()}%.",
          confidence: 1.0,
          reasoning: "Initial progress tracking active.",
        ));
      }
      
      if (report.status == 'On Track') {
        insights.add(GoalInsight(
          title: 'Success Likelihood High',
          message: "You are on track to fund ${report.goal.name} by ${report.expectedCompletion.year}.",
          evidence: "Requires ₹${report.monthlyContributionRequired.toStringAsFixed(0)} / month.",
          confidence: 0.85,
          reasoning: "Current burn rate and savings pattern match target trajectory.",
        ));
      }
    }

    if (insights.isEmpty) {
       insights.add(GoalInsight(
          title: 'Goals Nominal',
          message: "Active monitoring of wealth builder goals.",
          evidence: "All targets within range.",
          confidence: 0.9,
          reasoning: "No anomalies detected in progress tracking.",
        ));
    }

    return insights;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSummary());
  }

  Future<void> createGoal({
    required String name,
    required double targetAmount,
    required String type,
  }) async {
    final dao = ref.read(financePlatformDaoProvider);
    final now = DateTime.now();

    await dao.insertGoal(FinanceGoalTableCompanion.insert(
      id: 'goal-${now.millisecondsSinceEpoch}',
      name: name,
      type: type,
      targetAmount: targetAmount,
      currentAmount: const Value(0.0),
      targetDate: Value(now.add(const Duration(days: 365))), // Default 1 year
      status: const Value('active'),
      createdAt: Value(now),
      updatedAt: Value(now),
      version: const Value(1),
      syncStatus: const Value('local'),
    ));

    await refresh();
  }
}
