import 'package:equatable/equatable.dart';

/// Represents a step in the reasoning process of Knight Intelligence.
class LogicStep extends Equatable {
  const LogicStep({
    required this.description,
    this.evidenceIds = const [],
  });

  final String description;
  final List<String> evidenceIds;

  @override
  List<Object?> get props => [description, evidenceIds];
}

/// The trace of how an AI insight was generated.
class ReasoningPath extends Equatable {
  const ReasoningPath({
    required this.steps,
    this.assumptions = const [],
    this.risks = const [],
    this.missingInformation = const [],
  });

  final List<LogicStep> steps;
  final List<String> assumptions;
  final List<String> risks;
  final List<String> missingInformation;

  @override
  List<Object?> get props => [steps, assumptions, risks, missingInformation];
}

/// A qualitative confidence level for an AI insight.
enum ConfidenceLevel {
  low,
  medium,
  high,
  veryHigh,
}

/// An explainable recommendation or prediction from Knight Intelligence.
class Insight extends Equatable {
  const Insight({
    required this.id,
    required this.title,
    required this.recommendation,
    required this.confidence,
    required this.reasoningPath,
    this.suggestedActions = const [],
    required this.createdAt,
    this.metadata = const {},
  });

  final String id;
  final String title;
  final String recommendation;
  final ConfidenceLevel confidence;
  final ReasoningPath reasoningPath;
  final List<String> suggestedActions;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  @override
  List<Object?> get props => [
        id,
        title,
        recommendation,
        confidence,
        reasoningPath,
        suggestedActions,
        createdAt,
        metadata,
      ];
}
