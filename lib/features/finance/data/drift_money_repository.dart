import 'package:drift/drift.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../domain/money_metric.dart';
import '../domain/money_repository.dart';

class DriftMoneyRepository implements MoneyRepository {
  const DriftMoneyRepository({required this.db});

  final KnightDatabase db;

  @override
  Future<List<MoneyMetric>> getMoneyMetrics() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final transactions = await (db.select(db.transactionTable)
          ..where((t) => t.transactionDate.isBetweenValues(startOfMonth, DateTime(2100))))
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

    final totalSavings = await db.financialDao.getTotalBalance();
    
    // Fetch actual budgets
    final budgets = await (db.select(db.financeBudgetTable)..where((t) => t.isActive.equals(true))).get();
    final totalBudget = budgets.fold(0.0, (sum, b) => sum + b.allocatedAmount);

    return [
      MoneyMetric(
        category: MoneyCategory.income,
        amount: income,
        status: 'Calculated from Hub',
        lastUpdated: now,
      ),
      MoneyMetric(
        category: MoneyCategory.expenses,
        amount: expenses,
        status: 'Extracted this month',
        isAiAnalyzed: true,
        lastUpdated: now,
      ),
      MoneyMetric(
        category: MoneyCategory.savings,
        amount: totalSavings,
        status: 'Net Position',
        lastUpdated: now,
      ),
      MoneyMetric(
        category: MoneyCategory.budget,
        amount: totalBudget,
        status: 'Active Budgets',
        lastUpdated: now,
      ),
    ];
  }

  @override
  Future<void> updateMetric(MoneyMetric metric) async {
    // Read-only from centralized data for now
  }
}
