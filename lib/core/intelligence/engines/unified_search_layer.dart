import '../domain/knight_memory.dart';
import '../domain/search_models.dart';
import 'memory_engine.dart';
import 'intent_engine.dart';

/// Semantic search cross-engine coordinator (Unified Retrieval).
class UnifiedSearchLayer {
  const UnifiedSearchLayer({
    required this.memoryEngine,
    required this.intentEngine,
  });

  final MemoryEngine memoryEngine;
  final IntentEngine intentEngine;

  /// Performs a semantic search across all life domains.
  Future<SearchCollection> search(String query) async {
    final stopwatch = Stopwatch()..start();
    
    // 1. Intent Detection
    final intent = intentEngine.detectIntent(query);

    // 2. Multi-domain lookup (SQLite keyword search for now)
    final memories = await memoryEngine.search(query);

    // 3. Normalization into SearchResults
    final results = memories.map((m) => SearchResult(
      id: m.memoryId,
      title: m.summary ?? 'Memory Unit',
      snippet: m.content.toString(),
      relevance: _calculateRelevance(m, query),
      confidence: m.confidence,
      timestamp: m.effectiveAt,
      sourceMemory: m,
    )).toList();

    // 4. Sort by relevance
    results.sort((a, b) => b.relevance.compareTo(a.relevance));

    return SearchCollection(
      query: query,
      results: results,
      suggestedIntent: intent.name,
      latencyMs: stopwatch.elapsedMilliseconds,
    );
  }

  double _calculateRelevance(KnightMemory memory, String query) {
    // Current: Simple string matching boost.
    // Future: Embedding cosine similarity.
    if ((memory.summary ?? '').toLowerCase().contains(query.toLowerCase())) {
      return 1.0;
    }
    return 0.5;
  }
}
