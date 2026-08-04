import 'package:collection/collection.dart';
import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';
import '../../domain/cognitive_models.dart';

class RecommendationModule extends IntelligenceModule {
  RecommendationModule({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  @override
  String get id => 'recommendation_engine';

  @override
  List<BookCategory> get inputCategories => [
    BookCategory.health,
    BookCategory.career,
  ];

  @override
  double get priority => 0.65;

  @override
  Future<void> onEvent(IntelligenceEvent event) async {}

  @override
  Future<List<IntelligenceResult>> getInsights() async => [];

  @override
  Future<List<IntelligenceResult>> getRecommendations() async {
    final List<IntelligenceResult> recs = [];

    // Example: Preparation for work shift
    final history = await retrieval.getByCategory(BookCategory.history);
    final firstHistory = history.firstOrNull;
    if (firstHistory != null) {
      recs.add(
        IntelligenceResult(
          id: 'rec-work-prep-${DateTime.now().millisecondsSinceEpoch}',
          data:
              'Recommendation: Prepare for tomorrow\'s shift. Historical data shows higher performance when routine starts 15m earlier.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [firstHistory.memoryId],
            rulesApplied: [],
            goalsConsidered: [],
            thoughtChain: [
              'Analyzed work start times and productivity indicators.',
            ],
            confidence: 0.78,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'sim-hash-rec',
        ),
      );
    }

    return recs;
  }

  @override
  Future<List<String>> getBriefingItems() async => [];
}
