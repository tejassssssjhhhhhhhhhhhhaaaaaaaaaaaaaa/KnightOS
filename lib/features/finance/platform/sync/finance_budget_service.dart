import 'package:drift/drift.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../domain/finance_budget_models.dart';

class FinanceBudgetService {
  FinanceBudgetService({required this.db, required this.dao});

  final KnightDatabase db;
  final FinancePlatformDao dao;

  Future<List<BudgetReport>> calculateBudgetStatus() async {
    final budgets = await dao.getActiveBudgets();
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    final txs = await (db.select(db.transactionTable)
          ..where((t) => t.isLatest.equals(true))
          ..where((t) => t.transactionDate.isBiggerOrEqualValue(startOfMonth))
          ..where((t) => t.type.equals('expense')))
        .get();

    final reports = <BudgetReport>[];
    
    for (final budget in budgets) {
      double spent = 0;
      if (budget.type == 'overall') {
        spent = txs.fold(0, (sum, t) => sum + t.amount);
      } else if (budget.type == 'category') {
        spent = txs.where((t) => t.category == budget.targetId).fold(0, (sum, t) => sum + t.amount);
      } else if (budget.type == 'merchant') {
        spent = txs.where((t) => t.merchant == budget.targetId).fold(0, (sum, t) => sum + t.amount);
      }

      final daysPassed = now.day;
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      final burnRate = spent / daysPassed;
      final projection = burnRate * daysInMonth;

      reports.add(BudgetReport(
        budget: budget,
        spent: spent,
        remaining: budget.allocatedAmount - spent,
        percentageUsed: spent / budget.allocatedAmount,
        projectedEndOfMonth: projection,
      ));
    }

    return reports;
  }

  Future<Map<String, double>> calculateDailySafeSpend() async {
    final reports = await calculateBudgetStatus();
    final overall = reports.firstWhere((r) => r.budget.type == 'overall', orElse: () => _defaultOverallReport());
    
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final remainingDays = (daysInMonth - now.day) + 1;
    
    final dailyLimit = overall.remaining / remainingDays;
    
    return {
      'daily_limit': dailyLimit > 0 ? dailyLimit : 0,
      'remaining_monthly': overall.remaining > 0 ? overall.remaining : 0,
    };
  }

  BudgetReport _defaultOverallReport() {
    return BudgetReport(
      budget: FinanceBudgetData(
        id: '0', 
        name: 'Overall', 
        type: 'overall', 
        allocatedAmount: 0, 
        startDate: DateTime.now(), 
        isActive: true, 
        period: 'monthly',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
        syncStatus: 'local',
        isDeleted: false,
      ),
      spent: 0,
      remaining: 0,
      percentageUsed: 0,
      projectedEndOfMonth: 0,
    );
  }
}
