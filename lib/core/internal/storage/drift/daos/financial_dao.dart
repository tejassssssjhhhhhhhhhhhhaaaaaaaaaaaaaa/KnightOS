import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/financial_accounts.dart';
import '../tables/transactions.dart';

part 'financial_dao.g.dart';

@DriftAccessor(tables: [FinancialAccountTable, TransactionTable])
class FinancialDao extends DatabaseAccessor<KnightDatabase> with _$FinancialDaoMixin {
  FinancialDao(super.db);

  Future<List<FinancialAccountData>> getAllAccounts() {
    return select(financialAccountTable).get();
  }

  Future<List<TransactionData>> getTransactions({int limit = 50}) {
    return (select(transactionTable)
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)])
          ..limit(limit))
        .get();
  }

  Future<void> upsertAccount(FinancialAccountTableCompanion account) async {
    await into(financialAccountTable).insertOnConflictUpdate(account);
  }

  Future<int> insertTransaction(TransactionTableCompanion transaction) {
    return into(transactionTable).insert(transaction);
  }

  Future<bool> transactionExists(String hash) async {
    final query = select(transactionTable)..where((t) => t.dedupeHash.equals(hash));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<double> getTotalBalance() async {
    final accounts = await getAllAccounts();
    double total = 0;
    for (final account in accounts) {
      total += account.balance;
    }
    
    // P0: Fallback to SQL aggregation to avoid main thread loops over large datasets
    if (total == 0) {
      final incomeQuery = selectOnly(transactionTable)..addColumns([transactionTable.amount.sum()])..where(transactionTable.type.equals('income'));
      final expenseQuery = selectOnly(transactionTable)..addColumns([transactionTable.amount.sum()])..where(transactionTable.type.equals('expense'));
      
      final income = await incomeQuery.map((row) => row.read(transactionTable.amount.sum())).getSingle();
      final expense = await expenseQuery.map((row) => row.read(transactionTable.amount.sum())).getSingle();
      
      total = (income ?? 0.0) - (expense ?? 0.0);
    }
    return total;
  }
}
