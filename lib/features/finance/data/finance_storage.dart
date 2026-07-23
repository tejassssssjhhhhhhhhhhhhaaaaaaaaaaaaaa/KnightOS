import '../../../core/repositories/finance_repository.dart';
import '../domain/finance_transaction.dart';

class FinanceStorage {
  FinanceStorage({FinanceRepository? repository}) : _repository = repository ?? FinanceRepository();

  final FinanceRepository _repository;

  Future<List<FinanceTransaction>> loadTransactions() => _repository.loadTransactions();

  Future<void> saveTransactions(List<FinanceTransaction> transactions) => _repository.saveTransactions(transactions);

  Future<void> saveTransaction(FinanceTransaction transaction) => _repository.saveTransaction(transaction);

  Future<void> deleteTransaction(String id) => _repository.deleteTransaction(id);
}
