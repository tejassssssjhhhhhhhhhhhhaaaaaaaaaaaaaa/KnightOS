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
    final firstOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    
    final transactions = await (db.select(db.transactionTable)
          ..where((t) => t.isLatest.equals(true) & t.transactionDate.isBiggerOrEqualValue(firstOfMonth))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
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
      if (acc.type.toLowerCase().contains('credit')) {
        debt += acc.balance.abs();
      } else {
        cash += acc.balance;
      }
    }
    
    // 3. Health & Audit Metrics
    final engineHealth = await healthCenter.calculateHealthScore();
    final auditReport = await auditEngine.generateAuditReport();
    
    final totalMsgs = auditReport['total_gmail_messages'] as int? ?? 0;
    final parsedMsgs = auditReport['parsed_successfully'] as int? ?? 0;
    final completeness = totalMsgs > 0 ? (parsedMsgs / totalMsgs) : 1.0;
    
    final dao = ref.watch(financePlatformDaoProvider);
    final needsReviewCount = (await dao.getPendingTasks()).length;
    
    final creditLimit = 100000.0; // Heuristic
    final utilization = (debt / creditLimit).clamp(0.0, 1.0);

    // 4. AI Insight (Centralized data citation)
    String insight = 'Your financial data is ${ (completeness * 100).toInt()}% synchronized with the hub.';
    if (totalMsgs == 0) {
       insight = 'No financial evidence found in the Data Hub. Please start a historical sync.';
    } else if (expenses > income && income > 0) {
      insight = 'Warning: Expenses exceed income this month by ₹${(expenses - income).toStringAsFixed(0)}.';
    } else if (utilization > 0.5) {
      insight = 'Caution: High credit utilization detected across connected accounts.';
    }

    return FinanceDashboardData(
      netWorth: cash - debt,
      cashPosition: cash,
      monthlyIncome: income,
      monthlyExpenses: expenses,
      monthlySavings: income - expenses,
      creditUtilization: utilization,
      financialHealthScore: _calculateFinancialHealth(income, expenses, utilization),
      engineHealthScore: engineHealth,
      completenessScore: completeness,
      needsReviewCount: needsReviewCount,
      upcomingBills: [], // Future: Implement Bill Detection Engine
      aiInsight: insight,
    );
  }

  int _calculateFinancialHealth(double income, double expenses, double utilization) {
    if (income == 0 && expenses == 0) return 100; // Baseline
    if (income == 0) return (100 - (utilization * 100)).toInt();
    
    double savingsRate = (income - expenses) / income;
    int score = 0;
    
    // Savings Rate (Max 60 points)
    if (savingsRate > 0.3) {
      score += 60;
    } else if (savingsRate > 0.1) {
      score += 40;
    } else if (savingsRate > 0) {
      score += 20;
    }
    
    // Utilization (Max 40 points)
    if (utilization < 0.3) {
      score += 40;
    } else if (utilization < 0.5) {
      score += 20;
    } else if (utilization < 0.8) {
      score += 10;
    }
    
    return score.clamp(0, 100);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchDashboardData());
  }
}
