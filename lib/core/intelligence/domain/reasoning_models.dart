import 'package:flutter/foundation.dart';
import 'cognitive_models.dart';
import '../../platform/engine/recommendation_models.dart';

/// Represents a high-level deduction made by the OS.
@immutable
class KnightInsight {
  const KnightInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.confidence,
    required this.timestamp,
    this.sourceModule,
    this.explanation,
  });

  final String id;
  final String title;
  final String description;
  final double confidence;
  final DateTime timestamp;
  final String? sourceModule;
  final String? explanation;
}

/// The consolidated result of a reasoning cycle.
@immutable
class ReasoningResult {
  const ReasoningResult({
    required this.summary,
    required this.insights,
    required this.recommendations,
    required this.warnings,
    required this.opportunities,
    required this.trace,
  });

  /// Human-readable Situational Report (Daily Summary).
  final String summary;

  /// Logical deductions found during reasoning.
  final List<KnightInsight> insights;

  /// Actionable items for the user.
  final List<KnightRecommendation> recommendations;

  /// Identified risks or immediate issues.
  final List<String> warnings;

  /// Potential growth paths.
  final List<String> opportunities;

  /// The technical trace of how these conclusions were reached.
  final ReasoningTrace trace;
}
