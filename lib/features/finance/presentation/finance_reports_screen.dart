import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import 'controllers/finance_report_controller.dart';
import 'widgets/finance_report_widgets.dart';

class FinanceReportsScreen extends ConsumerWidget {
  const FinanceReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financeReportProvider);
    final archiveAsync = ref.watch(financeReportArchiveProvider);

    return KnightPageScaffold(
      title: 'Reports & Export',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('GENERATE NEW REPORT', style: KnightTokens.label),
          const SizedBox(height: 16),
          ReportTypeGrid(
            onTypeSelected: (type) => ref.read(financeReportProvider.notifier).generateReport(type),
          ),
          const SizedBox(height: 32),
          if (state.activeReport != null) ...[
            const Text('REPORT PREVIEW', style: KnightTokens.label),
            const SizedBox(height: 16),
            ReportPreviewCard(
              summary: state.activeReport!,
              onExport: (format) => ref.read(financeReportProvider.notifier).export(format),
            ),
            const SizedBox(height: 32),
          ],
          const Text('REPORT ARCHIVE', style: KnightTokens.label),
          const SizedBox(height: 16),
          archiveAsync.when(
            data: (reports) => reports.isEmpty 
              ? const Center(child: Text('No saved reports.', style: TextStyle(color: Colors.white24)))
              : Column(children: reports.map((r) => ReportArchiveTile(report: r)).toList()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text('Archive Error: $e'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
