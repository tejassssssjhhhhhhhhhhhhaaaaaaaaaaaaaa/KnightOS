import 'package:flutter/foundation.dart';

/// Represents a learned optimization derived from user feedback or outcomes.
@immutable
class KnightLesson {
  const KnightLesson({
    required this.id,
    required this.targetDomain,
    required this.feedbackType,
    required this.adjustmentFactor,
    required this.reasoning,
    required this.timestamp,
  });

  final String id;
  final String targetDomain; // e.g. "work", "fitness"
  final String feedbackType; // "helpful", "incorrect"
  final double adjustmentFactor; // -1.0 to 1.0
  final String reasoning;
  final DateTime timestamp;
}

/// Consolidated state of the OS self-improvement system.
@immutable
class OptimizationState {
  const OptimizationState({
    required this.domainWeights,
    required this.lessonsLearned,
  });

  /// Map of domain IDs to their current priority weight multiplier.
  final Map<String, double> domainWeights;

  final List<KnightLesson> lessonsLearned;
}
