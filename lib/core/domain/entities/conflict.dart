import 'package:equatable/equatable.dart';

enum ConflictType {
  timeOverlap,
  energyOverload,
  priorityMismatch,
  dependencyViolation,
}

/// Represents a collision between two or more life goals or missions.
class Conflict extends Equatable {
  const Conflict({
    required this.id,
    required this.type,
    required this.description,
    required this.involvedMissionIds,
    this.severity = 5, // 1-10
  });

  final String id;
  final ConflictType type;
  final String description;
  final List<String> involvedMissionIds;
  final int severity;

  @override
  List<Object?> get props => [id, type, description, involvedMissionIds, severity];
}

/// A proposed solution to a conflict.
class Resolution extends Equatable {
  const Resolution({
    required this.id,
    required this.conflictId,
    required this.description,
    required this.actionPlan,
  });

  final String id;
  final String conflictId;
  final String description;
  final List<String> actionPlan;

  @override
  List<Object?> get props => [id, conflictId, description, actionPlan];
}
