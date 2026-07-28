/// Contracts for the generic KnightOS analytics platform.
///
/// These interfaces enable future modules to expose analytics inputs without the
/// analytics engine needing feature-specific knowledge.
library;

import 'analytics_models.dart';
import 'scoring_models.dart';

/// Contract for an analytics provider that can supply a time series.
abstract class KnightAnalyticsProvider {
  /// Stable identifier for the provider.
  String get id;

  /// Human-readable name used for diagnostics.
  String get name;

  /// Returns the module identifier represented by the provider.
  String get moduleId;

  /// Requests historical data from the provider.
  Future<List<KnightHistoricalDataPoint>> requestHistoricalData();

  /// Requests the latest metric values from the provider.
  Future<List<KnightMetric>> requestMetrics();

  /// Requests score history, if available.
  Future<List<KnightScoreValue>> requestScoreHistory();
}

/// Contract for aggregating analytics results.
abstract class KnightAnalyticsAggregator {
  /// Produces an analytics snapshot from historical data and metrics.
  Future<KnightAnalyticsSnapshot> aggregate(
    String moduleId,
    KnightAnalyticsTimeRange timeRange,
    List<KnightHistoricalDataPoint> history,
    List<KnightMetric> metrics,
  );
}

/// Contract for a read-only analytics store.
abstract class KnightAnalyticsStore {
  /// Returns available analytics snapshots.
  Future<List<KnightAnalyticsSnapshot>> getSnapshots();
}
