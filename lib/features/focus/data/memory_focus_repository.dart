import '../../../core/intelligence/domain/knight_memory.dart';
import '../../../core/intelligence/domain/memory_category.dart';
import '../../../core/intelligence/domain/memory_domain.dart';
import '../../../core/intelligence/engines/memory_engine.dart';
import '../domain/focus_area.dart';
import '../domain/focus_repository.dart';

/// Memory-backed implementation of [FocusRepository].
/// This is the v2 architecture where the feature module is a client of the Intelligence Layer.
class MemoryFocusRepository implements FocusRepository {
  const MemoryFocusRepository({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  @override
  Future<List<FocusArea>> getFocusAreas() async {
    final memories = await memoryEngine.getByCategory(BookCategory.career);
    if (memories.isEmpty) {
      // Fallback to placeholders if no memories exist yet (first run or migration pending)
      return FocusArea.placeholders;
    }

    return memories.map((m) => FocusArea.fromJson(m.content)).toList();
  }

  @override
  Future<void> updateFocusArea(FocusArea area) async {
    final memory = KnightMemory.create(
      memoryId: 'focus-${area.category.name}',
      category: BookCategory.career,
      domain: MemoryDomain.projects,
      content: area.toJson(),
      summary: 'Focus update: ${area.title}',
      source: MemorySource.manual,
      importance: area.isAiPrioritized ? 0.9 : 0.6,
      effectiveAt: area.lastUpdated,
    );
    await memoryEngine.save(memory);
  }
}
