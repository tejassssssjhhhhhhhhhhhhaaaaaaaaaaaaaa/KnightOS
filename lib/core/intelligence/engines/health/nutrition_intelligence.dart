import '../../domain/health_models.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/cognitive_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';

class NutritionIntelligence {
  const NutritionIntelligence({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  Future<Map<String, dynamic>> analyzeNutrition() async {
    final memories = await retrieval.getByCategory(BookCategory.health);

    final nutritionRecords = memories
        .where((m) => m.healthDataType == HealthDataType.nutrition)
        .map((m) => m.toNutritionRecord()!)
        .toList();

    final hydrationRecords = memories
        .where((m) => m.healthDataType == HealthDataType.hydration)
        .map((m) => m.toHydrationRecord()!)
        .toList();

    if (nutritionRecords.isEmpty && hydrationRecords.isEmpty) {
      return {'status': 'No data'};
    }

    // Calculate today's totals
    final today = DateTime.now();
    final todayNutrition = nutritionRecords.where(
      (r) => r.timestamp.year == today.year && r.timestamp.day == today.day,
    );
    final todayHydration = hydrationRecords.where(
      (r) => r.timestamp.year == today.year && r.timestamp.day == today.day,
    );

    final totalCalories = todayNutrition.fold(0, (sum, r) => sum + r.calories);
    final totalProtein = todayNutrition.fold(
      0.0,
      (sum, r) => sum + r.proteinGrams,
    );
    final totalWater = todayHydration.fold(0, (sum, r) => sum + r.amountMl);
    final waterGoal = todayHydration.isNotEmpty
        ? todayHydration.first.dailyGoalMl
        : 2500;

    return {
      'todayCalories': totalCalories,
      'todayProtein': totalProtein,
      'todayWaterMl': totalWater,
      'waterGoalMl': waterGoal,
      'isHydrated': totalWater >= waterGoal,
    };
  }

  Future<List<IntelligenceResult>> getInsights() async {
    final analysis = await analyzeNutrition();
    if (analysis['status'] != null) return [];

    final List<IntelligenceResult> insights = [];
    final isHydrated = analysis['isHydrated'] as bool;
    final water = analysis['todayWaterMl'] as int;
    final goal = analysis['waterGoalMl'] as int;

    if (!isHydrated && DateTime.now().hour > 18) {
      insights.add(
        IntelligenceResult(
          id: 'insight-hydration-low',
          data:
              'Hydration is low today ($water/$goal ml). Aim for 2 more glasses before sleep.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [],
            rulesApplied: ['Daily Hydration Target'],
            goalsConsidered: ['Vitality'],
            thoughtChain: [
              'Compared daily water intake sum against user-defined goal.',
            ],
            confidence: 0.95,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'nutrition-hash',
        ),
      );
    }

    return insights;
  }
}
