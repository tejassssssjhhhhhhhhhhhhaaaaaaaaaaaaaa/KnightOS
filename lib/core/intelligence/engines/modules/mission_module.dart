import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../../domain/mission_models.dart';
import '../memory_retrieval_engine.dart';
import '../memory_engine.dart';
import '../mission/mission_planning_engine.dart';
import '../mission/progress_intelligence_engine.dart';
import '../mission/mission_forecasting_engine.dart';
import '../mission/blocker_detection_engine.dart';
import '../mission/mission_recommendation_engine.dart';
import '../../domain/cognitive_models.dart';

class MissionModule implements IntelligenceModule {
  MissionModule({required this.retrieval, required this.memoryEngine}) {
    planning = MissionPlanningEngine(memoryEngine: memoryEngine);
    progress = ProgressIntelligenceEngine(retrieval: retrieval);
    forecasting = const MissionForecastingEngine();
    blockers = const BlockerDetectionEngine();
    recommendationEngine = const MissionRecommendationEngine();
  }

  final MemoryRetrievalEngine retrieval;
  final MemoryEngine memoryEngine;

  late final MissionPlanningEngine planning;
  late final ProgressIntelligenceEngine progress;
  late final MissionForecastingEngine forecasting;
  late final BlockerDetectionEngine blockers;
  late final MissionRecommendationEngine recommendationEngine;

  @override
  String get id => 'mission_intelligence';

  @override
  List<BookCategory> get inputCategories => [
    BookCategory.ambitions,
    BookCategory.career,
    BookCategory.health,
    BookCategory.finance,
  ];

  @override
  double get priority => 0.85;

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    if (event is DataChangedEvent) {
      // Re-evaluate mission progress if related data changed
    }
  }

  @override
  Future<List<IntelligenceResult>> getInsights() async {
    final List<IntelligenceResult> insights = [];

    final missions = await _getAllMissions();
    for (final mission in missions) {
      final completion = await progress.calculateCompletion(mission.id);
      final momentum = await progress.calculateMomentum(mission.id);

      insights.add(
        IntelligenceResult(
          id: 'mission-progress-${mission.id}',
          data:
              '${mission.title}: ${(completion * 100).toInt()}% complete. Momentum: ${(momentum * 100).toInt()}%.',
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [mission.id],
            rulesApplied: [],
            goalsConsidered: [],
            thoughtChain: [
              'Analyzed goal completion status.',
              'Calculated recent activity momentum.',
            ],
            confidence: 0.9,
          ),
          generatedAt: DateTime.now(),
          version: 1,
          evidenceHash: 'mission-${mission.id}',
        ),
      );
    }

    return insights;
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async {
    // In a real implementation, we'd fetch current context
    final missions = await _getAllMissions();
    if (missions.isEmpty) return [];

    final adaptiveRecs = await planning.adaptPlan(missions.first, []);
    return recommendationEngine.generateRecommendations(adaptiveRecs);
  }

  @override
  Future<List<String>> getBriefingItems() async {
    final List<String> items = [];
    final missions = await _getAllMissions();

    for (final m in missions.take(3)) {
      final comp = await progress.calculateCompletion(m.id);
      items.add('${m.title}: ${(comp * 100).toInt()}%');
    }

    return items;
  }

  Future<List<Mission>> _getAllMissions() async {
    final memories = await retrieval.getByCategory(BookCategory.ambitions);
    return memories
        .where((m) => m.missionDataType == 'mission')
        .map((m) => m.toMission()!)
        .toList();
  }
}
