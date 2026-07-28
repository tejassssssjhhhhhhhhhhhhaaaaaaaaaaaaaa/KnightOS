import 'package:flutter/foundation.dart';
import 'recovery_metric.dart';

@immutable
class RecoveryState {
  const RecoveryState({required this.metrics, this.overallScore = 0.0});

  final List<RecoveryMetric> metrics;
  final double overallScore;

  RecoveryState copyWith({
    List<RecoveryMetric>? metrics,
    double? overallScore,
  }) {
    return RecoveryState(
      metrics: metrics ?? this.metrics,
      overallScore: overallScore ?? this.overallScore,
    );
  }
}
