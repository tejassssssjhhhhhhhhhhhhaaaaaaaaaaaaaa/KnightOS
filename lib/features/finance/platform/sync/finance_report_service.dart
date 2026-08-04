import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../domain/finance_report_models.dart';

class FinanceReportService {
  FinanceReportService({required this.db, required this.dao});

  final KnightDatabase db;
  final FinancePlatformDao dao;

  Future<ReportSummary> generateSummary(ReportType type, ReportFilters filters) async {
    final txs = await dao.searchTransactions(
      start: filters.startDate,
      end: filters.endDate,
      categories: filters.categories ?? [],
    );

    double income = 0;
    double expense = 0;
    final categoryMap = <String, double>{};
    final merchantMap = <String, double>{};

    for (final tx in txs) {
      if (tx.type == 'income') {
        income += tx.amount;
      } else if (tx.type == 'expense') {
        expense += tx.amount;
        categoryMap[tx.category] = (categoryMap[tx.category] ?? 0) + tx.amount;
        merchantMap[tx.merchant] = (merchantMap[tx.merchant] ?? 0) + tx.amount;
      }
    }

    return ReportSummary(
      title: _getReportTitle(type, filters),
      totalIncome: income,
      totalExpenses: expense,
      categoryBreakdown: categoryMap,
      merchantBreakdown: merchantMap,
      confidenceScore: _calculateConfidence(txs),
      dataCoverage: '${txs.length} verified records analyzed',
      transactions: txs,
    );
  }

  Future<String> exportReport(ReportSummary summary, String format) async {
    // Placeholder for actual file generation (PDF/CSV/Excel)
    // In a real app, this would use 'pdf' or 'excel' packages.
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '/storage/reports/finance_report_$timestamp.$format';
    
    // Logic to write file would go here
    
    await dao.insertReport(FinanceReportTableCompanion(
      id: Value(timestamp.toString()),
      name: Value(summary.title),
      type: Value('custom'),
      generatedAt: Value(DateTime.now()),
      filters: Value(jsonEncode({})),
      filePath: Value(path),
      confidenceScore: Value(summary.confidenceScore),
      dataCoverage: Value(summary.dataCoverage),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      version: const Value(1),
      syncStatus: const Value('local'),
      isDeleted: const Value(false),
    ));

    return path;
  }

  String _getReportTitle(ReportType type, ReportFilters filters) {
    final dateStr = filters.startDate != null ? '${filters.startDate!.month}/${filters.startDate!.year}' : 'All Time';
    return '${type.name.toUpperCase()} Report - $dateStr';
  }

  double _calculateConfidence(List<TransactionData> txs) {
    if (txs.isEmpty) return 1.0;
    final verifiedCount = txs.where((t) => t.verificationState == 'VERIFIED').length;
    return (verifiedCount / txs.length).clamp(0.0, 1.0);
  }
}
