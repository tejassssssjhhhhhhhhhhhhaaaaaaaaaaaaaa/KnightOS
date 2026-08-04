import 'package:flutter/material.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../domain/finance_report_models.dart';

class ReportTypeGrid extends StatelessWidget {
  const ReportTypeGrid({super.key, required this.onTypeSelected});
  final Function(ReportType) onTypeSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: ReportType.values.length,
      itemBuilder: (context, index) {
        final type = ReportType.values[index];
        return InkWell(
          onTap: () => onTypeSelected(type),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getIconForType(type),
                const SizedBox(height: 8),
                Text(
                  type.name.toUpperCase(),
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getIconForType(ReportType type) {
    IconData icon;
    switch (type) {
      case ReportType.monthly: icon = Icons.calendar_view_month_rounded; break;
      case ReportType.income: icon = Icons.trending_up_rounded; break;
      case ReportType.expense: icon = Icons.trending_down_rounded; break;
      case ReportType.taxSummary: icon = Icons.receipt_long_rounded; break;
      default: icon = Icons.description_rounded;
    }
    return Icon(icon, size: 20, color: Colors.blueAccent);
  }
}

class ReportPreviewCard extends StatelessWidget {
  const ReportPreviewCard({super.key, required this.summary, required this.onExport});
  final ReportSummary summary;
  final Function(String) onExport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: KnightTokens.glass(accentColor: Colors.blueAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(summary.title, style: KnightTokens.subheadline),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(label: 'INCOME', value: '₹${summary.totalIncome.toStringAsFixed(0)}', color: Colors.greenAccent),
              _Stat(label: 'EXPENSES', value: '₹${summary.totalExpenses.toStringAsFixed(0)}', color: Colors.redAccent),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          _ExplainabilityRow(label: 'EVIDENCE', value: summary.dataCoverage),
          _ExplainabilityRow(label: 'CONFIDENCE', value: '${(summary.confidenceScore * 100).toInt()}%'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _ExportButton(label: 'PDF', icon: Icons.picture_as_pdf_rounded, onTap: () => onExport('pdf'))),
              const SizedBox(width: 8),
              Expanded(child: _ExportButton(label: 'CSV', icon: Icons.grid_on_rounded, onTap: () => onExport('csv'))),
              const SizedBox(width: 8),
              Expanded(child: _ExportButton(label: 'EXCEL', icon: Icons.table_chart_rounded, onTap: () => onExport('xlsx'))),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: KnightTokens.label.copyWith(fontSize: 8)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }
}

class _ExplainabilityRow extends StatelessWidget {
  const _ExplainabilityRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label:', style: KnightTokens.label.copyWith(fontSize: 7, color: Colors.white24)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 9, color: Colors.white38)),
        ],
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }
}

class ReportArchiveTile extends StatelessWidget {
  const ReportArchiveTile({super.key, required this.report});
  final FinanceReportData report;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, size: 16, color: Colors.white24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(
                  'Generated ${report.generatedAt.day}/${report.generatedAt.month}/${report.generatedAt.year}',
                  style: const TextStyle(fontSize: 8, color: Colors.white24),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_rounded, size: 16, color: Colors.blueAccent),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, size: 16, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
