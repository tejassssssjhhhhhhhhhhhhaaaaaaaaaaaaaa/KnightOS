import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../core/intelligence/domain/memory_category.dart';
import '../../../core/intelligence/domain/memory_domain.dart';
import '../../../core/intelligence/engines/memory_engine.dart';
import '../domain/money_metric.dart';
import '../domain/money_repository.dart';

class MemoryMoneyRepository implements MoneyRepository {
  const MemoryMoneyRepository({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  @override
  Future<List<MoneyMetric>> getMoneyMetrics() async {
    final memories = await memoryEngine.getByCategory(BookCategory.finance);
    if (memories.isEmpty) {
      return MoneyMetric.defaults;
    }
    return memories.map((m) => MoneyMetric.fromJson(m.content)).toList();
  }

  @override
  Future<void> updateMetric(MoneyMetric metric) async {
    final memory = KnightMemory.create(
      memoryId: 'money-${metric.category.name}',
      category: BookCategory.finance,
      domain: MemoryDomain.finance,
      content: metric.toJson(),
      summary: '${metric.category.name}: ${metric.amount}',
      source: MemorySource.manual,
      importance: 0.8,
      effectiveAt: metric.lastUpdated,
    );
    await memoryEngine.save(memory);
  }
}
