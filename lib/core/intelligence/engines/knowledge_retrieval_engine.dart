import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../services/embedding_service.dart';
import 'memory_retrieval_engine.dart';
import 'memory_engine.dart';

/// Implements Hybrid Retrieval (Exact + Semantic) for KnightOS.
class KnowledgeRetrievalEngine {
  const KnowledgeRetrievalEngine({
    required this.retrieval,
    required this.memoryEngine,
    required this.embeddingService,
  });

  final MemoryRetrievalEngine retrieval;
  final MemoryEngine memoryEngine;
  final EmbeddingService embeddingService;

  /// Performs a hybrid search across the memory store.
  Future<List<SearchResult>> hybridSearch(
    String query, {
    int limit = 10,
    double semanticWeight = 0.7,
    double recencyWeight = 0.1,
    double confidenceWeight = 0.2,
  }) async {
    // 1. Exact/Keyword Search
    final exactMatches = await memoryEngine.search(query);

    // 2. Semantic Search
    final queryEmbedding = await _getQueryEmbedding(query);
    final allMemories = await memoryEngine.search(
      '',
    ); // Load all for local semantic scan

    final List<SearchResult> results = [];

    for (final memory in allMemories) {
      double semanticScore = 0.0;
      if (memory.embedding != null) {
        semanticScore = EmbeddingService.calculateSimilarity(
          queryEmbedding,
          memory.embedding!,
        );
      }

      final bool isExact = exactMatches.any((m) => m.id == memory.id);
      final double exactScore = isExact ? 1.0 : 0.0;

      // Recency Score (Decay)
      final ageDays = DateTime.now().difference(memory.effectiveAt).inDays;
      final double recencyScore = ageDays == 0 ? 1.0 : (1.0 / (ageDays + 1));

      // Confidence Score
      final double confScore = memory.confidence;

      // Combined Score
      final double combinedScore =
          (semanticScore * semanticWeight) +
          (exactScore * (1.0 - semanticWeight)) +
          (recencyScore * recencyWeight) +
          (confScore * confidenceWeight);

      if (combinedScore > 0.1) {
        results.add(
          SearchResult(
            memory: memory,
            score: combinedScore,
            isExact: isExact,
            semanticSimilarity: semanticScore,
          ),
        );
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(limit).toList();
  }

  Future<List<double>> _getQueryEmbedding(String query) async {
    // We create a temporary memory to use the embedding service extraction logic
    final tempMemory = KnightMemory.create(
      memoryId: 'query',
      category: BookCategory.unknown,
      domain: MemoryDomain.unknowns,
      source: MemorySource.manual,
      content: {'query': query},
      summary: query,
    );
    final embedded = await embeddingService.embed(tempMemory);
    return embedded.embedding!;
  }
}

class SearchResult {
  const SearchResult({
    required this.memory,
    required this.score,
    required this.isExact,
    required this.semanticSimilarity,
  });

  final KnightMemory memory;
  final double score;
  final bool isExact;
  final double semanticSimilarity;
}
