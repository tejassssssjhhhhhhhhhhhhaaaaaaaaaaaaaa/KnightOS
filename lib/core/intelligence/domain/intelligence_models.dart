import 'package:flutter/foundation.dart';
import 'cognitive_models.dart';

/// Represents a versioned intelligence result produced by the platform.
@immutable
class IntelligenceResult<T> {
  const IntelligenceResult({
    required this.id,
    required this.data,
    required this.trace,
    required this.generatedAt,
    required this.version,
    required this.evidenceHash,
    this.feedback,
  });

  /// Unique identifier for this specific intelligence item.
  final String id;

  /// The concrete payload (e.g. DailyBriefing, Prediction, Insight).
  final T data;

  /// The layered reasoning trace that produced this result.
  final ReasoningTrace trace;

  /// When this intelligence was synthesized.
  final DateTime generatedAt;

  /// Incremental version of the reasoning logic.
  final int version;

  /// SHA-256 hash of the evidence subset used for this result.
  final String evidenceHash;

  /// User feedback on this specific result.
  final IntelligenceFeedback? feedback;

  IntelligenceResult<T> copyWith({
    T? data,
    ReasoningTrace? trace,
    IntelligenceFeedback? feedback,
  }) {
    return IntelligenceResult<T>(
      id: id,
      data: data ?? this.data,
      trace: trace ?? this.trace,
      generatedAt: generatedAt,
      version: version,
      evidenceHash: evidenceHash,
      feedback: feedback ?? this.feedback,
    );
  }
}

/// User feedback for refining Knight's prioritization.
enum IntelligenceFeedback {
  helpful,
  notHelpful,
  incorrect,
  alreadyDone,
  ignore,
}

/// Represents a milestone in Knight's evolving understanding.
@immutable
class IntelligenceTimelineEntry {
  const IntelligenceTimelineEntry({
    required this.id,
    required this.title,
    required this.summary,
    required this.timestamp,
    required this.type,
    required this.confidence,
    required this.evidenceIds,
  });

  final String id;
  final String title;
  final String summary;
  final DateTime timestamp;
  final IntelligenceEntryType type;
  final double confidence;
  final List<String> evidenceIds;
}

enum IntelligenceEntryType {
  patternDiscovered,
  stateInferred,
  missionUpdated,
  correctionReceived,
  factConfirmed,
}
