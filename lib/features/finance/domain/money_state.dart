import 'package:flutter/foundation.dart';
import 'money_metric.dart';

/// Represents the overall state of the Money feature.
@immutable
class MoneyState {
  const MoneyState({required this.metrics, this.netPosition = 0.0});

  /// List of financial metrics.
  final List<MoneyMetric> metrics;

  /// Calculated net position (e.g. Income - Expenses).
  final double netPosition;

  /// Creates a copy of this state with the given fields replaced.
  MoneyState copyWith({List<MoneyMetric>? metrics, double? netPosition}) {
    return MoneyState(
      metrics: metrics ?? this.metrics,
      netPosition: netPosition ?? this.netPosition,
    );
  }
}
