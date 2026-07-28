class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.workoutDate,
    required this.workoutType,
    required this.duration,
    required this.caloriesBurned,
    required this.weight,
    required this.sets,
    required this.reps,
    required this.distance,
    required this.bodyWeight,
    required this.moodBeforeWorkout,
    required this.energyAfterWorkout,
    required this.notes,
  });

  final String id;
  final String workoutDate;
  final String workoutType;
  final int duration;
  final int caloriesBurned;
  final double weight;
  final int sets;
  final int reps;
  final double distance;
  final double bodyWeight;
  final String moodBeforeWorkout;
  final String energyAfterWorkout;
  final String notes;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'workoutDate': workoutDate,
      'workoutType': workoutType,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'weight': weight,
      'sets': sets,
      'reps': reps,
      'distance': distance,
      'bodyWeight': bodyWeight,
      'moodBeforeWorkout': moodBeforeWorkout,
      'energyAfterWorkout': energyAfterWorkout,
      'notes': notes,
    };
  }

  factory WorkoutSession.fromJson(Map<String, Object?> json) {
    return WorkoutSession(
      id: json['id'] as String? ?? '',
      workoutDate: json['workoutDate'] as String? ?? '',
      workoutType: json['workoutType'] as String? ?? 'Strength',
      duration: json['duration'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      sets: json['sets'] as int? ?? 0,
      reps: json['reps'] as int? ?? 0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      bodyWeight: (json['bodyWeight'] as num?)?.toDouble() ?? 0.0,
      moodBeforeWorkout: json['moodBeforeWorkout'] as String? ?? '',
      energyAfterWorkout: json['energyAfterWorkout'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }
}

class WorkoutSessionMetrics {
  const WorkoutSessionMetrics({
    required this.weeklyWorkouts,
    required this.monthlyWorkouts,
    required this.totalWorkoutTime,
    required this.totalCaloriesBurned,
    required this.averageWorkoutDuration,
    required this.longestWorkout,
    required this.workoutStreak,
  });

  final int weeklyWorkouts;
  final int monthlyWorkouts;
  final int totalWorkoutTime;
  final int totalCaloriesBurned;
  final double averageWorkoutDuration;
  final int longestWorkout;
  final int workoutStreak;

  factory WorkoutSessionMetrics.fromSessions(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) {
      return const WorkoutSessionMetrics(
        weeklyWorkouts: 0,
        monthlyWorkouts: 0,
        totalWorkoutTime: 0,
        totalCaloriesBurned: 0,
        averageWorkoutDuration: 0,
        longestWorkout: 0,
        workoutStreak: 0,
      );
    }

    final durations = sessions.map((session) => session.duration).toList();
    final sortedDates =
        sessions
            .map((session) => DateTime.tryParse(session.workoutDate))
            .whereType<DateTime>()
            .toSet()
            .toList()
          ..sort();

    var streak = 0;
    final uniqueDays =
        sortedDates
            .map((date) => DateTime(date.year, date.month, date.day))
            .toSet()
            .toList()
          ..sort();
    if (uniqueDays.isNotEmpty) {
      var current = 1;
      for (var index = 1; index < uniqueDays.length; index += 1) {
        final previous = uniqueDays[index - 1];
        final currentDate = uniqueDays[index];
        if (currentDate.difference(previous).inDays == 1) {
          current += 1;
        } else {
          current = 1;
        }
        streak = streak > current ? streak : current;
      }
      streak = streak == 0 ? current : streak;
    }

    return WorkoutSessionMetrics(
      weeklyWorkouts: sessions.length,
      monthlyWorkouts: sessions.length,
      totalWorkoutTime: durations.fold<int>(0, (sum, item) => sum + item),
      totalCaloriesBurned: sessions.fold<int>(
        0,
        (sum, item) => sum + item.caloriesBurned,
      ),
      averageWorkoutDuration: durations.isEmpty
          ? 0
          : durations.reduce((value, element) => value + element) /
                durations.length,
      longestWorkout: durations.isEmpty
          ? 0
          : durations.reduce(
              (value, element) => value > element ? value : element,
            ),
      workoutStreak: streak,
    );
  }
}
