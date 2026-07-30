import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/cognitive_models.dart';
import '../domain/world_models.dart';
import '../domain/memory_domain.dart';
import '../../internal/utils/knight_logger.dart';
import 'memory_engine.dart';

/// Intelligently assembles relevant context for AI reasoning.
class ContextEngine {
  const ContextEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Builds a tiered context snapshot.
  Future<List<KnightMemory>> buildActiveContext({
    String? query,
    KnightIntent? intent,
    WorldState? worldState,
  }) async {
    KnightLogger.info('[CONTEXT] Building active context...', category: KnightLogCategory.intelligence);
    final List<KnightMemory> context = [];

    // TIER 0: External Context (Real-world state) - Sprint 5.1
    if (worldState != null) {
      context.addAll(_normalizeWorldState(worldState));
    }

    // TIER 1: Identity (Who I am) - Always Included
    KnightLogger.info('[CONTEXT] Loading identity...', category: KnightLogCategory.intelligence);
    final identity = await memoryEngine.getByCategory(BookCategory.identity);
    context.addAll(identity);

    // TIER 2: Current Mission (What I'm doing today) - Mapped to Career/Ambitions
    KnightLogger.info('[CONTEXT] Loading focus...', category: KnightLogCategory.intelligence);
    final focus = await memoryEngine.getByCategory(BookCategory.career);
    context.addAll(focus);

    // TIER 3: Rules & Constraints - Mapped to Philosophy
    KnightLogger.info('[CONTEXT] Loading rules...', category: KnightLogCategory.intelligence);
    final rules = await memoryEngine.getByCategory(BookCategory.philosophy);
    context.addAll(rules);

    // TIER 4: Intent-Specific Data
    if (intent != null) {
      KnightLogger.info('[CONTEXT] Loading intent data: $intent', category: KnightLogCategory.intelligence);
      final intentData = await _fetchIntentSpecificData(intent);
      context.addAll(intentData);
    }

    // TIER 5: Recency (What happened lately) - Mapped to History
    KnightLogger.info('[CONTEXT] Loading recent...', category: KnightLogCategory.intelligence);
    final recent = await memoryEngine.getByCategory(BookCategory.history);
    context.addAll(recent.take(5));

    // TIER 6: Semantic Relevance (Query-based)
    if (query != null) {
      final relevant = await _searchMemories(query);
      context.addAll(relevant);
    }

    final result = _rankAndDeduplicate(context);
    KnightLogger.info('[CONTEXT] Context built: ${result.length} items', category: KnightLogCategory.intelligence);
    return result;
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

  List<KnightMemory> _normalizeWorldState(WorldState state) {
    final List<KnightMemory> memories = [];

    for (final event in state.calendarEvents) {
      memories.add(
        KnightMemory.create(
          memoryId: 'ctx-cal-${event.id}',
          category: BookCategory.history,
          domain: MemoryDomain.memories,
          source: MemorySource.imported,
          content: event.toJson(),
          summary: 'Upcoming Calendar Event: ${event.title}',
          importance: 0.8,
          provenance: 'google-calendar',
        ),
      );
    }

    for (final thread in state.emailThreads) {
      if (!thread.isUnread) continue;
      memories.add(
        KnightMemory.create(
          memoryId: 'ctx-mail-${thread.id}',
          category: BookCategory.social,
          domain: MemoryDomain.memories,
          source: MemorySource.imported,
          content: thread.toJson(),
          summary: 'Unread Email: ${thread.subject} from ${thread.sender}',
          importance: 0.6,
          provenance: 'google-email',
        ),
      );
    }

    return memories;
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
