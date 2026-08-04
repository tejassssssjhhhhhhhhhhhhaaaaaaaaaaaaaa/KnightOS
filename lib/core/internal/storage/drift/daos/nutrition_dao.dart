import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/nutrition.dart';

part 'nutrition_dao.g.dart';

@DriftAccessor(tables: [NutritionFoodTable, NutritionMealTable])
class NutritionDao extends DatabaseAccessor<KnightDatabase> with _$NutritionDaoMixin {
  NutritionDao(super.db);

  Future<List<FoodData>> searchFoods(String query) {
    return (select(nutritionFoodTable)..where((t) => t.name.contains(query))).get();
  }

  Future<List<FoodData>> getIndianFoods({String? region}) {
    final query = select(nutritionFoodTable)..where((t) => t.isIndian.equals(true));
    if (region != null) {
      query.where((t) => t.region.equals(region));
    }
    return query.get();
  }

  Future<void> logMeal(NutritionMealTableCompanion meal) =>
      into(nutritionMealTable).insert(meal);

  Future<List<MealLogData>> getRecentMeals({int limit = 10}) {
    return (select(nutritionMealTable)
          ..orderBy([(t) => OrderingTerm.desc(t.consumedAt)])
          ..limit(limit))
        .get();
  }

  Future<double> getDailyCalories(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    
    final meals = await (select(nutritionMealTable)
          ..where((t) => t.consumedAt.isBetweenValues(start, end)))
        .get();
        
    double total = 0.0;
    for (final meal in meals) {
      final food = await (select(nutritionFoodTable)..where((t) => t.id.equals(meal.foodId))).getSingle();
      total += food.calories * meal.quantity;
    }
    return total;
  }
}
