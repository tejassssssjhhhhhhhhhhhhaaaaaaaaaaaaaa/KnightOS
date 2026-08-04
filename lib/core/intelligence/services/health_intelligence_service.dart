import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../providers/database_provider.dart';

class HealthIntelligenceService {
  HealthIntelligenceService({required this.db});
  final KnightDatabase db;

  Future<HealthDashboardData> getDashboardData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final steps = (await db.healthDao.getDailyTotal('steps', today)).toInt();
    final calories = (await db.healthDao.getDailyTotal('calories', today)).toInt();
    final water = (await db.healthDao.getDailyTotal('water', today)).toDouble();
    
    final nutritionCals = await db.nutritionDao.getDailyCalories(today);

    return HealthDashboardData(
      dailyScore: _calculateDailyScore(steps, nutritionCals, water),
      recoveryScore: 82, // Placeholder
      sleepScore: 75,    // Placeholder
      stressScore: 40,   // Placeholder
      hydrationScore: (water / 2000 * 100).clamp(0, 100).toInt(),
      nutritionScore: 68, // Placeholder
      workoutScore: 90,   // Placeholder
      readinessScore: 85, // Placeholder
      steps: steps,
      calories: calories,
      waterMl: water.toInt(),
      nutritionCalories: nutritionCals.toInt(),
    );
  }

  int _calculateDailyScore(int steps, double nutritionCals, double water) {
    // Simple heuristic for foundation
    double score = 0;
    score += (steps / 10000 * 40).clamp(0, 40);
    score += (water / 2000 * 20).clamp(0, 20);
    score += (nutritionCals > 0 && nutritionCals < 2500 ? 40 : 10);
    return score.toInt();
  }
}

class HealthDashboardData {
  final int dailyScore;
  final int recoveryScore;
  final int sleepScore;
  final int stressScore;
  final int hydrationScore;
  final int nutritionScore;
  final int workoutScore;
  final int readinessScore;
  final int steps;
  final int calories;
  final int waterMl;
  final int nutritionCalories;

  HealthDashboardData({
    required this.dailyScore,
    required this.recoveryScore,
    required this.sleepScore,
    required this.stressScore,
    required this.hydrationScore,
    required this.nutritionScore,
    required this.workoutScore,
    required this.readinessScore,
    required this.steps,
    required this.calories,
    required this.waterMl,
    required this.nutritionCalories,
  });
}

final healthIntelligenceServiceProvider = Provider<HealthIntelligenceService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return HealthIntelligenceService(db: db);
});
