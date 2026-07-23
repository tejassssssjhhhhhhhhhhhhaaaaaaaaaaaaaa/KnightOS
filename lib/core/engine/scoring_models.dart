/// Immutable models for the KnightOS scoring system.
///
/// These types provide the strongly typed vocabulary for score inputs and
/// snapshots without implementing any real scoring logic.
library;

/// Extensible score categories that can be used by future feature modules.
enum KnightScoreCategory {
  /// Work-related contributions and productivity.
  work,

  /// Sleep quality and consistency.
  sleep,

  /// Fitness and activity progress.
  fitness,

  /// Financial health and balance.
  finance,

  /// Learning and personal development.
  learning,

  /// General health and wellbeing.
  health,

  /// A custom category for future extension.
  custom,
}

/// Immutable grade value object for score presentation.
class KnightScoreGrade {
  /// Creates a typed grade value object.
  const KnightScoreGrade({required this.label, required this.rank});

  /// Short display label for the grade.
  final String label;

  /// Numeric rank used for ordering or comparison.
  final int rank;
}

/// Immutable confidence value object for score certainty.
class KnightScoreConfidence {
  /// Creates a typed confidence value object.
  const KnightScoreConfidence({required this.value});

  /// Confidence in the range $[0.0, 1.0]$.
  final double value;
}

/// Immutable source descriptor for score provenance.
class KnightScoreSource {
  /// Creates a typed source descriptor.
  const KnightScoreSource({required this.name, this.version});

  /// Stable identifier or display name for the source.
  final String name;

  /// Optional version of the source implementation.
  final String? version;
}

/// Immutable score value object.
class KnightScoreValue {
  /// Creates an immutable score value object.
  const KnightScoreValue({
    required this.value,
    required this.category,
    required this.grade,
    required this.confidence,
    required this.timestamp,
    required this.source,
  });

  /// Raw numeric score value.
  final double value;

  /// Category to which the score belongs.
  final KnightScoreCategory category;

  /// Grade assigned to the score.
  final KnightScoreGrade grade;

  /// Confidence of the score input.
  final KnightScoreConfidence confidence;

  /// Timestamp for the score snapshot.
  final DateTime timestamp;

  /// Source descriptor for the score.
  final KnightScoreSource source;
}

/// Immutable snapshot of the aggregated scoring result.
class KnightScoreSnapshot {
  /// Creates an immutable scoring snapshot.
  const KnightScoreSnapshot({
    required this.category,
    required this.value,
    required this.grade,
    required this.confidence,
    required this.timestamp,
    required this.sources,
  });

  /// Category represented by the snapshot.
  final KnightScoreCategory category;

  /// Aggregated numeric score value.
  final double value;

  /// Aggregated grade.
  final KnightScoreGrade grade;

  /// Aggregated confidence.
  final KnightScoreConfidence confidence;

  /// Timestamp of the snapshot.
  final DateTime timestamp;

  /// Sources contributing to the snapshot.
  final List<KnightScoreValue> sources;
}
