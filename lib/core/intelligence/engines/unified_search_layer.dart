import '../domain/knight_memory.dart';
import 'memory_engine.dart';

/// Semantic search cross-engine coordinator.
class UnifiedSearchLayer {
  const UnifiedSearchLayer({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Performs a search across memories, files, and conversations.
  Future<List<SearchResult>> search(String query) async {
    final results = await memoryEngine.search(query);
    return results
        .map(
          (m) => SearchResult(
            memory: m,
            relevance: 1.0, // Simplistic relevance
            confidence: m.confidence,
          ),
        )
        .toList();
  }
}

class SearchResult {
  const SearchResult({
    required this.memory,
    required this.relevance,
    required this.confidence,
  });

  final KnightMemory memory;
  final double relevance;
  final double confidence;
}
