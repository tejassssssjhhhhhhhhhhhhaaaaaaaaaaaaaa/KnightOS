import '../../features/onboarding/domain/onboarding_profile.dart';
import 'domain/knowledge_models.dart';

class LearningMentorInsight {
  const LearningMentorInsight({required this.title, required this.description, required this.kind});

  final String title;
  final String description;
  final String kind;
}

class KnowledgeService {
  const KnowledgeService();

  PersonalKnowledgeBase buildKnowledgeBase(OnboardingProfile profile) {
    final facts = <KnowledgeFact>[
      KnowledgeFact(id: 'name', category: 'personal', value: profile.fullName.isEmpty ? 'Profile pending' : profile.fullName),
      KnowledgeFact(id: 'occupation', category: 'work', value: profile.occupation.isEmpty ? 'Role pending' : profile.occupation),
      KnowledgeFact(id: 'work-style', category: 'work', value: profile.workType.isEmpty ? 'Flexible' : profile.workType),
    ];

    final preferences = <KnowledgeFact>[
      KnowledgeFact(id: 'theme', category: 'preferences', value: profile.themePreference.isEmpty ? 'Adaptive' : profile.themePreference),
      KnowledgeFact(id: 'notification', category: 'preferences', value: profile.notificationPreference.isEmpty ? 'Balanced' : profile.notificationPreference),
    ];

    final goals = <KnowledgeFact>[
      KnowledgeFact(id: 'goal', category: 'goals', value: profile.lifeGoals.isEmpty ? 'Build a calm routine' : profile.lifeGoals),
      KnowledgeFact(id: 'learning', category: 'goals', value: profile.learningGoals.isEmpty ? 'Continue learning' : profile.learningGoals),
    ];

    final habits = <KnowledgeFact>[
      KnowledgeFact(id: 'sleep', category: 'habits', value: profile.sleepGoal.isEmpty ? 'Sleep goal pending' : profile.sleepGoal),
      KnowledgeFact(id: 'fitness', category: 'habits', value: profile.exerciseFrequency.isEmpty ? 'Exercise goal pending' : profile.exerciseFrequency),
    ];

    return PersonalKnowledgeBase(facts: facts, preferences: preferences, goals: goals, habits: habits);
  }

  List<LearningMentorInsight> buildMentorPlan(OnboardingProfile profile) {
    final focus = profile.learningGoals.isEmpty ? 'Build a steadier daily rhythm' : profile.learningGoals;
    final name = profile.preferredName.isEmpty ? (profile.fullName.isEmpty ? 'friend' : profile.fullName) : profile.preferredName;

    return <LearningMentorInsight>[
      LearningMentorInsight(
        title: 'Start with one weekly focus',
        description: '$name, your mentor plan begins with a single commitment: $focus.',
        kind: 'plan',
      ),
      LearningMentorInsight(
        title: 'Reflect after each session',
        description: 'Capture one win, one friction point, and one next step in your voice notes or journal.',
        kind: 'reflection',
      ),
      LearningMentorInsight(
        title: 'Use the dashboard as your coach',
        description: 'Let your habits, recommendations, and voice captures guide the next best action instead of chasing everything at once.',
        kind: 'guidance',
      ),
    ];
  }
}
