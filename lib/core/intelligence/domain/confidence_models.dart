import 'package:flutter/foundation.dart';

/// Explicit levels of knowledge verification.
enum VerificationState {
  /// Raw data just extracted from a source.
  unverified,

  /// Pattern-matched or highly frequent data that has not been confirmed.
  likely,

  /// System-verified via multiple sources or strict rules.
  verified,

  /// Explicitly confirmed by the user in the UI.
  userConfirmed,

  /// Explicitly marked as wrong by the user.
  refuted,
}

/// Structured metadata for intelligence confidence.
@immutable
class ConfidenceMetadata {
  const ConfidenceMetadata({
    required this.score,
    required this.state,
    required this.reason,
    this.verifiedAt,
  });

  /// 0.0 (Pure guess) to 1.0 (Absolute certainty).
  final double score;

  /// Semantic verification status.
  final VerificationState state;

  /// Human-readable explanation of why this score was assigned.
  final String reason;

  /// Timestamp of the last verification event.
  final DateTime? verifiedAt;

  Map<String, dynamic> toJson() => {
    'score': score,
    'state': state.name,
    'reason': reason,
    'verifiedAt': verifiedAt?.toIso8601String(),
  };

  factory ConfidenceMetadata.fromJson(Map<String, dynamic> json) => ConfidenceMetadata(
    score: (json['score'] as num?)?.toDouble() ?? 0.0,
    state: VerificationState.values.firstWhere((e) => e.name == json['state'], orElse: () => VerificationState.unverified),
    reason: json['reason'] as String? ?? 'Extracted from source',
    verifiedAt: json['verifiedAt'] != null ? DateTime.tryParse(json['verifiedAt'] as String) : null,
  );
}
