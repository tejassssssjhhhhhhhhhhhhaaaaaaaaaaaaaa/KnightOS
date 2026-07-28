import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../../domain/knight_memory.dart';
import '../memory_retrieval_engine.dart';
import '../memory_engine.dart';
import '../knowledge_retrieval_engine.dart';
import '../../services/embedding_service.dart';
import '../knowledge_synthesis_engine.dart';
import '../../../internal/utils/knight_logger.dart';

class KnowledgeModule implements IntelligenceModule {
  KnowledgeModule({
    required this.retrieval,
    required this.memoryEngine,
    required this.embeddingService,
  }) {
    searchEngine = KnowledgeRetrievalEngine(
      retrieval: retrieval,
      memoryEngine: memoryEngine,
      embeddingService: embeddingService,
    );
    synthesisEngine = KnowledgeSynthesisEngine(retrieval: retrieval);
  }

  final MemoryRetrievalEngine retrieval;
  final MemoryEngine memoryEngine;
  final EmbeddingService embeddingService;

  late final KnowledgeRetrievalEngine searchEngine;
  late final KnowledgeSynthesisEngine synthesisEngine;

  @override
  String get id => 'knowledge_intelligence';

  @override
  List<BookCategory> get inputCategories => BookCategory.values;

  @override
  double get priority => 1.0; // Highest priority, provides semantic substrate for all

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    if (event is DataChangedEvent) {
      // Process new memories: Generate embeddings
      for (final memory in event.memories) {
        if (memory.embedding == null) {
          await _processMemory(memory);
        }
      }
    }
  }

  Future<void> _processMemory(KnightMemory memory) async {
    try {
      KnightLogger.info(
        'Generating semantic embedding for memory: ${memory.memoryId}',
        category: KnightLogCategory.intelligence,
      );

      final embeddedMemory = await embeddingService.embed(memory);

      // Save back to engine (this will trigger another DataChangedEvent,
      // but the embedding check will prevent a loop)
      await memoryEngine.save(embeddedMemory);
    } catch (e) {
      KnightLogger.error(
        'Failed to generate embedding for memory ${memory.id}: $e',
      );
    }
  }

  @override
  Future<List<IntelligenceResult>> getInsights() async {
    final List<IntelligenceResult> insights = [];

    // Background Cluster Detection (Simulated for Phase 11)
    final all = await retrieval.getByCategory(BookCategory.history);
    if (all.length > 5) {
      // Logic to find clusters would go here
    }

    return insights;
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async => [];

  @override
  Future<List<String>> getBriefingItems() async => [];
}
