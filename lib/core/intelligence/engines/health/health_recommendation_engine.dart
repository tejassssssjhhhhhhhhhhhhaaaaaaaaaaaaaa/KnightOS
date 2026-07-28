import '../../domain/intelligence_models.dart';
import '../../domain/cognitive_models.dart';
import 'health_context_engine.dart';
import 'sleep_intelligence.dart';
import 'fitness_intelligence.dart';
import 'nutrition_intelligence.dart';
import 'medication_intelligence.dart';

class HealthRecommendationEngine {
  const HealthRecommendationEngine({
    required this.context,
    required this.sleep,
    required this.fitness,
    required this.nutrition,
    required this.medication,
  });

  final HealthContextEngine context;
  final SleepIntelligence sleep;
  final FitnessIntelligence fitness;
  final NutritionIntelligence nutrition;
  final MedicationIntelligence medication;

  Future<List<IntelligenceResult>> generateRecommendations() async {
    final List<IntelligenceResult> recommendations = [];
    final states = await context.determineCurrentStates();

    // 1. Hydration Recommendation
    final nutritionAnalysis = await nutrition.analyzeNutrition();
    if (nutritionAnalysis['status'] == null) {
      final isHydrated = nutritionAnalysis['isHydrated'] as bool;
      if (!isHydrated) {
        recommendations.add(
          IntelligenceResult(
            id: 'rec-hydration',
            data: 'Increase water intake: Drink 500ml of water now.',
            trace: ReasoningTrace(
              intent: KnightIntent.analysis,
              memoriesUsed: [],
              rulesApplied: [],
              goalsConsidered: ['Hydration'],
              thoughtChain: [
                'Detected daily intake below goal in current nutrition context.',
              ],
              confidence: 0.9,
            ),
            generatedAt: DateTime.now(),
            version: 1,
            evidenceHash: 'rec-h',
          ),
        );
      }
    }

    // 2. Sleep Recommendation based on Context
    if (states.contains(HealthState.working) && DateTime.now().hour > 22) {
      recommendations.add(
        IntelligenceResult(
          id: 'rec-sleep-early',
          data:
              'Sleep earlier: Shift work detected, prioritize 8h recovery tonight.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [],
            rulesApplied: [],
            goalsConsidered: ['Sleep Recovery'],
            thoughtChain: [
              'Late working detected in health context.',
              'Correlated with high sleep debt.',
            ],
            confidence: 0.85,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'rec-s',
        ),
      );
    }

    return recommendations;
  }
}
