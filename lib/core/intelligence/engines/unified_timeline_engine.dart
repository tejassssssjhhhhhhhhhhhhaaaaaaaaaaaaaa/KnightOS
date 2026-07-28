import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import 'memory_engine.dart';

/// Aggregates events from all sources into a single chronological life record.
class UnifiedTimelineEngine {
  const UnifiedTimelineEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Retrieves a chronological view of the user's life for a specific period.
  Future<List<KnightMemory>> getTimeline({
    required DateTime start,
    required DateTime end,
    List<BookCategory>? categories,
  }) async {
    final List<KnightMemory> timeline = [];

    // Strategy: Fetch from Memory Engine and filter by effectiveAt.
    // Optimization: Use Drift optimized date range query in DAO.

    // For foundation, we fetch categories and filter manually.
    final targetCategories =
        categories ??
        [BookCategory.history, BookCategory.identity, BookCategory.health];

    for (final category in targetCategories) {
      final memories = await memoryEngine.getByCategory(category);
      timeline.addAll(
        memories.where(
          (m) => m.effectiveAt.isAfter(start) && m.effectiveAt.isBefore(end),
        ),
      );
    }

    return timeline..sort((a, b) => b.effectiveAt.compareTo(a.effectiveAt));
  }
}
