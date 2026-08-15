import 'package:collection/collection.dart';
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
import '../../../platform/engine/scoring_interfaces.dart';
import '../../../platform/engine/scoring_models.dart';
import '../../../platform/engine/recommendation_interfaces.dart';
import '../../../platform/engine/recommendation_models.dart';
import '../../../platform/engine/analytics_models.dart';

class MissionModule extends IntelligenceModule {
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
  KnightScoreProvider? get scoreProvider => _MissionScoreProvider(progress, retrieval);

  @override
  KnightRecommendationProvider? get recommendationProvider => _MissionRecommendationProvider(recommendationEngine, planning, _getAllMissions);

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
    final missions = await _getAllMissions();
    final firstMission = missions.firstOrNull;
    if (firstMission == null) return [];

    final adaptiveRecs = await planning.adaptPlan(firstMission, []);
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

class _MissionScoreProvider implements KnightScoreProvider {
  _MissionScoreProvider(this.progress, this.retrieval);
  final ProgressIntelligenceEngine progress;
  final MemoryRetrievalEngine retrieval;

  @override
  String get id => 'mission_score_provider';
  @override
  String get name => 'Mission Completion Score';
  @override
  KnightScoreCategory get category => KnightScoreCategory.goals;

  @override
  Future<KnightScoreValue> requestScore() async {
    final memories = await retrieval.getByCategory(BookCategory.ambitions);
    final missions = memories.where((m) => m.missionDataType == 'mission').toList();
    
    if (missions.isEmpty) {
      return KnightScoreValue(
        value: 0,
        category: category,
        grade: const KnightScoreGrade(label: 'N/A', rank: 0),
        confidence: const KnightScoreConfidence(value: 1.0),
        timestamp: DateTime.now(),
        source: const KnightScoreSource(name: 'Mission Intelligence'),
      );
    }

    double totalComp = 0;
    for (final m in missions) {
      totalComp += await progress.calculateCompletion(m.id);
    }
    final avg = (totalComp / missions.length) * 100;

    return KnightScoreValue(
      value: avg,
      category: category,
      grade: _calculateGrade(avg),
      confidence: const KnightScoreConfidence(value: 0.95),
      timestamp: DateTime.now(),
      source: const KnightScoreSource(name: 'Mission Intelligence'),
    );
  }

  KnightScoreGrade _calculateGrade(double value) {
    if (value >= 90) return const KnightScoreGrade(label: 'Optimal', rank: 5);
    if (value >= 70) return const KnightScoreGrade(label: 'Good', rank: 3);
    return const KnightScoreGrade(label: 'Steady', rank: 2);
  }
}

class _MissionRecommendationProvider implements KnightRecommendationProvider {
  _MissionRecommendationProvider(this.engine, this.planning, this.getMissions);
  final MissionRecommendationEngine engine;
  final MissionPlanningEngine planning;
  final Future<List<Mission>> Function() getMissions;

  @override
  String get id => 'mission_recommendation_provider';
  @override
  String get name => 'Mission Recommendations';
  @override
  String get moduleId => 'mission_intelligence';

  @override
  Future<List<KnightRecommendation>> requestRecommendations({
    required List<KnightScoreValue> scores,
    required List<KnightAnalyticsSnapshot> analytics,
  }) async {
    final missions = await getMissions();
    final firstMission = missions.firstOrNull;
    if (firstMission == null) return [];

    final adaptiveRecs = await planning.adaptPlan(firstMission, []);
    final results = await engine.generateRecommendations(adaptiveRecs);
    
    return results.map((r) => KnightRecommendation(
      id: r.id,
      title: r.data.toString(),
      description: r.trace.thoughtChain.join(' '),
      category: KnightRecommendationCategory.goals,
      priority: KnightRecommendationPriority.high,
      confidence: KnightRecommendationConfidence(value: r.trace.confidence),
      reason: KnightRecommendationReason(summary: r.trace.thoughtChain.firstOrNull ?? 'Strategic mission planning'),
      source: const KnightRecommendationSource(name: 'Mission Intelligence'),
      action: const KnightRecommendationAction(label: 'Take Action'),
      timestamp: r.generatedAt,
    )).toList();
  }
}
