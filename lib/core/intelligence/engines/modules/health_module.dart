import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';
import '../health/health_context_engine.dart';
import '../health/sleep_intelligence.dart';
import '../health/fitness_intelligence.dart';
import '../health/nutrition_intelligence.dart';
import '../health/medication_intelligence.dart';
import '../health/health_insight_engine.dart';
import '../health/health_recommendation_engine.dart';

class HealthModule implements IntelligenceModule {
  HealthModule({required this.retrieval})
    : context = HealthContextEngine(retrieval: retrieval),
      sleep = SleepIntelligence(retrieval: retrieval),
      fitness = FitnessIntelligence(retrieval: retrieval),
      nutrition = NutritionIntelligence(retrieval: retrieval),
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
  }

  final MemoryRetrievalEngine retrieval;
  final HealthContextEngine context;
  final SleepIntelligence sleep;
  final FitnessIntelligence fitness;
  final NutritionIntelligence nutrition;
  final MedicationIntelligence medication;

  late final HealthInsightEngine insightEngine;
  late final HealthRecommendationEngine recommendationEngine;

  @override
  String get id => 'health_intelligence';

  @override
  List<BookCategory> get inputCategories => [BookCategory.health];

  @override
  double get priority => 0.9;

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    if (event is DataChangedEvent) {
      final hasHealthChanges = event.memories.any(
        (m) => m.category == BookCategory.health,
      );
      if (hasHealthChanges) {
        // Trigger re-analysis if needed (caches are handled by Orchestrator)
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
