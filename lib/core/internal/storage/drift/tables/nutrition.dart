import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('FoodData')
class NutritionFoodTable extends KnightTable {
  @override
  String get tableName => 'nutrition_foods';

  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  
  RealColumn get calories => real()(); // per 100g or per serving
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  RealColumn get fiber => real().withDefault(const Constant(0.0))();
  
  TextColumn get servingUnit => text().withDefault(const Constant('serving'))();
  RealColumn get servingSize => real().withDefault(const Constant(1.0))();

  BoolColumn get isIndian => boolean().withDefault(const Constant(false))();
  TextColumn get region => text().nullable()(); // Bihar, Punjab, etc.
  
  TextColumn get tags => text().nullable()(); // comma-separated: breakfast, snack, etc.
}

@DataClassName('MealLogData')
class NutritionMealTable extends KnightTable {
  @override
  String get tableName => 'nutrition_meals';

  TextColumn get foodId => text().references(NutritionFoodTable, #id)();
  
  /// breakfast, lunch, dinner, snack
  TextColumn get mealType => text()();
  
  RealColumn get quantity => real()(); // Number of servings or grams
  
  DateTimeColumn get consumedAt => dateTime().withDefault(currentDateAndTime)();
  
  TextColumn get notes => text().nullable()();
}
