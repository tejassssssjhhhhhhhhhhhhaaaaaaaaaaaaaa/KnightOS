import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/providers/database_provider.dart';

class WorkoutOrchestrator {
  WorkoutOrchestrator({required this.db});
  final KnightDatabase db;

  Future<void> seedExerciseLibrary() async {
    final exercises = [
      {'name': 'Push Ups', 'category': 'Strength', 'muscles': 'Chest, Triceps'},
      {'name': 'Squats', 'category': 'Strength', 'muscles': 'Quads, Glutes'},
      {'name': 'Plank', 'category': 'Core', 'muscles': 'Abs'},
      {'name': 'Running', 'category': 'Cardio', 'muscles': 'Full Body'},
    ];

    for (final ex in exercises) {
      await db.into(db.exerciseLibraryTable).insert(
        ExerciseLibraryTableCompanion.insert(
          id: 'ex-${ex['name']!.toLowerCase().replaceAll(' ', '-')}',
          name: ex['name']!,
          category: ex['category']!,
          targetMuscles: Value(ex['muscles']),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<void> logWorkoutSession({
    required String type,
    required double duration,
    double? calories,
    String? notes,
  }) async {
    await db.workoutFoundationDao.logWorkout(
      WorkoutSessionTableCompanion.insert(
        id: 'ws-${DateTime.now().millisecondsSinceEpoch}',
        workoutType: type,
        durationMinutes: Value(duration),
        caloriesBurned: Value(calories),
        notes: Value(notes),
        startTime: DateTime.now(),
      ),
    );
  }

  Future<List<WorkoutSessionData>> getRecentWorkouts({int limit = 10}) {
    return db.workoutFoundationDao.getRecentWorkouts(limit: limit);
  }

  Future<Map<String, double>> calculateProgressiveOverload(String exerciseId) async {
    return {'volume_increase': 0.05, 'intensity_gain': 0.02};
  }

  Future<void> suggestNextWorkout() async {
    // Analysis of last 3 days of activity
  }

  Future<void> recordPR(String exerciseId, double weight, int reps) async {
    // Record in goal/milestone system
  }
}

final workoutOrchestratorProvider = Provider<WorkoutOrchestrator>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return WorkoutOrchestrator(db: db);
});
