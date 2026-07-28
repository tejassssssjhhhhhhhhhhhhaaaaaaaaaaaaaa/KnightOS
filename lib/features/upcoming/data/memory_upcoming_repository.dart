import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../core/intelligence/domain/memory_category.dart';
import '../../../core/intelligence/domain/memory_domain.dart';
import '../../../core/intelligence/engines/memory_engine.dart';
import '../domain/upcoming_item.dart';
import '../domain/upcoming_repository.dart';

class MemoryUpcomingRepository implements UpcomingRepository {
  const MemoryUpcomingRepository({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  @override
  Future<List<UpcomingItem>> getUpcomingItems() async {
    final memories = await memoryEngine.getByCategory(BookCategory.ambitions);
    if (memories.isEmpty) {
      return UpcomingItem.defaults;
    }
    return memories.map((m) => UpcomingItem.fromJson(m.content)).toList();
  }

  @override
  Future<void> saveUpcomingItem(UpcomingItem item) async {
    final memory = KnightMemory.create(
      memoryId: 'upcoming-${item.id}',
      category: BookCategory.ambitions,
      domain: MemoryDomain.goals,
      content: item.toJson(),
      summary: 'Upcoming: ${item.title}',
      source: MemorySource.manual,
      importance: item.priority == PriorityLevel.high ? 0.9 : 0.6,
      effectiveAt: item.dueDate,
    );
    await memoryEngine.save(memory);
  }

  @override
  Future<void> deleteUpcomingItem(String id) async {
    // Soft delete in memory engine or just filter in repo
    // For foundation, we just ignore it in retrieval if we want.
    // But MemoryEngine should probably support deletion.
  }
}
