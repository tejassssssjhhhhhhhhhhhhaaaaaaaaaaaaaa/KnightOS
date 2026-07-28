import 'package:flutter/material.dart';

/// Categories for recovery metrics.
enum RecoveryCategory {
  /// Sleep quality and duration.
  sleep,

  /// Energy levels and readiness.
  energy,

  /// Stress and recovery balance.
  stress;

  /// Returns the localized label for the category.
  String get label {
    switch (this) {
      case RecoveryCategory.sleep:
        return 'Sleep';
      case RecoveryCategory.energy:
        return 'Energy';
      case RecoveryCategory.stress:
        return 'Stress';
    }
  }

  /// Returns the representative icon for the category.
  IconData get icon {
    switch (this) {
      case RecoveryCategory.sleep:
        return Icons.bedtime_rounded;
      case RecoveryCategory.energy:
        return Icons.bolt_rounded;
      case RecoveryCategory.stress:
        return Icons.psychology_rounded;
    }
  }
}

/// Represents a specific recovery metric.
@immutable
class RecoveryMetric {
  const RecoveryMetric({
    required this.category,
    required this.value,
    required this.unit,
    required this.status,
    this.isAiOptimized = false,
    required this.lastUpdated,
  });

  /// The category of this metric.
  final RecoveryCategory category;

  /// The current numerical value.
  final double value;

  /// The unit of measurement (e.g., '%').
  final String unit;

  /// High-level status text (e.g., 'Restored').
  final String status;

  /// Whether this metric is currently being optimized by AI logic.
  final bool isAiOptimized;

  /// Timestamp of the last update.
  final DateTime lastUpdated;

  /// Creates a copy of this metric with the given fields replaced.
  RecoveryMetric copyWith({
    double? value,
    String? unit,
    String? status,
    bool? isAiOptimized,
    DateTime? lastUpdated,
  }) {
    return RecoveryMetric(
      category: category,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      isAiOptimized: isAiOptimized ?? this.isAiOptimized,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Converts the metric to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'category': category.name,
      'value': value,
      'unit': unit,
      'status': status,
      'isAiOptimized': isAiOptimized,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Creates a [RecoveryMetric] from a JSON map.
  factory RecoveryMetric.fromJson(Map<String, dynamic> json) {
    return RecoveryMetric(
      category: RecoveryCategory.values.byName(json['category'] as String),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      status: json['status'] as String,
      isAiOptimized: json['isAiOptimized'] as bool? ?? false,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Centralized initial metrics for the recovery section.
  static List<RecoveryMetric> get defaults => [
    RecoveryMetric(
      category: RecoveryCategory.sleep,
      value: 85,
      unit: '%',
      status: 'Restorative',
      lastUpdated: DateTime.now(),
    ),
    RecoveryMetric(
      category: RecoveryCategory.energy,
      value: 72,
      unit: '%',
      status: 'Optimal',
      isAiOptimized: true,
      lastUpdated: DateTime.now(),
    ),
    RecoveryMetric(
      category: RecoveryCategory.stress,
      value: 24,
      unit: '%',
      status: 'Low',
      lastUpdated: DateTime.now(),
    ),
  ];
}
