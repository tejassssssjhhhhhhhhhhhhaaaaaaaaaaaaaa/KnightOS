import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import '../memory_retrieval_engine.dart';
import '../health/health_context_engine.dart';
import '../health/sleep_intelligence.dart';
import '../health/fitness_intelligence.dart';
import '../health/nutrition_intelligence.dart';
import '../health/medication_intelligence.dart';
import '../health/health_insight_engine.dart';
import '../health/health_recommendation_engine.dart';
import '../health/health_engine.dart';
import '../../../platform/engine/scoring_interfaces.dart';
import '../../../platform/engine/scoring_models.dart';
import '../../../platform/engine/recommendation_interfaces.dart';
import '../../../platform/engine/recommendation_models.dart';
import '../../../platform/engine/analytics_interfaces.dart';
import '../../../platform/engine/analytics_models.dart';
import '../../services/knowledge_graph_service.dart';
import '../../../repositories/health_repository.dart';
import '../verification_engine.dart';

class HealthModule extends IntelligenceModule {
  HealthModule({
    required this.retrieval, 
    required this.db,
    required KnowledgeGraphService graphService,
    required VerificationEngine verificationEngine,
  }) : context = HealthContextEngine(retrieval: retrieval),
      sleep = SleepIntelligence(retrieval: retrieval),
      fitness = FitnessIntelligence(retrieval: retrieval),
      nutrition = NutritionIntelligence(db: db),
      medication = MedicationIntelligence(retrieval: retrieval) {
    insightEngine = HealthInsightEngine(
      sleep: sleep,
      fitness: fitness,
      nutrition: nutrition,
      medication: medication,
    );
    recommendationEngine = HealthRecommendationEngine(
      context: context,
      sleep: sleep,
      fitness: fitness,
      nutrition: nutrition,
      medication: medication,
    );
    healthEngine = HealthEngine(
      repository: HealthRepository(db: db),
      contextEngine: context,
      graphService: graphService,
      verificationEngine: verificationEngine,
    );
  }

  final MemoryRetrievalEngine retrieval;
  final KnightDatabase db;
  final HealthContextEngine context;
  final SleepIntelligence sleep;
  final FitnessIntelligence fitness;
  final NutritionIntelligence nutrition;
  final MedicationIntelligence medication;

  late final HealthInsightEngine insightEngine;
  late final HealthRecommendationEngine recommendationEngine;
  late final HealthEngine healthEngine;

  @override
  String get id => 'health_intelligence';

  @override
  List<BookCategory> get inputCategories => [BookCategory.health];

  @override
  double get priority => 0.9;

  @override
  KnightScoreProvider? get scoreProvider => _HealthScoreProvider(healthEngine);

  @override
  KnightRecommendationProvider? get recommendationProvider => _HealthRecommendationProvider(recommendationEngine);

  @override
  KnightAnalyticsProvider? get analyticsProvider => _HealthAnalyticsProvider(id, db);

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    if (event is DataChangedEvent) {
      final hasHealthChanges = event.memories.any(
        (m) => m.category == BookCategory.health,
      );
      if (hasHealthChanges) {
        // Trigger re-analysis if needed
      }
    }
  }

  @override
  Future<List<IntelligenceResult>> getInsights() async {
    return insightEngine.generateInsights();
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async {
    return recommendationEngine.generateRecommendations();
  }

  @override
  Future<List<String>> getBriefingItems() async {
    final List<String> items = [];
    final states = await context.determineCurrentStates();

    if (states.contains(HealthState.hydrated)) {
      items.add('Hydration: Goal reached for today.');
    }

    final fitnessAnalysis = await fitness.analyzeFitness();
    if (fitnessAnalysis['streak'] != null &&
        (fitnessAnalysis['streak'] as int) > 0) {
      items.add('Fitness: ${fitnessAnalysis['streak']}-day streak active.');
    }

    return items;
  }
}

class _HealthScoreProvider implements KnightScoreProvider {
  _HealthScoreProvider(this.engine);
  final HealthEngine engine;

  @override
  String get id => 'health_score_provider';
  @override
  String get name => 'Health Score';
  @override
  KnightScoreCategory get category => KnightScoreCategory.health;

  @override
  Future<KnightScoreValue> requestScore() async {
    final scores = await engine.calculateCurrentScores();
    return KnightScoreValue(
      value: scores.dailyScore.score.toDouble(),
      category: category,
      grade: _calculateGrade(scores.dailyScore.score.toDouble()),
      confidence: KnightScoreConfidence(value: scores.dailyScore.trace.confidence),
      timestamp: DateTime.now(),
      source: const KnightScoreSource(name: 'Health Engine'),
    );
  }

  KnightScoreGrade _calculateGrade(double value) {
    if (value >= 85) return const KnightScoreGrade(label: 'Optimal', rank: 5);
    if (value >= 70) return const KnightScoreGrade(label: 'Good', rank: 3);
    return const KnightScoreGrade(label: 'Fair', rank: 2);
  }
}

class _HealthRecommendationProvider implements KnightRecommendationProvider {
  _HealthRecommendationProvider(this.engine);
  final HealthRecommendationEngine engine;

  @override
  String get id => 'health_recommendation_provider';
  @override
  String get name => 'Health Recommendations';
  @override
  String get moduleId => 'health_intelligence';

  @override
  Future<List<KnightRecommendation>> requestRecommendations({
    required List<KnightScoreValue> scores,
    required List<KnightAnalyticsSnapshot> analytics,
  }) async {
    final results = await engine.generateRecommendations();
    return results.map((r) => KnightRecommendation(
      id: r.id,
      title: r.data.toString(),
      description: r.trace.thoughtChain.join(' '),
      category: KnightRecommendationCategory.health,
      priority: KnightRecommendationPriority.medium,
      confidence: KnightRecommendationConfidence(value: r.trace.confidence),
      reason: KnightRecommendationReason(summary: r.trace.thoughtChain.firstOrNull ?? 'Contextual health analysis'),
      source: const KnightRecommendationSource(name: 'Health Intelligence'),
      action: const KnightRecommendationAction(label: 'View Details'),
      timestamp: r.generatedAt,
    )).toList();
  }
}

class _HealthAnalyticsProvider implements KnightAnalyticsProvider {
  _HealthAnalyticsProvider(this.moduleId, this.db);
  @override
  final String moduleId;
  final KnightDatabase db;

  @override
  String get id => 'health_analytics_provider';
  @override
  String get name => 'Health Analytics';

  @override
  Future<List<KnightHistoricalDataPoint>> requestHistoricalData() async {
    final now = DateTime.now();
    final List<KnightHistoricalDataPoint> points = [];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final steps = await db.healthDao.getDailyTotal('steps', date);
      points.add(KnightHistoricalDataPoint(timestamp: date, value: steps));
    }
    return points;
  }

  @override
  Future<List<KnightMetric>> requestMetrics() async {
    final now = DateTime.now();
    final steps = await db.healthDao.getDailyTotal('steps', now);
    return [
      KnightMetric(name: 'Daily Steps', value: steps, timestamp: now, unit: 'steps'),
    ];
  }

  @override
  Future<List<KnightScoreValue>> requestScoreHistory() async {
    return []; 
  }
}
