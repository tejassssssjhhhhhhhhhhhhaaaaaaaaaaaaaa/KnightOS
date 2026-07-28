import 'package:flutter/foundation.dart';

/// Types of changes in the memory evolution chain.
enum ChangeType {
  creation,
  correction,
  evolution,
  refinement,
  conflictResolution,
}

/// Temporal metadata for tracking the evolution of a fact.
@immutable
class MemoryVersion {
  const MemoryVersion({
    required this.versionNumber,
    this.previousVersionId,
    required this.changeType,
    this.reasoning,
    this.delta = const {},
  });

  /// Incremental version number.
  final int versionNumber;

  /// Pointer to the predecessor version ID.
  final String? previousVersionId;

  /// The nature of the change.
  final ChangeType changeType;

  /// Logical justification for the update.
  final String? reasoning;

  /// Map of changed fields for auditability.
  final Map<String, dynamic> delta;

  MemoryVersion copyWith({
    int? versionNumber,
    String? previousVersionId,
    ChangeType? changeType,
    String? reasoning,
    Map<String, dynamic>? delta,
  }) {
    return MemoryVersion(
      versionNumber: versionNumber ?? this.versionNumber,
      previousVersionId: previousVersionId ?? this.previousVersionId,
      changeType: changeType ?? this.changeType,
      reasoning: reasoning ?? this.reasoning,
      delta: delta ?? this.delta,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'versionNumber': versionNumber,
      'previousVersionId': previousVersionId,
      'changeType': changeType.name,
      'reasoning': reasoning,
      'delta': delta,
    };
  }

  factory MemoryVersion.fromJson(Map<String, dynamic> json) {
    return MemoryVersion(
      versionNumber: json['versionNumber'] as int,
      previousVersionId: json['previousVersionId'] as String?,
      changeType: ChangeType.values.byName(json['changeType'] as String),
      reasoning: json['reasoning'] as String?,
      delta: json['delta'] as Map<String, dynamic>,
    );
  }
}
