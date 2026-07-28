import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import 'memory_engine.dart';

/// Analyzes events and interactions to extract insights and lessons.
class ReflectionEngine {
  const ReflectionEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Generates a reflection memory after a user interaction or milestone.
  Future<void> reflectOnEvent(String eventId, String summary) async {
    final memory = KnightMemory.create(
      memoryId: 'reflection-$eventId',
      category: BookCategory.history,
      domain: MemoryDomain.memories,
      content: {
        'targetEventId': eventId,
        'reflection': summary,
        'lessonsLearned': [],
      },
      summary: 'Reflection on activity',
      source: MemorySource.aiGenerated,
      importance: 0.4,
      reasoning: 'Automated reflection on event $eventId',
    );
    await memoryEngine.save(memory);
  }
}
