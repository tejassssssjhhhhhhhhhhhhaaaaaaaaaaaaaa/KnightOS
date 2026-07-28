import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/domain/models/models.dart';
import '../../../core/intelligence/domain/memory_category.dart';

final atlasEventsProvider = FutureProvider<List<TimelineEvent>>((ref) async {
  final memoryEngine = ref.watch(memoryEngineProvider);

  // Fetch all memories that are linked to questions or have timeline tags
  // For this phase, we'll fetch all from the 'History' book.
  final memories = await memoryEngine.search('');

  return memories
      .map(
        (m) => TimelineEvent(
          id: m.memoryId,
          title: m.summary ?? 'Untitled Event',
          timestamp: m.effectiveAt,
          category: _mapBookToTimeline(m.category),
          subtitle:
              m.content['answer']?.toString() ??
              m.content['subtitle']?.toString(),
          content: m.content,
          tags: m.tags,
          isHighlight: m.importance > 0.8,
        ),
      )
      .toList()
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
});

TimelineCategory _mapBookToTimeline(BookCategory category) {
  switch (category) {
    case BookCategory.health:
      return TimelineCategory.health;
    case BookCategory.finance:
      return TimelineCategory.finance;
    case BookCategory.history:
      return TimelineCategory.travel;
    case BookCategory.skills:
      return TimelineCategory.learning;
    case BookCategory.career:
      return TimelineCategory.work;
    case BookCategory.identity:
      return TimelineCategory.personal;
    case BookCategory.ambitions:
      return TimelineCategory.achievement;
    default:
      return TimelineCategory.personal;
  }
}
