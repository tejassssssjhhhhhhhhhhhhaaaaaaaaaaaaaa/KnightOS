import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/identity_service.dart';
import '../../../../core/providers/mission_providers.dart';
import '../../../../core/providers/integration_providers.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/intelligence/domain/intelligence_models.dart';
import '../../../../core/intelligence/domain/cognitive_models.dart' as cognitive;
import '../../../../core/domain/entities/mission.dart';
import '../../../../core/domain/entities/timeline_event.dart';

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
  final List<cognitive.Evidence> achievements;
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
    List<cognitive.Evidence>? achievements,
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

    final careerEvents = await timelineService.getRecent(10); 
    final recentEventsCount = careerEvents.where((e) => e.startTime.isAfter(DateTime.now().subtract(const Duration(days: 30)))).length;
    final momentum = (recentEventsCount / 5).clamp(0.0, 1.0);

    final insights = await orchestrator.getAllInsights();
    final careerInsight = insights.isNotEmpty ? insights.first : null;

    final db = ref.watch(knightDatabaseProvider);
    final achievementEntities = await db.extractedEntityDao.getEntitiesByType('career_event');
    
    return CareerDashboardState(
      identity: {
        'displayName': identityService.currentIdentity.displayName,
        'photoUrl': identityService.currentIdentity.photoUrl,
        'primaryEmail': identityService.currentIdentity.primaryEmail,
      },
      careerProfile: identityService.getCareerProfile(),
      activeMissions: careerMissions,
      timelinePreview: careerEvents.take(5).toList(),
      topSkills: ['Flutter', 'Dart', 'System Architecture'],
      achievements: achievementEntities.map((e) => cognitive.Evidence(
        source: e.parserName,
        timestamp: e.eventTimestamp,
        trustWeight: e.confidenceScore,
        isObserved: true,
        freshness: 1.0,
        metadata: {'title': e.title},
      )).toList(),
      aiInsight: careerInsight,
      momentum: momentum,
      skillGrowth: 0.12 + (careerMissions.length * 0.05),
      learningProgress: careerMissions.isEmpty ? 0.0 : (careerMissions.where((m) => m.status == MissionStatus.completed).length / careerMissions.length),
    );
  }
}

final careerDashboardControllerProvider = AsyncNotifierProvider<CareerDashboardNotifier, CareerDashboardState>(
  CareerDashboardNotifier.new,
);
