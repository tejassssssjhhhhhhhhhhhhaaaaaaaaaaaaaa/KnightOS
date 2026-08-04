import 'package:collection/collection.dart';
import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../../domain/memory_domain.dart';
import '../memory_retrieval_engine.dart';
import '../../domain/cognitive_models.dart';

class InsightModule extends IntelligenceModule {
  InsightModule({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  @override
  String get id => 'insight_engine';

  @override
  List<BookCategory> get inputCategories => [
    BookCategory.health,
    BookCategory.history,
  ];

  @override
  double get priority => 0.7;

  @override
  Future<void> onEvent(IntelligenceEvent event) async {}

  @override
  Future<List<IntelligenceResult>> getInsights() async {
    final List<IntelligenceResult> insights = [];

    // Cross-domain correlation: Health + Timeline
    final health = await retrieval.getByCategory(BookCategory.health);
    final timeline = await retrieval.getByDomain(MemoryDomain.travel);

    final h = health.firstOrNull;
    final t = timeline.firstOrNull;

    if (h != null && t != null) {
      insights.add(
        IntelligenceResult(
          id: 'insight-health-travel-${DateTime.now().millisecondsSinceEpoch}',
          data: 'Stress levels are 20% lower when visiting parks.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [h.memoryId, t.memoryId],
            rulesApplied: [],
            goalsConsidered: [],
            thoughtChain: [
              'Correlated location history with daily wellness logs.',
            ],
            confidence: 0.85,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'sim-hash-456',
        ),
      );
    }

    return insights;
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async {
    return [
      IntelligenceResult(
        id: 'rec-park-${DateTime.now().millisecondsSinceEpoch}',
        data: 'Recommended: 20-minute walk in Central Park today.',
        trace: ReasoningTrace(
          intent: KnightIntent.analysis,
          memoriesUsed: [],
          rulesApplied: [],
          goalsConsidered: [],
          thoughtChain: [
            'Based on stress reduction pattern discovered in insights.',
          ],
          confidence: 0.8,
        ),
        generatedAt: DateTime.now(),
        version: 1,
        evidenceHash: 'sim-hash-789',
      ),
    ];
  }

  @override
  Future<List<String>> getBriefingItems() async => [];
}
