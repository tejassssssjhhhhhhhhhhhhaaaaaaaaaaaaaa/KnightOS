import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import 'memory_engine.dart';

/// Organizes memories into thematic life chapters.
class LifeChaptersEngine {
  const LifeChaptersEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Detects significant life transitions and groups memories.
  Future<List<LifeChapter>> detectChapters() async {
    final List<LifeChapter> chapters = [];

    // 1. Fetch Biography memories
    final bio = await memoryEngine.getByDomain(MemoryDomain.biography);

    // 2. Identify "Anchor" memories (Jobs, City moves, School)
    // Simplified detection for Phase 13
    for (final m in bio) {
      if (m.summary?.toLowerCase().contains('moved to') == true ||
          m.summary?.toLowerCase().contains('started at') == true) {
        chapters.add(
          LifeChapter(
            title: m.summary ?? 'New Chapter',
            startDate: m.effectiveAt,
            category: m.category,
            anchorMemoryId: m.id,
          ),
        );
      }
    }

    chapters.sort((a, b) => b.startDate.compareTo(a.startDate));
    return chapters;
  }

  /// Retrieves milestones for a specific chapter (category).
  Future<List<KnightMemory>> getChapterHistory(BookCategory category) {
    return memoryEngine.getByCategory(category);
  }

  /// Groups memories by time period (Monthly/Yearly summary).
  Future<Map<String, List<KnightMemory>>> groupChronologically() async {
    final all = await memoryEngine.search('');
    final Map<String, List<KnightMemory>> groups = {};

    for (final m in all) {
      final key =
          '${m.effectiveAt.year}-${m.effectiveAt.month.toString().padLeft(2, '0')}';
      groups.putIfAbsent(key, () => []).add(m);
    }

    return groups;
  }
}

class LifeChapter {
  const LifeChapter({
    required this.title,
    required this.startDate,
    this.endDate,
    required this.category,
    required this.anchorMemoryId,
  });

  final String title;
  final DateTime startDate;
  final DateTime? endDate;
  final BookCategory category;
  final String anchorMemoryId;
}
