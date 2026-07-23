import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/features/fitness/domain/workout_session.dart';

void main() {
  group('Fitness workout metrics', () {
    test('calculates weekly and monthly workout summaries', () {
      final sessions = [
        WorkoutSession(
          id: '1',
          workoutDate: '2026-07-20',
          workoutType: 'Strength',
          duration: 45,
          caloriesBurned: 320,
          weight: 70,
          sets: 3,
          reps: 12,
          distance: 0,
          bodyWeight: 70,
          moodBeforeWorkout: 'Energized',
          energyAfterWorkout: 'High',
          notes: 'Upper body',
        ),
        WorkoutSession(
          id: '2',
          workoutDate: '2026-07-22',
          workoutType: 'Running',
          duration: 30,
          caloriesBurned: 250,
          weight: 70,
          sets: 0,
          reps: 0,
          distance: 5,
          bodyWeight: 69.5,
          moodBeforeWorkout: 'Focused',
          energyAfterWorkout: 'Medium',
          notes: 'Morning run',
        ),
      ];

      final metrics = WorkoutSessionMetrics.fromSessions(sessions);

      expect(metrics.weeklyWorkouts, 2);
      expect(metrics.monthlyWorkouts, 2);
      expect(metrics.totalWorkoutTime, 75);
      expect(metrics.totalCaloriesBurned, 570);
      expect(metrics.averageWorkoutDuration, 37.5);
      expect(metrics.longestWorkout, 45);
      expect(metrics.workoutStreak, 1);
    });

    test('serializes and restores a workout session', () {
      const session = WorkoutSession(
        id: 'abc',
        workoutDate: '2026-07-23',
        workoutType: 'Yoga',
        duration: 40,
        caloriesBurned: 180,
        weight: 69,
        sets: 2,
        reps: 10,
        distance: 0,
        bodyWeight: 68.5,
        moodBeforeWorkout: 'Calm',
        energyAfterWorkout: 'High',
        notes: 'Mobility',
      );

      final encoded = session.toJson();
      final restored = WorkoutSession.fromJson(encoded);

      expect(restored.id, 'abc');
      expect(restored.workoutType, 'Yoga');
      expect(restored.duration, 40);
      expect(restored.bodyWeight, 68.5);
    });
  });
}
