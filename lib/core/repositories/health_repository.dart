import '../internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';

class HealthRepository {
  final KnightDatabase db;
  HealthRepository({required this.db});

  Future<List<WorkoutSessionData>> getRecentWorkouts({int limit = 10}) async {
    return (db.select(db.workoutSessionTable)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
  }

  Future<List<SleepSessionData>> getRecentSleep({int limit = 7}) async {
    return (db.select(db.sleepSessionTable)
          ..orderBy([(t) => OrderingTerm.desc(t.wakeTime)])
          ..limit(limit))
        .get();
  }

  Future<double> getStepsForDay(DateTime date) => db.healthDao.getDailyTotal('steps', date);

  Future<int> getWaterIntake(DateTime date) async {
    final result = await db.healthDao.getDailyTotal('WATER', date);
    return result.toInt();
  }

  Future<List<MealLogData>> getMealsForDay(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (db.select(db.nutritionMealTable)
      ..where((t) => t.consumedAt.isBetweenValues(start, end)))
      .get();
  }

  Future<List<HealthMetricData>> getMetricsForType(String type, DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (db.select(db.healthMetricTable)
      ..where((t) => t.metricType.equals(type) & t.startTime.isBetweenValues(start, end)))
      .get();
  }

  Future<void> saveWorkout(WorkoutSessionTableCompanion entry) => 
    db.into(db.workoutSessionTable).insertOnConflictUpdate(entry);

  Future<void> saveSleep(SleepSessionTableCompanion entry) => 
    db.into(db.sleepSessionTable).insertOnConflictUpdate(entry);

  // Tracker Platform Methods
  Future<void> logBodyMeasurement(BodyMeasurementTableCompanion entry) => db.healthTrackerDao.logMeasurement(entry);
  Future<void> logHealthTracker(HealthTrackerTableCompanion entry) => db.healthTrackerDao.logTracker(entry);
  Future<List<HealthTrackerData>> getTrackerHistory(String type, {int limit = 30}) => db.healthTrackerDao.getTrackerHistory(type, limit: limit);
  Future<List<BodyMeasurementData>> getMeasurementHistory(String type, {int limit = 30}) => db.healthTrackerDao.getMeasurementHistory(type, limit: limit);
  
  // Nutrition Platform Methods
  Future<List<FoodData>> searchFoods(String query) => db.nutritionDao.searchFoods(query);
  Future<void> logMeal(NutritionMealTableCompanion meal) => db.nutritionDao.logMeal(meal);
}
