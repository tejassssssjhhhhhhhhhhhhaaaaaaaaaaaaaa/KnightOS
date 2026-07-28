import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Types of edges in the Knowledge Graph.
enum MemoryRelationType {
  /// Higher-level classification (e.g. Salary -> Finance).
  partOf,

  /// Casual link (e.g. Cold Weather -> Low Energy).
  causedBy,

  /// Impact link (e.g. Promotion -> New Budget).
  influences,

  /// Narrative sequence (e.g. Workout -> Protein Shake).
  followedBy,

  /// Logical contradiction or conflict.
  conflictsWith,

  /// Semantic similarity.
  relatesTo,

  /// Temporal sequence.
  happensBefore,
  happensAfter,

  /// Logical support.
  supports,

  /// Causal link (positive).
  improves,

  /// Causal link (negative).
  worsens,

  /// Spatial link.
  locatedAt,

  /// Structural dependency.
  dependsOn,

  /// Observational correlation.
  frequentlyOccursWith,
}

/// Represents an edge in the Knowledge Graph.
@immutable
class MemoryRelation {
  MemoryRelation({
    String? id,
    required this.sourceId,
    required this.targetId,
    required this.type,
    this.strength = 1.0,
    this.metadata = const {},
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  final String id;
  final String sourceId;
  final String targetId;
  final MemoryRelationType type;
  final double strength;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceId': sourceId,
      'targetId': targetId,
      'type': type.name,
      'strength': strength,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MemoryRelation.fromJson(Map<String, dynamic> json) {
    return MemoryRelation(
      id: json['id'] as String,
      sourceId: json['sourceId'] as String,
      targetId: json['targetId'] as String,
      type: MemoryRelationType.values.byName(json['type'] as String),
      strength: (json['strength'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
