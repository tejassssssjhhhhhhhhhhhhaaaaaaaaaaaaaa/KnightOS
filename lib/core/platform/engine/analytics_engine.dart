import 'dart:async';
import 'dart:math' as math;
import 'analytics_interfaces.dart';
import 'analytics_models.dart';
import 'engine_interfaces.dart';
import 'engine_types.dart';
import 'scoring_models.dart';
import '../../internal/utils/knight_logger.dart';

/// Production-ready analytics engine for KnightOS.
class AnalyticsEngine implements KnightModule, KnightAnalyticsStore {
  AnalyticsEngine({
    this._eventBus,
    KnightAnalyticsAggregator? aggregator,
  }) : _aggregator = aggregator ?? DefaultAnalyticsAggregator();

  final KnightEventBus? _eventBus;
  final KnightAnalyticsAggregator _aggregator;
  final List<KnightAnalyticsProvider> _providers = <KnightAnalyticsProvider>[];
  final List<KnightAnalyticsSnapshot> _snapshots = <KnightAnalyticsSnapshot>[];

  KnightModuleLifecycleState _lifecycleState = KnightModuleLifecycleState.ready;

  @override
  String get id => 'analytics_engine';

  @override
  String get name => 'Knight Analytics Engine';

  @override
  KnightModuleLifecycleState get lifecycleState => _lifecycleState;

  List<KnightAnalyticsProvider> get providers => List.unmodifiable(_providers);

  @override
  Future<List<KnightAnalyticsSnapshot>> getSnapshots() async {
    return List.unmodifiable(_snapshots);
  }

  void registerProvider(KnightAnalyticsProvider provider) {
    if (_providers.any((p) => p.id == provider.id)) return;
    _providers.add(provider);
    _eventBus?.emit(KnightModuleRegisteredEvent(provider.id));
  }

  void unregisterProvider(String providerId) {
    _providers.removeWhere((p) => p.id == providerId);
  }

  /// Refreshes analytics for all registered providers.
  Future<void> refreshAnalytics() async {
    KnightLogger.info('[ANALYTICS] Refreshing all analytics snapshots...', category: KnightLogCategory.intelligence);

    final List<KnightAnalyticsSnapshot> newSnapshots = [];
    for (final provider in _providers) {
      try {
        final snapshot = await analyzeHistoricalTrends(provider, KnightAnalyticsTimeRange.rolling);
        newSnapshots.add(snapshot);
      } catch (e, stack) {
        KnightLogger.error('[ANALYTICS] Failed to analyze ${provider.id}: $e', stackTrace: stack, category: KnightLogCategory.intelligence);
      }
    }

    _snapshots.clear();
    _snapshots.addAll(newSnapshots);
    KnightLogger.info('[ANALYTICS] Refresh complete. ${_snapshots.length} snapshots generated.', category: KnightLogCategory.intelligence);
  }

  Future<KnightAnalyticsSnapshot> analyzeHistoricalTrends(
    KnightAnalyticsProvider provider,
    KnightAnalyticsTimeRange timeRange,
  ) async {
    final history = await provider.requestHistoricalData();
    final metrics = await provider.requestMetrics();

    return await _aggregator.aggregate(
      provider.moduleId,
      timeRange,
      history,
      metrics,
    );
  }

  Future<KnightAnalyticsSnapshot> analyzeRollingAverage(
    KnightAnalyticsProvider provider,
    KnightAnalyticsTimeRange timeRange,
  ) async {
    return analyzeHistoricalTrends(provider, KnightAnalyticsTimeRange.rolling);
  }

  Future<KnightAnalyticsSnapshot> analyzeWeeklySummary(
    KnightAnalyticsProvider provider,
  ) async {
    return analyzeHistoricalTrends(provider, KnightAnalyticsTimeRange.weekly);
  }

  Future<KnightAnalyticsSnapshot> analyzeMonthlySummary(
    KnightAnalyticsProvider provider,
  ) async {
    return analyzeHistoricalTrends(provider, KnightAnalyticsTimeRange.monthly);
  }

  Future<KnightAnalyticsSnapshot> analyzeYearlySummary(
    KnightAnalyticsProvider provider,
  ) async {
    return analyzeHistoricalTrends(provider, KnightAnalyticsTimeRange.yearly);
  }

