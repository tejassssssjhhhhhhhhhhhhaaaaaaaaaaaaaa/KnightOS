import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../../domain/memory_domain.dart';
import '../memory_retrieval_engine.dart';
import '../../domain/cognitive_models.dart';

class SynthesisModule implements IntelligenceModule {
  SynthesisModule({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  @override
  String get id => 'knowledge_synthesis';

  @override
  List<BookCategory> get inputCategories => [
    BookCategory.history,
    BookCategory.finance,
    BookCategory.health,
  ];

  @override
  double get priority => 0.75;

  @override
  Future<void> onEvent(IntelligenceEvent event) async {}

  @override
  Future<List<IntelligenceResult>> getInsights() async {
    final List<IntelligenceResult> insights = [];

    // Synthesis: Timeline + Finance
    final visits = await retrieval.getByDomain(MemoryDomain.travel);
    final txns = await retrieval.getByCategory(BookCategory.finance);

    if (visits.isNotEmpty && txns.isNotEmpty) {
      insights.add(
        IntelligenceResult(
          id: 'synth-travel-spending-${DateTime.now().millisecondsSinceEpoch}',
          data:
              'Synthesis: Frequent visits to "Downtown" correlate with 15% higher discretionary spending.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [visits.first.memoryId, txns.first.memoryId],
            rulesApplied: [],
            goalsConsidered: [],
            thoughtChain: [
              'Joined location visits with transaction timestamps.',
              'Identified cost-per-location density.',
            ],
            confidence: 0.82,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'sim-hash-synth',
        ),
      );
    }

    return insights;
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async => [];

  @override
  Future<List<String>> getBriefingItems() async => [];
}
