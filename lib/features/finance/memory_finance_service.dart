import '../../core/intelligence/engines/memory_engine.dart';
import '../../core/intelligence/domain/knight_memory.dart';
import '../../core/intelligence/domain/memory_category.dart';
import '../../core/intelligence/domain/memory_domain.dart';
import 'domain/finance_transaction.dart';

class MemoryFinanceService {
  MemoryFinanceService({required this.memoryEngine});
  final MemoryEngine memoryEngine;

  Future<List<FinanceTransaction>> loadTransactions() async {
    final memories = await memoryEngine.getByCategory(BookCategory.finance);
    return memories.map(_mapFromMemory).toList();
  }

  Future<void> saveTransaction(FinanceTransaction transaction) async {
    final memory = KnightMemory.create(
      memoryId: transaction.id,
      category: BookCategory.finance,
      domain: MemoryDomain.finance,
      source: MemorySource.manual,
      content: transaction.toJson(),
      summary: '${transaction.transactionType}: ${transaction.description}',
      effectiveAt:
          DateTime.tryParse(transaction.transactionDate) ?? DateTime.now(),
      verified: true,
    );
    await memoryEngine.save(memory);
  }

  Future<void> deleteTransaction(String id) async {
    await memoryEngine.delete(id);
  }

  FinanceTransaction _mapFromMemory(KnightMemory memory) {
    return FinanceTransaction.fromJson(memory.content);
  }
}
