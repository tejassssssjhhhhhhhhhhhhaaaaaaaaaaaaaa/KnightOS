import '../../../features/onboarding/domain/onboarding_profile.dart';
import '../../../features/work_tracker/domain/work_session.dart';

class MissionEngine {
  const MissionEngine();

  String generateMission({
    required OnboardingProfile profile,
    required List<WorkSession> sessions,
  }) {
    if (profile.completedSteps.length < 2) {
      return 'Complete today\'s work log.';
    }

    if (profile.healthGoals.isEmpty) {
      return 'Sleep at least 7 hours today.';
    }

    if (sessions.isEmpty) {
      return 'Stay within budget today.';
    }

    return 'Keep your focus high and finish your next work block today.';
  }
}
