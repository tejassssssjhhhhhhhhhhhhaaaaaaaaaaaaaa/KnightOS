import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';
import '../memory_engine.dart';
import '../graph/relationship_discovery_engine.dart';
import '../graph/causal_reasoning_engine.dart';
import '../graph/correlation_engine.dart';
import '../graph/prediction_engine.dart';

class KnowledgeGraphModule extends IntelligenceModule {
  KnowledgeGraphModule({required this.retrieval, required this.memoryEngine}) {
    discovery = RelationshipDiscoveryEngine(
      memoryEngine: memoryEngine,
      retrieval: retrieval,
    );
    causal = CausalReasoningEngine(memoryEngine: memoryEngine);
    correlation = CorrelationEngine(retrieval: retrieval);
    prediction = PredictionEngine(retrieval: retrieval);
  }

  final MemoryRetrievalEngine retrieval;
  final MemoryEngine memoryEngine;

  late final RelationshipDiscoveryEngine discovery;
  late final CausalReasoningEngine causal;
  late final CorrelationEngine correlation;
  late final PredictionEngine prediction;

  @override
  String get id => 'knowledge_graph';

  @override
  List<BookCategory> get inputCategories => BookCategory.values;

  @override
  double get priority => 0.95; // High priority, discovers relationships

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    if (event is DataChangedEvent) {
      // Trigger async discovery logic
      await discovery.discoverRoutines();
    }
  }

  @override
  Future<List<IntelligenceResult>> getInsights() async {
    final List<IntelligenceResult> insights = [];

    // 1. Cross-domain correlation
    final sleepProd = await correlation.correlate(
      categoryA: BookCategory.health,
      fieldA: 'durationMinutes',
      categoryB: BookCategory.career,
      fieldB: 'productivityScore',
    );

    if (sleepProd.confidence > 0.6 && sleepProd.score.abs() > 0.4) {
      insights.add(
        IntelligenceResult(
          id: 'insight-correlation-sleep-prod',
          data:
              'Detected ${sleepProd.interpretation} correlation between Sleep and Productivity.',
          trace: await causal.evaluateHypothesis(
            hypothesis: 'Sleep duration influences next-day work performance.',
            evidence: [], // Future: Add supporting memories
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'corr-123',
        ),
      );
    }

    return insights;
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async => [];

  @override
  Future<List<String>> getBriefingItems() async {
    final List<String> items = [];
    final predSpending = await prediction.predictMonthlySpending();

    if (predSpending.confidence > 0.7) {
      items.add(
        'Finance: Projected monthly spend is \$${predSpending.estimatedValue.toStringAsFixed(0)}.',
      );
    }

    return items;
  }
}
