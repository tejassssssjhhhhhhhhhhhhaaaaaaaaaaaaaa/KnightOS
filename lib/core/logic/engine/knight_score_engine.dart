import '../../../features/onboarding/domain/onboarding_profile.dart';
import '../../../features/work_tracker/domain/work_session.dart';

class KnightScoreEngine {
  const KnightScoreEngine();

  dynamic calculateScore({
    int? sleepScore,
    int? workScore,
    int? recoveryScore,
    OnboardingProfile? profile,
    List<WorkSession>? sessions,
  }) {
    if (profile != null || sessions != null) {
      return calculateScoreResult(
        profile: profile ?? UserProfile(completedSteps: const []),
        sessions: sessions ?? const <WorkSession>[],
      );
    }

    if (sleepScore == null || workScore == null || recoveryScore == null) {
      return 0;
    }

    final combined = sleepScore * 0.4 + workScore * 0.35 + recoveryScore * 0.25;
    return combined.round().clamp(0, 100);
  }

  KnightScoreResult calculateScoreResult({
    required OnboardingProfile profile,
    required List<WorkSession> sessions,
  }) {
    final workProductivity = _workProductivityScore(sessions);
    final profileCompletion = _profileCompletionScore(profile);
    final healthGoals = _healthGoalScore(profile);
    final consistency = _consistencyScore(sessions);
    final focus = _focusScore(sessions);
    final energy = _energyScore(sessions);

    final weightedScore =
        (workProductivity * 0.30 +
                profileCompletion * 0.20 +
                healthGoals * 0.15 +
                consistency * 0.15 +
                focus * 0.10 +
                energy * 0.10)
            .round()
            .clamp(0, 100);

    return KnightScoreResult(
      score: weightedScore,
      scoreLabel: _scoreLabel(weightedScore),
      scoreColor: _scoreColor(weightedScore),
      scoreBreakdown: {
        'Work Productivity': workProductivity.toDouble(),
        'Profile Completion': profileCompletion.toDouble(),
        'Health Goals': healthGoals.toDouble(),
        'Work Consistency': consistency.toDouble(),
        'Focus Rating': focus.toDouble(),
        'Energy Rating': energy.toDouble(),
      },
    );
  }

  int _workProductivityScore(List<WorkSession> sessions) {
    if (sessions.isEmpty) {
      return 60;
    }

    final ratio =
        sessions
            .map(
              (session) =>
                  session.productiveHours /
                  (session.totalHours == 0 ? 1 : session.totalHours),
            )
            .reduce((value, element) => value + element) /
        sessions.length;
    return (ratio * 100).round().clamp(0, 100);
  }

  int _profileCompletionScore(OnboardingProfile profile) {
    final completedFields = <String>[
      profile.fullName,
      profile.preferredName,
      profile.occupation,
      profile.company,
      profile.sleepGoal,
      profile.workHours,
      profile.healthGoal,
      profile.monthlyBudget,
      profile.lifeGoals,
    ].where((value) => value.trim().isNotEmpty).length;

    final completion = completedFields / 9 * 100;
    return completion.round().clamp(0, 100);
  }

  int _healthGoalScore(OnboardingProfile profile) {
    var score = 0;
    if (profile.healthGoals.isNotEmpty) {
      score += 50;
    }
    if (profile.sleepGoal.isNotEmpty) {
      score += 25;
    }
    if (profile.exerciseFrequency.isNotEmpty ||
        profile.fitnessLevel.isNotEmpty) {
      score += 25;
    }
    return score.clamp(0, 100);
  }

  int _consistencyScore(List<WorkSession> sessions) {
    if (sessions.isEmpty) {
      return 50;
    }

    final daysWithWork = sessions.length;
    final score = (daysWithWork / 5 * 100).clamp(0, 100);
    return score.round();
  }

  int _focusScore(List<WorkSession> sessions) {
    if (sessions.isEmpty) {
      return 65;
    }

    final averageFocus =
        sessions
            .map((session) => session.focusRating)
            .reduce((value, element) => value + element) /
        sessions.length;
    return (averageFocus * 10).round().clamp(0, 100);
  }

  int _energyScore(List<WorkSession> sessions) {
    if (sessions.isEmpty) {
      return 65;
    }

    final averageEnergy =
        sessions
            .map((session) => session.energyRating)
            .reduce((value, element) => value + element) /
        sessions.length;
    return (averageEnergy * 10).round().clamp(0, 100);
  }

  String _scoreLabel(int score) {
    if (score >= 85) {
      return 'Optimal';
    }
    if (score >= 70) {
      return 'Nominal';
    }
    if (score >= 50) {
      return 'Steady';
    }
    return 'Sub-optimal';
  }

  String _scoreColor(int score) {
    if (score >= 80) {
      return 'green';
    }
    if (score >= 60) {
      return 'amber';
    }
    return 'red';
  }
}

class KnightScoreResult {
  const KnightScoreResult({
    required this.score,
    required this.scoreLabel,
    required this.scoreColor,
    required this.scoreBreakdown,
  });

  final int score;
  final String scoreLabel;
  final String scoreColor;
  final Map<String, double> scoreBreakdown;
}
