import '../../core/intelligence/engines/memory_engine.dart';
import '../../core/intelligence/domain/knight_memory.dart';
import '../../core/intelligence/domain/memory_category.dart';
import '../../core/intelligence/domain/memory_domain.dart';

/// Client-side service for the Memory module, backed by the Unified Memory Engine.
class MemoryService {
  const MemoryService({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  Future<void> saveQuickNote(String title, String body) async {
    final memory = KnightMemory.create(
      memoryId: 'note-${DateTime.now().millisecondsSinceEpoch}',
      category: BookCategory.history,
      domain: MemoryDomain.memories,
      content: {'title': title, 'body': body},
      summary: title,
      source: MemorySource.manual,
      importance: 0.5,
    );
    await memoryEngine.save(memory);
  }
}
