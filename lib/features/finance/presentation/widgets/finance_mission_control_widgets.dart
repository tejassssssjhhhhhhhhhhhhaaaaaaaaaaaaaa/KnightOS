import 'package:flutter/material.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../platform/interfaces/finance_health.dart';

class PlatformStatusGrid extends StatelessWidget {
  const PlatformStatusGrid({super.key, required this.statuses});
  final Map<String, FinanceHealthStatus> statuses;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        final entry = statuses.entries.elementAt(index);
        return _StatusTile(name: entry.key, status: entry.value);
      },
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({required this.name, required this.status});
  final String name;
  final FinanceHealthStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: KnightTokens.glass(accentColor: color, opacity: 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getStatusIcon(status), size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            name.toUpperCase(),
            textAlign: TextAlign.center,
            style: KnightTokens.label.copyWith(fontSize: 7, color: Colors.white38),
          ),
          const SizedBox(height: 4),
          Text(
            status.name.toUpperCase(),
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(FinanceHealthStatus status) {
    switch (status) {
      case FinanceHealthStatus.healthy: return Colors.greenAccent;
      case FinanceHealthStatus.needsAttention: return Colors.orangeAccent;
      case FinanceHealthStatus.actionRequired: return Colors.redAccent;
    }
  }

  IconData _getStatusIcon(FinanceHealthStatus status) {
    switch (status) {
      case FinanceHealthStatus.healthy: return Icons.check_circle_rounded;
      case FinanceHealthStatus.needsAttention: return Icons.warning_amber_rounded;
      case FinanceHealthStatus.actionRequired: return Icons.error_outline_rounded;
    }
  }
}

class PipelineVisualization extends StatelessWidget {
  const PipelineVisualization({super.key, required this.statuses});
  final Map<String, FinanceHealthStatus> statuses;

  @override
  Widget build(BuildContext context) {
    final stages = [
      'Gmail',
      'Historical Scanner',
      'Institution Discovery',
      'Classification',
      'Parser Engine',
      'Evidence Vault',
      'Duplicate Engine',
      'Verification Engine',
      'Database',
    ];

    return Column(
      children: [
        for (int i = 0; i < stages.length; i++) ...[
          _PipelineStage(
            name: stages[i],
            status: statuses[stages[i]] ?? FinanceHealthStatus.healthy,
          ),
          if (i < stages.length - 1)
            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.white10),
        ],
      ],
    );
  }
}

class _PipelineStage extends StatelessWidget {
  const _PipelineStage({required this.name, required this.status});
  final String name;
  final FinanceHealthStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status == FinanceHealthStatus.healthy ? Colors.blueAccent : Colors.orangeAccent;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Text(name.toUpperCase(), style: KnightTokens.label.copyWith(color: Colors.white70)),
          const Spacer(),
          Text(
            status.name.toUpperCase(),
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}

class AuditMetricGrid extends StatelessWidget {
  const AuditMetricGrid({super.key, required this.report});
  final Map<String, dynamic> report;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AuditRow(label: 'FINANCIAL EMAILS', value: report['financial_emails_found'].toString()),
        _AuditRow(label: 'PARSER SUCCESS', value: '${((report['parser_success_rate'] as double) * 100).toInt()}%'),
        _AuditRow(label: 'INSTITUTIONS', value: report['institutions_found'].toString()),
        _AuditRow(label: 'UNSUPPORTED', value: report['unsupported'].toString()),
        _AuditRow(label: 'NON-FINANCIAL', value: report['non_financial'].toString()),
      ],
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(label, style: KnightTokens.label.copyWith(color: Colors.white24)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
        ],
      ),
    );
  }
}

class ActivityFeedList extends StatelessWidget {
  const ActivityFeedList({super.key, required this.history});
  final List<dynamic> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Text('No recent platform activity.', style: TextStyle(color: Colors.white10, fontSize: 12));
    }
    return Column(
      children: history.map((h) => _ActivityTile(history: h)).toList(),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.history});
  final dynamic history;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            history.overallResult == 'Success' ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
            size: 16,
            color: history.overallResult == 'Success' ? Colors.greenAccent.withValues(alpha: 0.5) : Colors.redAccent.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMART SYNC ${history.overallResult.toUpperCase()}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '${history.emailsScanned} processed · ${history.transactionsAdded} added · ${history.duplicatesMerged} merged',
                  style: const TextStyle(fontSize: 10, color: Colors.white24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
