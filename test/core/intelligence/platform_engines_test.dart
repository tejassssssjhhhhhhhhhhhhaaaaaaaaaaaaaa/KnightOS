import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/platform/engine/knight_engine.dart'; // For PlatformEventBus
import 'package:knight_os/core/platform/engine/scoring_engine.dart';
import 'package:knight_os/core/platform/engine/scoring_models.dart';
import 'package:knight_os/core/platform/engine/scoring_interfaces.dart';
import 'package:knight_os/core/platform/engine/recommendation_engine.dart';
import 'package:knight_os/core/platform/engine/recommendation_models.dart';
import 'package:knight_os/core/platform/engine/recommendation_interfaces.dart';
import 'package:knight_os/core/platform/engine/analytics_engine.dart';
import 'package:knight_os/core/platform/engine/analytics_models.dart';
import 'package:knight_os/core/platform/engine/analytics_interfaces.dart';

class MockScoreProvider implements KnightScoreProvider {
  final String _id;
  final KnightScoreCategory _category;
  final double _value;
  final String _source;

  MockScoreProvider(this._id, this._category, this._value, this._source);

  @override
  String get id => _id;
  @override
  String get name => 'Mock $_id';
  @override
  KnightScoreCategory get category => _category;

  @override
  Future<KnightScoreValue> requestScore() async {
    return KnightScoreValue(
      value: _value,
      category: _category,
      grade: const KnightScoreGrade(label: 'Good', rank: 3),
      confidence: const KnightScoreConfidence(value: 0.9),
      timestamp: DateTime.now(),
      source: KnightScoreSource(name: _source),
    );
  }
}

class MockRecommendationProvider implements KnightRecommendationProvider {
  @override
  String get id => 'mock_rec';
  @override
  String get name => 'Mock Rec';
  @override
  String get moduleId => 'test';

  @override
  Future<List<KnightRecommendation>> requestRecommendations({
    required List<KnightScoreValue> scores,
    required List<KnightAnalyticsSnapshot> analytics,
  }) async {
    return [
      KnightRecommendation(
        id: '1',
        title: 'Test Recommendation',
        description: 'Test',
        category: KnightRecommendationCategory.health,
        priority: KnightRecommendationPriority.high,
        confidence: const KnightRecommendationConfidence(value: 0.9),
        reason: const KnightRecommendationReason(summary: 'Testing'),
        source: const KnightRecommendationSource(name: 'Mock'),
        action: const KnightRecommendationAction(label: 'OK'),
        timestamp: DateTime.now(),
      )
    ];
  }
}

class MockAnalyticsProvider implements KnightAnalyticsProvider {
  @override
  String get id => 'mock_analytics';
  @override
  String get name => 'Mock Analytics';
  @override
  String get moduleId => 'test';

  @override
  Future<List<KnightHistoricalDataPoint>> requestHistoricalData() async {
    return [
      KnightHistoricalDataPoint(timestamp: DateTime.now().subtract(const Duration(days: 1)), value: 10),
      KnightHistoricalDataPoint(timestamp: DateTime.now(), value: 20),
    ];
  }

  @override
  Future<List<KnightMetric>> requestMetrics() async => [];
  @override
  Future<List<KnightScoreValue>> requestScoreHistory() async => [];
}

void main() {
  group('PlatformScoringEngine', () {
    test('aggregates scores with weighting and freshness', () async {
      final bus = PlatformEventBus();
      final engine = PlatformScoringEngine(eventBus: bus);
      
      engine.registerProvider(MockScoreProvider('p1', KnightScoreCategory.health, 80, 'Galaxy Watch'));
      engine.registerProvider(MockScoreProvider('p2', KnightScoreCategory.health, 90, 'Manual Input'));

      await engine.refreshScores();

      final snapshots = await engine.getSnapshots();
      expect(snapshots.length, 1);
      // Galaxy Watch (0.9), Manual Input (1.0)
      // (80*0.9 + 90*1.0) / 1.9 = 85.26...
      expect(snapshots.first.value, closeTo(85.26, 0.1));
    });
  });

  group('PlatformRecommendationEngine', () {
    test('ranks and dedupes recommendations', () async {
      final bus = PlatformEventBus();
      final engine = PlatformRecommendationEngine(eventBus: bus);
      engine.registerProvider(MockRecommendationProvider());

      final recs = await engine.requestRecommendations(scores: [], analytics: []);
      expect(recs.length, 1);
      expect(recs.first.title, 'Test Recommendation');
    });
  });

  group('AnalyticsEngine', () {
    test('detects trends correctly', () async {
      final bus = PlatformEventBus();
      final engine = AnalyticsEngine(eventBus: bus);
      engine.registerProvider(MockAnalyticsProvider());

      await engine.refreshAnalytics();
      final snapshots = await engine.getSnapshots();
      expect(snapshots.length, 1);
      // 10 -> 20 should be increasing
      expect(snapshots.first.trend.direction, KnightAnalyticsTrendDirection.increasing);
    });
  });
}
