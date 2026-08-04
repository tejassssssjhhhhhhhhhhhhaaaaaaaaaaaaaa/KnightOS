// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_dao.dart';

// ignore_for_file: type=lint
mixin _$NutritionDaoMixin on DatabaseAccessor<KnightDatabase> {
  $NutritionFoodTableTable get nutritionFoodTable =>
      attachedDatabase.nutritionFoodTable;
  $NutritionMealTableTable get nutritionMealTable =>
      attachedDatabase.nutritionMealTable;
  NutritionDaoManager get managers => NutritionDaoManager(this);
}

class NutritionDaoManager {
  final _$NutritionDaoMixin _db;
  NutritionDaoManager(this._db);
  $$NutritionFoodTableTableTableManager get nutritionFoodTable =>
      $$NutritionFoodTableTableTableManager(
        _db.attachedDatabase,
        _db.nutritionFoodTable,
      );
  $$NutritionMealTableTableTableManager get nutritionMealTable =>
      $$NutritionMealTableTableTableManager(
        _db.attachedDatabase,
        _db.nutritionMealTable,
      );
}
