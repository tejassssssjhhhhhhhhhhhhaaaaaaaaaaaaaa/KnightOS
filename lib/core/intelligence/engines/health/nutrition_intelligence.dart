import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../internal/storage/drift/knight_database.dart';
import '../../../providers/database_provider.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/cognitive_models.dart';

final nutritionIntelligenceProvider = Provider<NutritionIntelligence>((ref) {
  return NutritionIntelligence(
    db: ref.watch(knightDatabaseProvider),
  );
});

class NutritionIntelligence {
  final KnightDatabase db;

  NutritionIntelligence({required this.db});

  Future<List<FoodData>> searchFood(String query) async {
    return (db.select(db.nutritionFoodTable)
          ..where((t) => t.name.like('%$query%')))
        .get();
  }

  Future<void> logMeal({
    required String foodId,
    required String mealType,
    required double quantity,
    DateTime? consumedAt,
    String? notes,
  }) async {
    await db.into(db.nutritionMealTable).insert(
      NutritionMealTableCompanion.insert(
        id: 'meal-${DateTime.now().millisecondsSinceEpoch}',
        foodId: foodId,
        mealType: mealType,
        quantity: quantity,
        consumedAt: Value(consumedAt ?? DateTime.now()),
        notes: Value(notes),
      ),
    );
  }

  Future<List<MealLogData>> getMealTimeline(DateTime day) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (db.select(db.nutritionMealTable)
          ..where((t) => t.consumedAt.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(t) => OrderingTerm.asc(t.consumedAt)]))
        .get();
  }

  Future<Map<String, dynamic>> analyzeNutrition() async {
    final now = DateTime.now();
    final todayMeals = await getMealTimeline(now);

    if (todayMeals.isEmpty) return {'status': 'No data'};

    // Dummy calculation for now
    double totalCalories = 0;
    for (final meal in todayMeals) {
      totalCalories += 200 * meal.quantity; // simplified
    }

    return {
      'totalCalories': totalCalories,
      'isHydrated': true, // Placeholder
      'adherence': 0.8,
    };
  }

  Future<List<IntelligenceResult>> getInsights() async {
    final analysis = await analyzeNutrition();
    if (analysis['status'] != null) return [];

    return [
      IntelligenceResult(
        id: 'insight-nutrition-calories',
        data: 'Daily calorie intake is trending normally.',
        trace: ReasoningTrace(
          intent: KnightIntent.analysis,
          memoriesUsed: [],
          rulesApplied: [],
          goalsConsidered: ['Nutrition'],
          thoughtChain: ['Analyzed today\'s food logs.'],
          confidence: 0.7,
        ),
        generatedAt: DateTime.now(),
        version: 1,
        evidenceHash: 'nutrition-hash',
      ),
    ];
  }

  /// Seeds the database with some initial Indian food data, including Bihar cuisine.
  Future<void> seedIndianFoodDatabase() async {
    final foods = [
      _createFood('Litti Chokha', 250, 8, 45, 12, region: 'Bihar', isIndian: true),
      _createFood('Sattu Paratha', 300, 12, 50, 10, region: 'Bihar', isIndian: true),
      _createFood('Dal Bhat', 350, 15, 60, 5, isIndian: true),
      _createFood('Paneer Tikka', 200, 18, 5, 15, isIndian: true),
      _createFood('Masala Dosa', 350, 6, 60, 12, isIndian: true),
      _createFood('Thekua', 150, 2, 25, 6, region: 'Bihar', isIndian: true),
      _createFood('Chicken Curry', 400, 30, 10, 25, isIndian: true),
      _createFood('Roti', 80, 3, 15, 1, isIndian: true),
    ];

    for (final food in foods) {
      await db.into(db.nutritionFoodTable).insertOnConflictUpdate(food);
    }
  }

  NutritionFoodTableCompanion _createFood(
    String name,
    double calories,
    double protein,
    double carbs,
    double fat, {
    String? region,
    bool isIndian = false,
  }) {
    return NutritionFoodTableCompanion.insert(
      id: name.toLowerCase().replaceAll(' ', '_'),
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      region: Value(region),
      isIndian: Value(isIndian),
    );
  }
}
