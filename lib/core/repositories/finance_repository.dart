import '../../features/finance/domain/finance_transaction.dart';
import '../storage/local_database.dart';
import '../storage/storage_keys.dart';

class FinanceRepository {
  FinanceRepository({LocalDatabase? localDatabase})
    : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<List<FinanceTransaction>> loadTransactions() async {
    final decoded = await _database.readJsonList(
      StorageKeys.financeTransactions,
    );
    if (decoded == null) {
      return <FinanceTransaction>[];
    }

    return decoded
        .map(
          (item) => FinanceTransaction.fromJson(item as Map<String, Object?>),
        )
        .toList(growable: false);
  }

  Future<void> saveTransactions(List<FinanceTransaction> transactions) async {
    await _database.writeJsonList(
      StorageKeys.financeTransactions,
      transactions
          .map((transaction) => transaction.toJson())
          .toList(growable: false),
    );
  }

  Future<void> saveTransaction(FinanceTransaction transaction) async {
    final transactions = await loadTransactions();
    final index = transactions.indexWhere(
      (entry) => entry.id == transaction.id,
    );
    if (index >= 0) {
      transactions[index] = transaction;
    } else {
      transactions.add(transaction);
    }
    await saveTransactions(transactions);
  }

  Future<void> deleteTransaction(String id) async {
    final transactions = await loadTransactions();
    transactions.removeWhere((transaction) => transaction.id == id);
    await saveTransactions(transactions);
  }
}
