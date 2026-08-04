import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/finance_report_models.dart';
import '../../platform/providers/finance_platform_providers.dart';
import '../../../../core/providers/database_provider.dart';
import '../../platform/sync/finance_report_service.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

final financeReportServiceProvider = Provider<FinanceReportService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = ref.watch(financePlatformDaoProvider);
  return FinanceReportService(db: db, dao: dao);
});

final financeReportArchiveProvider = FutureProvider<List<FinanceReportData>>((ref) async {
  final dao = ref.watch(financePlatformDaoProvider);
  return dao.getAllReports();
});

class FinanceReportState {
  final ReportSummary? activeReport;
  final bool isGenerating;
  final ReportFilters filters;

  FinanceReportState({
    this.activeReport,
    this.isGenerating = false,
    required this.filters,
  });

  FinanceReportState copyWith({
    ReportSummary? activeReport,
    bool? isGenerating,
    ReportFilters? filters,
  }) {
    return FinanceReportState(
      activeReport: activeReport ?? this.activeReport,
      isGenerating: isGenerating ?? this.isGenerating,
      filters: filters ?? this.filters,
    );
  }
}

class FinanceReportController extends Notifier<FinanceReportState> {
  @override
  FinanceReportState build() {
    return FinanceReportState(filters: ReportFilters());
  }

  Future<void> generateReport(ReportType type) async {
    state = state.copyWith(isGenerating: true);
    final service = ref.read(financeReportServiceProvider);
    
    try {
      final summary = await service.generateSummary(type, state.filters);
      state = state.copyWith(activeReport: summary, isGenerating: false);
    } catch (e) {
      state = state.copyWith(isGenerating: false);
    }
  }

  Future<void> export(String format) async {
    if (state.activeReport == null) return;
    final service = ref.read(financeReportServiceProvider);
    await service.exportReport(state.activeReport!, format);
    ref.invalidate(financeReportArchiveProvider);
  }

  void updateFilters(ReportFilters filters) {
    state = state.copyWith(filters: filters);
  }
}

final financeReportProvider = NotifierProvider<FinanceReportController, FinanceReportState>(
  FinanceReportController.new,
);
