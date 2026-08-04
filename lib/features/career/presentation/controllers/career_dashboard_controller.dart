import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/identity_service.dart';
import '../../../../core/providers/mission_providers.dart';
import '../../../../core/providers/integration_providers.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/intelligence/domain/intelligence_models.dart';
import '../../../../core/domain/entities/mission.dart';
import '../../../../core/domain/entities/timeline_event.dart';
import '../../../../core/domain/entities/evidence.dart';

class CareerDashboardState {
  const CareerDashboardState({
    required this.identity,
    this.careerProfile = const {},
    this.activeMissions = const [],
    this.timelinePreview = const [],
    this.topSkills = const [],
    this.achievements = const [],
    this.aiInsight,
    this.momentum = 0.85,
    this.skillGrowth = 0.12,
    this.learningProgress = 0.65,
  });

  final Map<String, dynamic> identity;
  final Map<String, dynamic> careerProfile;
  final List<Mission> activeMissions;
  final List<TimelineEvent> timelinePreview;
  final List<String> topSkills;
  final List<Evidence> achievements;
  final IntelligenceResult? aiInsight;
  final double momentum;
  final double skillGrowth;
  final double learningProgress;

  CareerDashboardState copyWith({
    Map<String, dynamic>? identity,
    Map<String, dynamic>? careerProfile,
    List<Mission>? activeMissions,
    List<TimelineEvent>? timelinePreview,
    List<String>? topSkills,
    List<Evidence>? achievements,
    IntelligenceResult? aiInsight,
    double? momentum,
    double? skillGrowth,
    double? learningProgress,
  }) {
    return CareerDashboardState(
      identity: identity ?? this.identity,
      careerProfile: careerProfile ?? this.careerProfile,
      activeMissions: activeMissions ?? this.activeMissions,
      timelinePreview: timelinePreview ?? this.timelinePreview,
      topSkills: topSkills ?? this.topSkills,
      achievements: achievements ?? this.achievements,
      aiInsight: aiInsight ?? this.aiInsight,
      momentum: momentum ?? this.momentum,
      skillGrowth: skillGrowth ?? this.skillGrowth,
      learningProgress: learningProgress ?? this.learningProgress,
    );
  }
}

class CareerDashboardNotifier extends AsyncNotifier<CareerDashboardState> {
  @override
  Future<CareerDashboardState> build() async {
    final identityService = IdentityService.instance;
    final missionService = ref.watch(missionServiceProvider);
    final timelineService = ref.watch(timelineServiceProvider);
    final orchestrator = ref.watch(intelligenceOrchestratorProvider);
    
    final missions = await missionService.getDailyFocus();
    final careerMissions = missions.where((m) => m.owningDomain == 'career').toList();

    final careerEvents = await timelineService.getRecent(5); 

    final insights = await orchestrator.getAllInsights();
    final careerInsight = insights.isNotEmpty ? insights.first : null;
    
    return CareerDashboardState(
      identity: {
        'displayName': identityService.currentIdentity.displayName,
        'photoUrl': identityService.currentIdentity.photoUrl,
        'primaryEmail': identityService.currentIdentity.primaryEmail,
      },
      careerProfile: identityService.getCareerProfile(),
      activeMissions: careerMissions,
      timelinePreview: careerEvents,
      topSkills: ['Flutter', 'Dart', 'System Architecture'],
      achievements: [],
      aiInsight: careerInsight,
    );
  }
}

final careerDashboardControllerProvider = AsyncNotifierProvider<CareerDashboardNotifier, CareerDashboardState>(
  CareerDashboardNotifier.new,
);
