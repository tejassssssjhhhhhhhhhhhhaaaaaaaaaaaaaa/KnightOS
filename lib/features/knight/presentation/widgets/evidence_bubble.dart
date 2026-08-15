import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../../../core/router/app_routes.dart';

/// Renders a collection of evidence supporting an AI claim.
class EvidenceBubble extends StatelessWidget {
  const EvidenceBubble({
    super.key,
    required this.evidence,
  });

  final List<dynamic> evidence;

  @override
  Widget build(BuildContext context) {
    if (evidence.isEmpty) return const SizedBox.shrink();

    // Group evidence by type for summarized action buttons
    final grouped = <String, List<dynamic>>{};
    for (final e in evidence) {
      final type = (e['metadata'] as Map<String, dynamic>?)?['type'] ?? 'unknown';
      grouped.putIfAbsent(type, () => []).add(e);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GROUNDING EVIDENCE',
            style: KnightTokens.label,
          ),
          const SizedBox(height: 12),
          ...evidence.map((item) => _EvidenceItemTile(item: item)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: grouped.entries.map((entry) {
              return _buildSectionAction(context, entry.key, entry.value.length);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionAction(BuildContext context, String type, int count) {
    final IconData icon;
    final String label;
    final String route;

    switch (type) {
      case 'transaction':
        icon = Icons.account_balance_wallet_rounded;
        label = 'FINANCE';
        route = AppRoutes.finance;
        break;
      case 'calendar_event':
        icon = Icons.calendar_today_rounded;
        label = 'CALENDAR';
        route = '/hub/calendar';
        break;
      case 'email':
        icon = Icons.email_rounded;
        label = 'EMAILS';
        route = '/hub/emails';
        break;
      case 'goal':
        icon = Icons.flag_rounded;
        label = 'GOALS';
        route = AppRoutes.finance;
        break;
      case 'work_session':
        icon = Icons.work_history_rounded;
        label = 'CAREER';
        route = AppRoutes.career;
        break;
      case 'trip':
        icon = Icons.flight_takeoff_rounded;
        label = 'TRAVEL';
        route = AppRoutes.travelHome;
        break;
      default:
        icon = Icons.info_outline_rounded;
        label = 'DETAILS';
        route = AppRoutes.home;
    }

    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: DesignColors.accentBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: DesignColors.accentBlue.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: DesignColors.accentBlue),
            const SizedBox(width: 8),
            Text(
              '$label ($count)',
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: DesignColors.accentBlue),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvidenceItemTile extends StatefulWidget {
  const _EvidenceItemTile({required this.item});
  final dynamic item;

  @override
  State<_EvidenceItemTile> createState() => _EvidenceItemTileState();
}

class _EvidenceItemTileState extends State<_EvidenceItemTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final source = widget.item['source']?.toString() ?? 'Unknown';
    final metadata = widget.item['metadata'] as Map<String, dynamic>? ?? {};
    final title = metadata['title'] ?? metadata['subject'] ?? metadata['summary'] ?? 'Evidence Unit';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() => _expanded = !_expanded),
            dense: true,
            leading: Icon(_getIconForSource(source), size: 16, color: Colors.white24),
            title: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              source.toUpperCase(),
              style: const TextStyle(fontSize: 8, color: Colors.white12, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              _expanded ? Icons.unfold_less_rounded : Icons.unfold_more_rounded, 
              size: 14, 
              color: Colors.white10
            ),
          ),
          if (_expanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                const JsonEncoder.withIndent('  ').convert(widget.item),
                style: const TextStyle(color: Colors.blueGrey, fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getIconForSource(String source) {
    final s = source.toLowerCase();
    if (s.contains('gmail')) return Icons.email_rounded;
    if (s.contains('calendar')) return Icons.calendar_today_rounded;
    if (s.contains('health')) return Icons.favorite_rounded;
    if (s.contains('drive')) return Icons.insert_drive_file_rounded;
    return Icons.fact_check_rounded;
  }
}
