import 'package:flutter/material.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../controllers/finance_inbox_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxItemCard extends StatelessWidget {
  const InboxItemCard({
    super.key,
    required this.task,
    required this.onAction,
    required this.onExplain,
  });

  final FinanceInboxTaskData task;
  final Function(String action) onAction;
  final VoidCallback onExplain;

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(task.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.taskType.toUpperCase(), style: KnightTokens.label.copyWith(color: priorityColor)),
                    const SizedBox(height: 4),
                    Text(task.description ?? 'No description', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
              if (task.confidence != null)
                _ConfidenceBadge(confidence: task.confidence!),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.business_rounded, size: 14, color: Colors.white24),
              const SizedBox(width: 8),
              Text(task.institution ?? 'Multiple / Unknown', style: const TextStyle(fontSize: 12, color: Colors.white38)),
              const Spacer(),
              Text(_formatDate(task.id), style: const TextStyle(fontSize: 10, color: Colors.white24)),
            ],
          ),
          const Divider(height: 32, color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActionButton(label: 'EXPLAIN', icon: Icons.info_outline_rounded, onTap: onExplain, isSecondary: true),
              _ActionButton(label: 'RESOLVE', icon: Icons.check_circle_outline_rounded, onTap: () => onAction('resolve')),
              _ActionButton(label: 'IGNORE', icon: Icons.block_flipped, onTap: () => onAction('ignore'), isSecondary: true),
              _ActionMenu(onSelected: onAction),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical': return Colors.redAccent;
      case 'high': return Colors.orangeAccent;
      case 'medium': return Colors.blueAccent;
      default: return Colors.greenAccent;
    }
  }

  String _formatDate(String id) {
    // Simplified for now, in a real app we'd use task.createdAt
    return 'Just now';
  }
}

class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.confidence});
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final color = confidence > 0.8 ? Colors.greenAccent : (confidence > 0.5 ? Colors.orangeAccent : Colors.redAccent);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text('${(confidence * 100).toInt()}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon, required this.onTap, this.isSecondary = false});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isSecondary ? Colors.white24 : Colors.blueAccent),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSecondary ? Colors.white24 : Colors.blueAccent)),
          ],
        ),
      ),
    );
  }
}

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({required this.onSelected});
  final Function(String action) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 18, color: Colors.white24),
      color: Colors.grey[900],
      onSelected: onSelected,
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'retry', child: Text('Retry Processing', style: TextStyle(fontSize: 12))),
        const PopupMenuItem(value: 'remind', child: Text('Remind Me Later', style: TextStyle(fontSize: 12))),
        const PopupMenuItem(value: 'evidence', child: Text('View Gmail Evidence', style: TextStyle(fontSize: 12))),
        const PopupMenuItem(value: 'upload', child: Text('Upload Document', style: TextStyle(fontSize: 12))),
      ],
    );
  }
}

class InboxExplainSheet extends ConsumerWidget {
  const InboxExplainSheet({super.key, required this.task});
  final FinanceInboxTaskData task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final explanationAsync = ref.watch(inboxExplanationProvider(task));

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: explanationAsync.when(
        data: (exp) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('EXPLAINABILITY', style: KnightTokens.label),
            const SizedBox(height: 16),
            Text(exp.title, style: KnightTokens.headline.copyWith(fontSize: 24)),
            const SizedBox(height: 12),
            Text(exp.reason, style: KnightTokens.subheadline),
            const SizedBox(height: 32),
            _ExpSection(label: 'ENGINE SOURCE', value: exp.engine, icon: Icons.memory_rounded),
            _ExpSection(label: 'EVIDENCE USED', value: exp.evidence.join(', '), icon: Icons.history_edu_rounded),
            _ExpSection(label: 'SYSTEM CONFIDENCE', value: '${(exp.confidence * 100).toInt()}%', icon: Icons.radar_rounded),
            _ExpSection(label: 'SUGGESTED ACTION', value: exp.suggestedAction, icon: Icons.lightbulb_outline_rounded),
            _ExpSection(label: 'EXPECTED IMPACT', value: exp.impact, icon: Icons.bolt_rounded, color: Colors.blueAccent),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('UNDERSTOOD'),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Explanation Error: $e')),
      ),
    );
  }
}

class _ExpSection extends StatelessWidget {
  const _ExpSection({required this.label, required this.value, required this.icon, this.color = Colors.white38});
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: KnightTokens.label.copyWith(fontSize: 8)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
