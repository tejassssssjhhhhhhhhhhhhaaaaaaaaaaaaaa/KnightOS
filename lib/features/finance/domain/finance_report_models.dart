import '../../../../core/internal/storage/drift/knight_database.dart';

enum ReportType {
  monthly,
  quarterly,
  yearly,
  income,
  expense,
  category,
  merchant,
  investment,
  loan,
  insurance,
  taxSummary,
  budget,
  goalProgress
}

class ReportFilters {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? categories;
  final List<String>? merchants;
  final List<String>? accounts;
  final List<String>? institutions;

  ReportFilters({
    this.startDate,
    this.endDate,
    this.categories,
    this.merchants,
    this.accounts,
    this.institutions,
  });

  Map<String, dynamic> toJson() => {
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'categories': categories,
    'merchants': merchants,
    'accounts': accounts,
    'institutions': institutions,
  };
}

class ReportSummary {
  final String title;
  final double totalIncome;
  final double totalExpenses;
  final Map<String, double> categoryBreakdown;
  final Map<String, double> merchantBreakdown;
  final double confidenceScore;
  final String dataCoverage;
  final List<TransactionData> transactions;

  ReportSummary({
    required this.title,
    required this.totalIncome,
    required this.totalExpenses,
    required this.categoryBreakdown,
    required this.merchantBreakdown,
    required this.confidenceScore,
    required this.dataCoverage,
    required this.transactions,
  });
}
