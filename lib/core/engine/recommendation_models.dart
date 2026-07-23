/// Immutable recommendation models for the KnightOS engine platform.
///
/// These models provide a generic, strongly typed vocabulary that future modules
/// can use to surface recommendations without embedding feature-specific logic
/// in the recommendation engine itself.
library;

/// Priority levels for surfaced recommendations.
enum KnightRecommendationPriority {
  /// Lowest priority.
  low,

  /// Medium priority.
  medium,

  /// High priority.
  high,

  /// Critical priority.
  critical,
}

/// Broad category of a recommendation.
enum KnightRecommendationCategory {
  /// A suggestion related to productivity or work.
  work,

  /// A suggestion related to rest.
  sleep,

  /// A suggestion related to physical activity.
  fitness,

  /// A suggestion related to finances.
  finance,

  /// A suggestion related to learning.
  learning,

  /// A suggestion related to health.
  health,

  /// A suggestion related to habits or routine.
  habits,

  /// A suggestion related to goals.
  goals,

  /// A suggestion related to travel.
  travel,

  /// A generic category for future extension.
  custom,
}

/// Confidence of a recommendation.
class KnightRecommendationConfidence {
  /// Creates an immutable confidence value object.
  const KnightRecommendationConfidence({required this.value});

  /// Confidence in the range $[0.0, 1.0]$.
  final double value;
}

/// Reason supporting the recommendation.
class KnightRecommendationReason {
  /// Creates an immutable reason.
  const KnightRecommendationReason({required this.summary, this.detail});

  /// Short summary of why the recommendation exists.
  final String summary;

  /// Optional detailed explanation.
  final String? detail;
}

/// Source descriptor for the recommendation.
class KnightRecommendationSource {
  /// Creates an immutable source descriptor.
  const KnightRecommendationSource({required this.name, this.version});

  /// Name of the generating source.
  final String name;

  /// Optional source version.
  final String? version;
}

/// Action to be taken when a recommendation is surfaced.
class KnightRecommendationAction {
  /// Creates an immutable action payload.
  const KnightRecommendationAction({required this.label, this.target});

  /// Short label for user-facing action.
  final String label;

  /// Optional target or route identifier for the action.
  final String? target;
}

/// Immutable recommendation model.
class KnightRecommendation {
  /// Creates an immutable recommendation.
  const KnightRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.confidence,
    required this.reason,
    required this.source,
    required this.action,
    required this.timestamp,
  });

  /// Unique identifier for the recommendation.
  final String id;

  /// Title shown to the user.
  final String title;

  /// Description of the recommendation.
  final String description;

  /// Category for the recommendation.
  final KnightRecommendationCategory category;

  /// Priority for the recommendation.
  final KnightRecommendationPriority priority;

  /// Confidence of the recommendation.
  final KnightRecommendationConfidence confidence;

  /// Reason supporting the recommendation.
  final KnightRecommendationReason reason;

  /// Source that created the recommendation.
  final KnightRecommendationSource source;

  /// Suggested action.
  final KnightRecommendationAction action;

  /// Timestamp when the recommendation was created.
  final DateTime timestamp;
}

/// Immutable snapshot of the recommendation state.
class KnightRecommendationSnapshot {
  /// Creates an immutable recommendation snapshot.
  const KnightRecommendationSnapshot({
    required this.timestamp,
    required this.items,
  });

  /// Timestamp when the snapshot was created.
  final DateTime timestamp;

  /// Recommendations captured in the snapshot.
  final List<KnightRecommendation> items;
}
