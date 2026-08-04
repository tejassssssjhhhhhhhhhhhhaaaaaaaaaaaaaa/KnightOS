import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/providers/database_provider.dart';

class NutritionSyncService {
  NutritionSyncService({required this.db});
  final KnightDatabase db;

  Future<void> seedIndianFoodDatabase() async {
    final manifest = await rootBundle.loadString('assets/data/indian_foods.json');
    final List<dynamic> data = jsonDecode(manifest);

    for (final item in data) {
      await db.into(db.nutritionFoodTable).insert(
        NutritionFoodTableCompanion.insert(
          id: 'food-${item['name'].toString().toLowerCase().replaceAll(' ', '-')}',
          name: item['name'],
          calories: item['calories'].toDouble(),
          protein: item['protein'].toDouble(),
          carbs: item['carbs'].toDouble(),
          fat: item['fat'].toDouble(),
          fiber: Value(item['fiber'].toDouble()),
          isIndian: Value(true),
          region: Value(item['region']),
          tags: Value(item['tags']),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }
}

final nutritionSyncServiceProvider = Provider<NutritionSyncService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return NutritionSyncService(db: db);
});
