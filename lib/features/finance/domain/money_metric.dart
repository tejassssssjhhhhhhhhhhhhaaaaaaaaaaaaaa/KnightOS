import 'package:flutter/material.dart';

/// Categories for financial metrics.
enum MoneyCategory {
  /// Total income for the period.
  income,

  /// Total expenses for the period.
  expenses,

  /// Total savings accumulated.
  savings,

  /// Budget utilization or remaining.
  budget;

  /// Returns the localized label for the category.
  String get label {
    switch (this) {
      case MoneyCategory.income:
        return 'Income';
      case MoneyCategory.expenses:
        return 'Expenses';
      case MoneyCategory.savings:
        return 'Savings';
      case MoneyCategory.budget:
        return 'Budget';
    }
  }

  /// Returns the representative icon for the category.
  IconData get icon {
    switch (this) {
      case MoneyCategory.income:
        return Icons.account_balance_wallet_rounded;
      case MoneyCategory.expenses:
        return Icons.shopping_cart_rounded;
      case MoneyCategory.savings:
        return Icons.savings_rounded;
      case MoneyCategory.budget:
        return Icons.pie_chart_rounded;
    }
  }
}

/// Represents a specific financial metric.
@immutable
class MoneyMetric {
  const MoneyMetric({
    required this.category,
    required this.amount,
    required this.status,
    this.isAiAnalyzed = false,
    required this.lastUpdated,
  });

  /// The category of this metric.
  final MoneyCategory category;

  /// The current financial amount.
  final double amount;

  /// High-level status text (e.g., 'On track', 'Surplus').
  final String status;

  /// Whether this metric has been analyzed by AI.
  final bool isAiAnalyzed;

  /// Timestamp of the last update.
  final DateTime lastUpdated;

  /// Creates a copy of this metric with the given fields replaced.
  MoneyMetric copyWith({
    double? amount,
    String? status,
    bool? isAiAnalyzed,
    DateTime? lastUpdated,
  }) {
    return MoneyMetric(
      category: category,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      isAiAnalyzed: isAiAnalyzed ?? this.isAiAnalyzed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Converts the metric to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'category': category.name,
      'amount': amount,
      'status': status,
      'isAiAnalyzed': isAiAnalyzed,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Creates a [MoneyMetric] from a JSON map.
  factory MoneyMetric.fromJson(Map<String, dynamic> json) {
    return MoneyMetric(
      category: MoneyCategory.values.byName(json['category'] as String),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      isAiAnalyzed: json['isAiAnalyzed'] as bool? ?? false,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Centralized initial metrics for the money section.
  static List<MoneyMetric> get defaults => [
    MoneyMetric(
      category: MoneyCategory.income,
      amount: 5200.0,
      status: 'Monthly total',
      lastUpdated: DateTime.now(),
    ),
    MoneyMetric(
      category: MoneyCategory.expenses,
      amount: 3100.0,
      status: '12% lower than avg',
      isAiAnalyzed: true,
      lastUpdated: DateTime.now(),
    ),
    MoneyMetric(
      category: MoneyCategory.savings,
      amount: 12500.0,
      status: 'Goal: \$15k',
      lastUpdated: DateTime.now(),
    ),
    MoneyMetric(
      category: MoneyCategory.budget,
      amount: 850.0,
      status: 'Left this week',
      lastUpdated: DateTime.now(),
    ),
  ];
}
