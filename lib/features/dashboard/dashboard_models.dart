import 'package:flutter/foundation.dart';

import '../onboarding/domain/onboarding_profile.dart';
import '../finance/domain/finance_transaction.dart';
import '../fitness/domain/workout_session.dart';
import '../sleep/domain/sleep_session.dart';
import '../work_tracker/domain/work_session.dart';

@immutable
class DashboardData {
  const DashboardData({
    required this.profile,
    required this.sleepSessions,
    required this.workoutSessions,
    required this.financeTransactions,
    required this.financeMetrics,
    required this.fitnessMetrics,
    required this.workSessions,
  });

  final OnboardingProfile? profile;
  final List<SleepSession> sleepSessions;
  final List<WorkoutSession> workoutSessions;
  final List<WorkSession> workSessions;
  final List<FinanceTransaction> financeTransactions;
  final FinanceTransactionMetrics financeMetrics;
  final WorkoutSessionMetrics fitnessMetrics;

  OnboardingProfile get resolvedProfile => profile ?? const OnboardingProfile(completedSteps: []);

  double get averageSleep {
    if (sleepSessions.isEmpty) {
      return 0.0;
    }

    return sleepSessions
        .map((session) => session.sleepDuration)
        .reduce((value, element) => value + element) /
        sleepSessions.length;
  }

  DashboardData copyWith({
    OnboardingProfile? profile,
    List<SleepSession>? sleepSessions,
    List<WorkoutSession>? workoutSessions,
    List<WorkSession>? workSessions,
    List<FinanceTransaction>? financeTransactions,
    FinanceTransactionMetrics? financeMetrics,
    WorkoutSessionMetrics? fitnessMetrics,
  }) {
    return DashboardData(
      profile: profile ?? this.profile,
      sleepSessions: sleepSessions ?? this.sleepSessions,
      workoutSessions: workoutSessions ?? this.workoutSessions,
      workSessions: workSessions ?? this.workSessions,
      financeTransactions: financeTransactions ?? this.financeTransactions,
      financeMetrics: financeMetrics ?? this.financeMetrics,
      fitnessMetrics: fitnessMetrics ?? this.fitnessMetrics,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'profile': profile?.toJson(),
      'sleepSessions': sleepSessions.map((item) => item.toJson()).toList(growable: false),
      'workoutSessions': workoutSessions.map((item) => item.toJson()).toList(growable: false),
      'workSessions': workSessions.map((item) => item.toJson()).toList(growable: false),
      'financeTransactions': financeTransactions.map((item) => item.toJson()).toList(growable: false),
      'financeMetrics': {
        'totalIncome': financeMetrics.totalIncome,
        'totalExpense': financeMetrics.totalExpense,
        'netBalance': financeMetrics.netBalance,
      },
      'fitnessMetrics': {
        'weeklyWorkouts': fitnessMetrics.weeklyWorkouts,
        'workoutStreak': fitnessMetrics.workoutStreak,
      },
    };
  }
}