  Future<KnightAnalyticsSnapshot> analyzeScoreHistory(
    KnightAnalyticsProvider provider,
  ) async {
    final scoreHistory = await provider.requestScoreHistory();
    final history = scoreHistory.map((s) => KnightHistoricalDataPoint(
      timestamp: s.timestamp,
      value: s.value,
    )).toList();

    final metrics = await provider.requestMetrics();

    return await _aggregator.aggregate(
      provider.moduleId,
      KnightAnalyticsTimeRange.custom,
      history,
      metrics,
    );
  }

  Future<KnightComparisonResult> compareProviders(
    KnightAnalyticsProvider left,
    KnightAnalyticsProvider right,
  ) async {
    final leftMetrics = await left.requestMetrics();
    final rightMetrics = await right.requestMetrics();

    final leftVal = leftMetrics.isNotEmpty ? leftMetrics.first.value : 0.0;
    final rightVal = rightMetrics.isNotEmpty ? rightMetrics.first.value : 0.0;

    return KnightComparisonResult(
      leftLabel: left.name,
      rightLabel: right.name,
      difference: leftVal - rightVal,
      significance: (leftVal - rightVal).abs() > 10 ? 'Significant' : 'Minor',
    );
  }

  Future<double> correlateProviders(
    KnightAnalyticsProvider left,
    KnightAnalyticsProvider right,
  ) async {
    final leftData = await left.requestHistoricalData();
    final rightData = await right.requestHistoricalData();

    if (leftData.isEmpty || rightData.isEmpty) return 0.0;

    // Simple Pearson Correlation implementation
    return _calculateCorrelation(
      leftData.map((d) => d.value).toList(),
      rightData.map((d) => d.value).toList(),
    );
  }

  double _calculateCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.isEmpty) return 0.0;

    final int n = x.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;

    for (int i = 0; i < n; i++) {
      sumX += x[i];
      sumY += y[i];
      sumXY += x[i] * y[i];
      sumX2 += x[i] * x[i];
      sumY2 += y[i] * y[i];
    }

    final double numerator = (n * sumXY - sumX * sumY);
    final double denominator = math.sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));

    if (denominator == 0) return 0.0;
    return numerator / denominator;
  }

  @override
  Future<void> initialize() async {
    _lifecycleState = KnightModuleLifecycleState.ready;
  }

  @override
  Future<void> start() async {
    _lifecycleState = KnightModuleLifecycleState.running;
    await refreshAnalytics();
  }

  @override
  Future<void> pause() async {
    _lifecycleState = KnightModuleLifecycleState.paused;
  }

  @override
  Future<void> dispose() async {
    _providers.clear();
    _snapshots.clear();
    _lifecycleState = KnightModuleLifecycleState.disposed;
  }
}

/// Default implementation of analytics aggregation.
class DefaultAnalyticsAggregator implements KnightAnalyticsAggregator {
  @override
  Future<KnightAnalyticsSnapshot> aggregate(
    String moduleId,
    KnightAnalyticsTimeRange timeRange,
    List<KnightHistoricalDataPoint> history,
    List<KnightMetric> metrics,
  ) async {
    double sum = 0;
    for (final p in history) {
      sum += p.value;
    }
    final average = history.isEmpty ? 0.0 : sum / history.length;

    // Basic trend detection
    KnightAnalyticsTrendDirection direction = KnightAnalyticsTrendDirection.stable;
    double slope = 0;
    if (history.length >= 2) {
      final first = history.first.value;
      final last = history.last.value;
      slope = (last - first) / history.length;
      if (slope > 0.1) {
        direction = KnightAnalyticsTrendDirection.increasing;
      } else if (slope < -0.1) {
        direction = KnightAnalyticsTrendDirection.decreasing;
      }
    }

    return KnightAnalyticsSnapshot(
      moduleId: moduleId,
      timeRange: timeRange,
      metrics: metrics,
      trend: KnightTrend(
        direction: direction,
        slope: slope,
        confidence: 0.8,
        period: timeRange,
      ),
      average: average,
      summary: 'Analysis complete for $moduleId.',
      timestamp: DateTime.now(),
    );
  }
}
