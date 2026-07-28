import '../../../features/onboarding/domain/onboarding_profile.dart';
import '../../../features/work_tracker/domain/work_session.dart';
import '../../services/ai_service.dart';

class InsightEngine {
  const InsightEngine({this.aiService});

  final AiService? aiService;

  String generateInsight({required String name, required int knightScore}) {
    if (aiService != null) {
      return aiService!.buildDailyInsight(name: name, knightScore: knightScore);
    }

    return 'Local insights are ready for $name.';
  }

  List<String> generateInsights({
    required OnboardingProfile profile,
    required List<WorkSession> sessions,
  }) {
    final insights = <String>[];
    final averageStress = sessions.isEmpty
        ? 0.0
        : sessions
                  .map((session) => session.stressRating)
                  .reduce((value, element) => value + element) /
              sessions.length;
    final averageFocus = sessions.isEmpty
        ? 0.0
        : sessions
                  .map((session) => session.focusRating)
                  .reduce((value, element) => value + element) /
              sessions.length;
    final profileCompletion = _profileCompletion(profile);

    if (sessions.any(
      (session) => session.shiftType.toLowerCase().contains('night'),
    )) {
      insights.add('Night Shift detected');
    }

    if (averageStress >= 7) {
      insights.add('High Stress detected');
    }

    if (averageFocus <= 4) {
      insights.add('Low Focus');
    }

    if (sessions.length >= 3) {
      insights.add('Excellent Consistency');
    }

    if (profileCompletion < 70) {
      insights.add('Profile incomplete');
    }

    insights.add('No AI APIs.');
    return insights;
  }

  int _profileCompletion(OnboardingProfile profile) {
    final completedFields = <String>[
      profile.fullName,
      profile.occupation,
      profile.company,
      profile.sleepGoal,
      profile.workHours,
      profile.healthGoal,
      profile.monthlyBudget,
      profile.lifeGoals,
    ].where((value) => value.trim().isNotEmpty).length;

    return ((completedFields / 8) * 100).round().clamp(0, 100);
  }
}
