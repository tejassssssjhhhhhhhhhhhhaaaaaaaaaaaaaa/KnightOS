import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class StrategicInsightCard extends StatelessWidget {
  const StrategicInsightCard({
    required this.recommendation,
    required this.why,
    required this.risks,
    required this.evidence,
    required this.assumptions,
    required this.confidence,
    required this.nextAction,
    super.key,
  });

  final String recommendation;
  final String why;
  final String risks;
  final String evidence;
  final String assumptions;
  final double confidence;
  final String nextAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: DesignRadius.card,
        border: Border.all(color: DesignColors.warning.withValues(alpha: 0.3)),
        boxShadow: DesignShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded, color: DesignColors.warning, size: 20),
              const SizedBox(width: 12),
              const Text(
                'STRATEGIC GUIDANCE',
                style: TextStyle(color: DesignColors.warning, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 10),
              ),
              const Spacer(),
              _ConfidenceTag(confidence: confidence),
            ],
          ),
          const SizedBox(height: 20),
          Text(recommendation, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          
          _StrategicDetail(label: 'Why?', content: why, icon: Icons.help_outline_rounded),
          const SizedBox(height: 16),
          _StrategicDetail(label: 'Risks if ignored', content: risks, icon: Icons.warning_amber_rounded, color: DesignColors.error),
          const SizedBox(height: 16),
          _StrategicDetail(label: 'Supporting Evidence', content: evidence, icon: Icons.verified_rounded, color: DesignColors.success),
          const SizedBox(height: 16),
          _StrategicDetail(label: 'Assumptions', content: assumptions, icon: Icons.settings_input_component_rounded),
          
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignColors.warning,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'ACT NOW: $nextAction',
              style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfidenceTag extends StatelessWidget {
  const _ConfidenceTag({required this.confidence});
  final double confidence;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: DesignColors.white05, borderRadius: BorderRadius.circular(100)),
      child: Text(
        '${(confidence * 100).toInt()}% CONFIDENT',
        style: const TextStyle(color: DesignColors.secondary, fontSize: 8, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _StrategicDetail extends StatelessWidget {
  const _StrategicDetail({required this.label, required this.content, required this.icon, this.color});
  final String label;
  final String content;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color ?? DesignColors.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(color: color?.withValues(alpha: 0.7) ?? DesignColors.secondary, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.5),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
