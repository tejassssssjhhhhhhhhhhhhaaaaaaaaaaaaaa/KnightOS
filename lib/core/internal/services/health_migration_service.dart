import 'package:drift/drift.dart';
import '../storage/drift/knight_database.dart';
import '../../storage/local_database.dart';
import '../../storage/storage_keys.dart';
import '../../../../features/fitness/domain/workout_session.dart';
import '../../../../features/sleep/domain/sleep_session.dart';
import '../utils/knight_logger.dart';

class HealthMigrationService {
  final KnightDatabase db;
  HealthMigrationService({required this.db});

  Future<void> runMigration() async {
    const legacyDb = LocalDatabase();
    
    // 1. Migrate Fitness
    final fitnessJson = await legacyDb.readJsonList(StorageKeys.fitnessSessions);
    if (fitnessJson != null) {
      KnightLogger.info('Migrating ${fitnessJson.length} workout sessions...');
      for (final item in fitnessJson) {
        final workout = WorkoutSession.fromJson(item as Map<String, dynamic>);
        await db.into(db.workoutSessionTable).insertOnConflictUpdate(WorkoutSessionTableCompanion.insert(
          id: workout.id,
          workoutType: workout.workoutType,
          durationMinutes: workout.duration.toDouble(),
          caloriesBurned: Value(workout.caloriesBurned.toDouble()),
          notes: Value(workout.notes),
          startTime: DateTime.tryParse(workout.workoutDate) ?? DateTime.now(),
        ));
      }
    }

    // 2. Migrate Sleep
    final sleepJson = await legacyDb.readJsonList(StorageKeys.sleepSessions);
    if (sleepJson != null) {
      KnightLogger.info('Migrating ${sleepJson.length} sleep sessions...');
      for (final item in sleepJson) {
        final sleep = SleepSession.fromJson(item as Map<String, dynamic>);
        await db.into(db.sleepSessionTable).insertOnConflictUpdate(SleepSessionTableCompanion.insert(
          id: sleep.id,
          bedTime: DateTime.tryParse(sleep.bedTime) ?? DateTime.now(),
          wakeTime: DateTime.tryParse(sleep.wakeTime) ?? DateTime.now(),
          sleepQuality: Value(sleep.sleepQuality),
          wakeUps: Value(sleep.wakeUps),
          moodAfterWaking: Value(sleep.moodAfterWaking),
          notes: Value(sleep.notes),
        ));
      }
    }
  }
}
