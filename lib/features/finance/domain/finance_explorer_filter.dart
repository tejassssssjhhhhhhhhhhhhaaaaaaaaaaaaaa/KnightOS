import 'package:flutter/material.dart';

enum TransactionSort {
  newest,
  oldest,
  highestAmount,
  lowestAmount,
  highestConfidence,
  institution,
  merchant,
}

class ExplorerFilter {
  final DateTimeRange? dateRange;
  final List<String> categories;
  final List<String> merchants;
  final List<String> institutions;
  final List<String> paymentMethods;
  final List<String> types; // income, expense, etc.
  final double? minAmount;
  final double? maxAmount;
  final double? minConfidence;
  final String searchQuery;
  final TransactionSort sort;

  ExplorerFilter({
    this.dateRange,
    this.categories = const [],
    this.merchants = const [],
    this.institutions = const [],
    this.paymentMethods = const [],
    this.types = const [],
    this.minAmount,
    this.maxAmount,
    this.minConfidence,
    this.searchQuery = '',
    this.sort = TransactionSort.newest,
  });

  ExplorerFilter copyWith({
    DateTimeRange? dateRange,
    List<String>? categories,
    List<String>? merchants,
    List<String>? institutions,
    List<String>? paymentMethods,
    List<String>? types,
    double? minAmount,
    double? maxAmount,
    double? minConfidence,
    String? searchQuery,
    TransactionSort? sort,
  }) {
    return ExplorerFilter(
      dateRange: dateRange ?? this.dateRange,
      categories: categories ?? this.categories,
      merchants: merchants ?? this.merchants,
      institutions: institutions ?? this.institutions,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      types: types ?? this.types,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      minConfidence: minConfidence ?? this.minConfidence,
      searchQuery: searchQuery ?? this.searchQuery,
      sort: sort ?? this.sort,
    );
  }
}
