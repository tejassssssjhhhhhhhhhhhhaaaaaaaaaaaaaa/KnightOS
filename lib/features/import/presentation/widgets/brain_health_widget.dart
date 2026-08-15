import 'package:flutter/material.dart';
import '../../../../core/intelligence/providers/brain_provider.dart';
import '../../../../core/design_system/design_constants.dart';

class BrainHealthWidget extends StatelessWidget {
  const BrainHealthWidget({required this.health, super.key});
  final BrainHealth health;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('BRAIN HEALTH', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900, fontSize: 10, color: Colors.white24)),
              _buildStatusBadge(health.status),
            ],
          ),
          const SizedBox(height: 24),
          _buildHealthMetric(context, 'KNOWLEDGE COVERAGE', health.coverage, 'How much of the information available to KNIGHT has been successfully processed and made usable.'),
          const Divider(height: 32, color: DesignColors.white05),
          _buildHealthMetric(context, 'FRESHNESS', health.freshness, 'How recently KNIGHT received updates from your connected sources.'),
          const Divider(height: 32, color: DesignColors.white05),
          Row(
            children: [
              Expanded(child: _buildMiniStat(context, 'CONFLICTS', health.conflicts.toString(), health.conflicts > 0 ? Colors.redAccent : Colors.greenAccent, 'Places where two pieces of information disagree.')),
              Container(width: 1, height: 30, color: DesignColors.white05),
              Expanded(child: _buildMiniStat(context, 'BACKLOG', health.verificationBacklog.toString(), health.verificationBacklog > 10 ? Colors.orangeAccent : Colors.blueAccent, 'Information KNIGHT isn\'t confident enough to treat as confirmed.')),
            ],
          ),
          if (health.hasPossibleDataGap) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 18),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'POSSIBLE DATA GAP DETECTED\nLocal record count is lower than historical sync totals.',
                      style: TextStyle(fontSize: 9, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BrainHealthStatus status) {
    Color color;
    String label;
    switch (status) {
      case BrainHealthStatus.optimal: color = Colors.greenAccent; label = 'STATUS: OPTIMAL'; break;
      case BrainHealthStatus.good: color = Colors.blueAccent; label = 'STATUS: GOOD'; break;
      case BrainHealthStatus.fair: color = Colors.orangeAccent; label = 'STATUS: FAIR'; break;
      case BrainHealthStatus.poor: color = Colors.redAccent; label = 'STATUS: POOR'; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color, letterSpacing: 1),
      ),
    );
  }

  Widget _buildHealthMetric(BuildContext context, String label, double value, String description) {
    return InkWell(
      onTap: () => _showExplanation(context, label, description),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.white10,
            color: Colors.blueAccent,
            minHeight: 2,
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 8, color: Colors.white10)),
        ],
      ),
    );
  }

  void _showExplanation(BuildContext context, String title, String explanation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        content: Text(explanation, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('UNDERSTOOD')),
        ],
      ),
    );
  }

  Widget _buildMiniStat(BuildContext context, String label, String value, Color color, String description) {
    return InkWell(
      onTap: () => _showExplanation(context, label, description),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
