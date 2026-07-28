import 'package:flutter/foundation.dart';
import 'focus_area.dart';

/// Represents the functional state of a specific focus area.
@immutable
class FocusState {
  const FocusState({
    required this.category,
    required this.completionProgress,
    required this.status,
    required this.lastUpdated,
  });

  /// The category this state applies to.
  final FocusCategory category;

  /// Progress from 0.0 to 1.0.
  final double completionProgress;

  /// High-level status text.
  final String status;

  /// Timestamp of the last update.
  final DateTime lastUpdated;

  FocusState copyWith({
    double? completionProgress,
    String? status,
    DateTime? lastUpdated,
  }) {
    return FocusState(
      category: category,
      completionProgress: completionProgress ?? this.completionProgress,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
