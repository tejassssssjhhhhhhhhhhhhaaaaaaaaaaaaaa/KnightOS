import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import '../../../platform/engine/scoring_interfaces.dart';
import '../../../platform/engine/scoring_models.dart';
import '../../../platform/engine/recommendation_interfaces.dart';
import '../../../platform/engine/recommendation_models.dart';
import '../../../platform/engine/analytics_interfaces.dart';
import '../../../platform/engine/analytics_models.dart';

class WorkModule extends IntelligenceModule {
  WorkModule({required this.db});
  final KnightDatabase db;

  @override
  String get id => 'work_intelligence';

  @override
  List<BookCategory> get inputCategories => [BookCategory.career];

  @override
  double get priority => 0.8;

  @override
  KnightScoreProvider? get scoreProvider => _WorkScoreProvider(db);

  @override
  KnightRecommendationProvider? get recommendationProvider => _WorkRecommendationProvider(db);

  @override
  KnightAnalyticsProvider? get analyticsProvider => _WorkAnalyticsProvider(db);

  @override
  Future<void> onEvent(IntelligenceEvent event) async {}

  @override
  Future<List<IntelligenceResult>> getInsights() async => [];

  @override
  Future<List<IntelligenceResult>> getRecommendations() async => [];

  @override
  Future<List<String>> getBriefingItems() async {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final sessions = await db.workTrackerDao.getSessionsForDate(todayStr);
    
    if (sessions.isEmpty) return ['No work logged yet today.'];
    
    final totalHours = sessions.map((s) => s.totalHours).fold(0.0, (a, b) => a + b);
    return ['Work: ${totalHours.toStringAsFixed(1)} hours logged today.'];
  }
}

class _WorkScoreProvider implements KnightScoreProvider {
  _WorkScoreProvider(this.db);
  final KnightDatabase db;

  @override
  String get id => 'work_score_provider';
  @override
  String get name => 'Work Productivity Score';
  @override
  KnightScoreCategory get category => KnightScoreCategory.work;

  @override
  Future<KnightScoreValue> requestScore() async {
    final sessions = await db.workTrackerDao.getRecentSessions(limit: 5);
    if (sessions.isEmpty) return _defaultScore();

    double totalProductivity = 0;
    for (final s in sessions) {
      totalProductivity += (s.productiveHours / (s.totalHours == 0 ? 1 : s.totalHours));
    }
    final avg = (totalProductivity / sessions.length) * 100;

    return KnightScoreValue(
      value: avg,
      category: category,
      grade: _calculateGrade(avg),
      confidence: const KnightScoreConfidence(value: 0.9),
      timestamp: DateTime.now(),
      source: const KnightScoreSource(name: 'Work Tracker'),
    );
  }

  KnightScoreValue _defaultScore() => KnightScoreValue(
    value: 60,
    category: category,
    grade: const KnightScoreGrade(label: 'Baseline', rank: 2),
    confidence: const KnightScoreConfidence(value: 0.5),
    timestamp: DateTime.now(),
    source: const KnightScoreSource(name: 'Work Tracker'),
  );

  KnightScoreGrade _calculateGrade(double value) {
    if (value >= 85) return const KnightScoreGrade(label: 'Optimal', rank: 5);
    if (value >= 70) return const KnightScoreGrade(label: 'Efficient', rank: 3);
    return const KnightScoreGrade(label: 'Steady', rank: 2);
  }
}

class _WorkRecommendationProvider implements KnightRecommendationProvider {
  _WorkRecommendationProvider(this.db);
  final KnightDatabase db;

  @override
  String get id => 'work_recommendation_provider';
  @override
  String get name => 'Work Recommendations';
  @override
  String get moduleId => 'work_intelligence';

  @override
  Future<List<KnightRecommendation>> requestRecommendations({
    required List<KnightScoreValue> scores,
    required List<KnightAnalyticsSnapshot> analytics,
  }) async {
    final sessions = await db.workTrackerDao.getRecentSessions(limit: 1);
    if (sessions.isEmpty) return [];

    final last = sessions.first;
    if (last.focusRating < 5) {
      return [
        KnightRecommendation(
          id: 'rec-work-focus',
          title: 'Deep Work Session Suggested',
          description: 'Focus rating was low in your last session. Consider a 90-minute deep work block.',
          category: KnightRecommendationCategory.work,
          priority: KnightRecommendationPriority.medium,
          confidence: const KnightRecommendationConfidence(value: 0.8),
          reason: const KnightRecommendationReason(summary: 'Low focus rating in recent session'),
          source: const KnightRecommendationSource(name: 'Work Intelligence'),
          action: const KnightRecommendationAction(label: 'Start Timer'),
          timestamp: DateTime.now(),
        )
      ];
    }
    return [];
  }
}

class _WorkAnalyticsProvider implements KnightAnalyticsProvider {
  _WorkAnalyticsProvider(this.db);
  final KnightDatabase db;

  @override
  String get id => 'work_analytics_provider';
  @override
  String get name => 'Work Analytics';
  @override
  String get moduleId => 'work_intelligence';

  @override
  Future<List<KnightHistoricalDataPoint>> requestHistoricalData() async {
    final sessions = await db.workTrackerDao.getRecentSessions(limit: 30);
    return sessions.map((s) => KnightHistoricalDataPoint(
      timestamp: DateTime.parse(s.workDate),
      value: s.productiveHours,
    )).toList();
  }

  @override
  Future<List<KnightMetric>> requestMetrics() async {
    final sessions = await db.workTrackerDao.getRecentSessions(limit: 7);
    if (sessions.isEmpty) return [];
    
    final avgProd = sessions.map((s) => s.productiveHours).fold(0.0, (a, b) => a + b) / sessions.length;
    return [
      KnightMetric(name: 'Avg Productive Hours', value: avgProd, timestamp: DateTime.now(), unit: 'h'),
    ];
  }

  @override
  Future<List<KnightScoreValue>> requestScoreHistory() async => [];
}
