import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/cognitive_models.dart';
import 'memory_engine.dart';

/// Intelligently assembles relevant context for AI reasoning.
class ContextEngine {
  const ContextEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Builds a tiered context snapshot.
  Future<List<KnightMemory>> buildActiveContext({
    String? query,
    KnightIntent? intent,
  }) async {
    final List<KnightMemory> context = [];

    // TIER 1: Identity (Who I am) - Always Included
    final identity = await memoryEngine.getByCategory(BookCategory.identity);
    context.addAll(identity);

    // TIER 2: Current Mission (What I'm doing today) - Mapped to Career/Ambitions
    final focus = await memoryEngine.getByCategory(BookCategory.career);
    context.addAll(focus);

    // TIER 3: Rules & Constraints - Mapped to Philosophy
    final rules = await memoryEngine.getByCategory(BookCategory.philosophy);
    context.addAll(rules);

    // TIER 4: Intent-Specific Data
    if (intent != null) {
      final intentData = await _fetchIntentSpecificData(intent);
      context.addAll(intentData);
    }

    // TIER 5: Recency (What happened lately) - Mapped to History
    final recent = await memoryEngine.getByCategory(BookCategory.history);
    context.addAll(recent.take(5));

    // TIER 6: Semantic Relevance (Query-based)
    if (query != null) {
      final relevant = await _searchMemories(query);
      context.addAll(relevant);
    }

    return _rankAndDeduplicate(context);
  }

  Future<List<KnightMemory>> _fetchIntentSpecificData(
    KnightIntent intent,
  ) async {
    switch (intent) {
      case KnightIntent.decision:
        return memoryEngine.getByCategory(BookCategory.philosophy);
      case KnightIntent.planning:
        return memoryEngine.getByCategory(BookCategory.ambitions);
      case KnightIntent.analysis:
        final money = await memoryEngine.getByCategory(BookCategory.finance);
        final recovery = await memoryEngine.getByCategory(BookCategory.health);
        return [...money, ...recovery];
      default:
        return [];
    }
  }

  Future<List<KnightMemory>> _searchMemories(String query) async {
    // Basic implementation: fetch all and filter by keywords in summary.
    // Future: Use Vector Database.
    return [];
  }

  List<KnightMemory> _rankAndDeduplicate(List<KnightMemory> memories) {
    final Map<String, KnightMemory> unique = {};
    for (final m in memories) {
      // Logic: Prioritize Identity and high-importance memories.
      if (!unique.containsKey(m.memoryId) ||
          m.importance > unique[m.memoryId]!.importance) {
        unique[m.memoryId] = m;
      }
    }

    final sorted = unique.values.toList()
      ..sort((a, b) => b.importance.compareTo(a.importance));

    // Limit to reasonable token window (e.g. top 25 memories)
    return sorted.take(25).toList();
  }
}
