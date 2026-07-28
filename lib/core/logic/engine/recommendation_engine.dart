import '../../../features/onboarding/domain/onboarding_profile.dart';
import '../../../features/work_tracker/domain/work_session.dart';
import '../../services/ai_service.dart';

class RecommendationEngine {
  const RecommendationEngine({this.aiService});

  final AiService? aiService;

  List<String> generateRecommendations({
    int? knightScore,
    int? score,
    OnboardingProfile? profile,
    List<WorkSession>? sessions,
  }) {
    if (aiService != null && (knightScore != null || score != null)) {
      final resolvedScore = knightScore ?? score ?? 0;
      return aiService!.buildRecommendations(knightScore: resolvedScore);
    }

    if (profile != null && sessions != null) {
      return _generateRecommendationsForSignals(
        score: score ?? 0,
        profile: profile,
        sessions: sessions,
      );
    }

    return const <String>[];
  }

  List<String> _generateRecommendationsForSignals({
    required int score,
    required OnboardingProfile profile,
    required List<WorkSession> sessions,
  }) {
    final recommendations = <String>[];

    if (score < 70) {
      recommendations.add('Take a 10-minute break.');
    }

    if (profile.completedSteps.length < 2) {
      recommendations.add('Complete your profile.');
    }

    if (sessions.isEmpty) {
      recommendations.add('Track today\'s expenses.');
    }

    if (profile.healthGoals.isEmpty) {
      recommendations.add('Log today\'s workout.');
    }

    if (recommendations.isEmpty) {
      recommendations.add('Stay consistent with your current routine.');
    }

    return recommendations;
  }
}
