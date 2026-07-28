/// Contracts for the generic KnightOS recommendation platform.
///
/// These interfaces allow future modules to expose recommendation inputs
/// without the recommendation engine needing feature-specific implementation
/// knowledge.
library;

import 'analytics_models.dart';
import 'recommendation_models.dart';
import 'scoring_models.dart';

/// Contract for a provider that can contribute recommendations.
abstract class KnightRecommendationProvider {
  /// Stable identifier for the provider.
  String get id;

  /// Human-readable name used for diagnostics.
  String get name;

  /// Returns the module identifier associated with the provider.
  String get moduleId;

  /// Requests recommendations from the provider using typed engine context.
  Future<List<KnightRecommendation>> requestRecommendations({
    required List<KnightScoreValue> scores,
    required List<KnightAnalyticsSnapshot> analytics,
  });
}

/// Contract for ordering recommendations.
abstract class KnightRecommendationPrioritizer {
  /// Orders recommendations by priority and relevance.
  List<KnightRecommendation> prioritize(List<KnightRecommendation> items);
}

/// Contract for filtering recommendations.
abstract class KnightRecommendationFilter {
  /// Filters the supplied recommendations according to platform policy.
  List<KnightRecommendation> filter(List<KnightRecommendation> items);
}

/// Contract for storing recommendation history and interaction state.
abstract class KnightRecommendationHistoryStore {
  /// Returns recommendation history.
  Future<List<KnightRecommendation>> getHistory();

  /// Records a recommendation as dismissed.
  Future<void> dismiss(String recommendationId);

  /// Records a recommendation as completed.
  Future<void> complete(String recommendationId);
}
