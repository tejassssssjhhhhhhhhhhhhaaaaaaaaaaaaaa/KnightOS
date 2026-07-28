import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../core/intelligence/domain/memory_category.dart';
import '../../../core/intelligence/domain/memory_domain.dart';
import '../../../core/intelligence/engines/memory_engine.dart';
import '../domain/timeline_entry.dart';
import '../domain/timeline_repository.dart';

class MemoryTimelineRepository implements TimelineRepository {
  const MemoryTimelineRepository({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  @override
  Future<List<TimelineEntry>> getEntries() async {
    final memories = await memoryEngine.getByCategory(BookCategory.history);
    if (memories.isEmpty) {
      return TimelineEntry.defaults;
    }
    return memories.map((m) => TimelineEntry.fromJson(m.content)).toList();
  }

  @override
  Future<void> saveEntry(TimelineEntry entry) async {
    final memory = KnightMemory.create(
      memoryId: 'timeline-${entry.id}',
      category: BookCategory.history,
      domain: MemoryDomain.memories,
      content: entry.toJson(),
      summary: 'Timeline: ${entry.title}',
      source: MemorySource.manual,
      importance: entry.importance == TimelineImportance.high ? 0.9 : 0.6,
      effectiveAt: entry.timestamp,
    );
    await memoryEngine.save(memory);
  }

  @override
  Future<void> deleteEntry(String id) async {}
}
