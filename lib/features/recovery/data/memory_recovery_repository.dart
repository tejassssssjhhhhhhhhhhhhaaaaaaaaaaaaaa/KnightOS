import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../core/intelligence/domain/memory_category.dart';
import '../../../core/intelligence/domain/memory_domain.dart';
import '../../../core/intelligence/engines/memory_engine.dart';
import '../domain/recovery_metric.dart';
import '../domain/recovery_repository.dart';

/// Memory-backed implementation of [RecoveryRepository].
class MemoryRecoveryRepository implements RecoveryRepository {
  const MemoryRecoveryRepository({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  @override
  Future<List<RecoveryMetric>> getRecoveryMetrics() async {
    final memories = await memoryEngine.getByCategory(BookCategory.health);
    if (memories.isEmpty) {
      return RecoveryMetric.defaults;
    }

    return memories.map((m) => RecoveryMetric.fromJson(m.content)).toList();
  }

  @override
  Future<void> updateMetric(RecoveryMetric metric) async {
    final memory = KnightMemory.create(
      memoryId: 'recovery-${metric.category.name}',
      category: BookCategory.health,
      domain: MemoryDomain.health,
      content: metric.toJson(),
      summary: '${metric.category.name} status: ${metric.status}',
      source: MemorySource.manual,
      importance: 0.7,
      effectiveAt: metric.lastUpdated,
    );
    await memoryEngine.save(memory);
  }
}
