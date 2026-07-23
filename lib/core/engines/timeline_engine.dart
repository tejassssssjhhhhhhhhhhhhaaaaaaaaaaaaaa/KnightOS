import '../../features/onboarding/domain/onboarding_profile.dart';
import '../../features/work_tracker/domain/work_session.dart';

class TimelineEngine {
  const TimelineEngine();

  List<TimelineItem> buildTimeline({
    required OnboardingProfile profile,
    required List<WorkSession> sessions,
  }) {
    final timeline = <TimelineItem>[];

    if (profile.completedSteps.isNotEmpty) {
      timeline.add(
        const TimelineItem(
          type: 'profile_updated',
          title: 'Profile Updated',
          description: 'Your profile details are ready for KnightOS.',
        ),
      );
    }

    for (final session in sessions) {
      timeline.add(
        TimelineItem(
          type: 'work_logged',
          title: 'Work Logged',
          description: '${session.shiftType} shift logged with ${session.productiveHours} productive hours.',
        ),
      );
    }

    if (timeline.isEmpty) {
      timeline.add(
        const TimelineItem(
          type: 'dashboard_viewed',
          title: 'Dashboard Viewed',
          description: 'The dashboard is ready for your next check-in.',
        ),
      );
    }

    return timeline;
  }
}

class TimelineItem {
  const TimelineItem({required this.type, required this.title, required this.description});

  final String type;
  final String title;
  final String description;
}
