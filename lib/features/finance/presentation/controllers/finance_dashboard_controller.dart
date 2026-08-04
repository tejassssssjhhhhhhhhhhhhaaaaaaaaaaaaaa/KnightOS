import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../domain/finance_dashboard_data.dart';
import '../../platform/providers/finance_platform_providers.dart';
import '../../../../core/providers/database_provider.dart';

final financeDashboardProvider = AsyncNotifierProvider<FinanceDashboardController, FinanceDashboardData>(
  FinanceDashboardController.new,
);

class FinanceDashboardController extends AsyncNotifier<FinanceDashboardData> {
  @override
  Future<FinanceDashboardData> build() async {
    return _fetchDashboardData();
  }

  Future<FinanceDashboardData> _fetchDashboardData() async {
    final db = ref.watch(knightDatabaseProvider);
    final healthCenter = ref.watch(financeHealthCenterProvider);
    final auditEngine = ref.watch(gmailAuditEngineProvider);

    // 1. Fetch Transactions (Current Month)
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    final transactions = await (db.select(db.transactionTable)
          ..where((t) => t.isLatest.equals(true))
          ..where((t) => t.transactionDate.isBiggerOrEqualValue(startOfMonth)))
        .get();

    double income = 0;
    double expenses = 0;
    for (final tx in transactions) {
      if (tx.type == 'income') {
        income += tx.amount;
      } else if (tx.type == 'expense') {
        expenses += tx.amount;
      }
    }

    // 2. Fetch Accounts (Net Worth & Cash Position)
    final accounts = await db.select(db.financialAccountTable).get();
    double cash = 0;
    double debt = 0;
    for (final acc in accounts) {
      // Simplified heuristic for now
      if (acc.type.toLowerCase().contains('credit')) {
        debt += 0; // We'd need balance fields here, using 0 for now as placeholder
      } else {
        cash += 0; // Placeholder
      }
    }
    
    // 3. Health & Audit Metrics
    final engineHealth = await healthCenter.calculateHealthScore();
    final auditReport = await auditEngine.generateAuditReport();
    final completeness = auditReport['parser_success_rate'] as double? ?? 0.0;
    final dao = ref.watch(financePlatformDaoProvider);
    final needsReviewCount = (await dao.getPendingTasks()).length;

    // 4. AI Insight (Placeholder logic for Milestone 1)
    String insight = 'Your financial data is ${ (completeness * 100).toInt()}% synchronized.';
    if (expenses > income && income > 0) {
      insight = 'Warning: Expenses exceed income this month by ₹${(expenses - income).toStringAsFixed(0)}.';
    }

    return FinanceDashboardData(
      netWorth: cash - debt,
      cashPosition: cash,
      monthlyIncome: income,
      monthlyExpenses: expenses,
      monthlySavings: income - expenses,
      creditUtilization: debt > 0 ? (debt / 100000).clamp(0, 1) : 0, // Placeholder limit
      financialHealthScore: 85, // To be implemented with detailed logic
      engineHealthScore: engineHealth,
      completenessScore: completeness,
      needsReviewCount: needsReviewCount,
      upcomingBills: [], // Milestone 7
      aiInsight: insight,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchDashboardData());
  }
}
