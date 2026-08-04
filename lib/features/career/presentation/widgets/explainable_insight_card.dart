import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class ExplainableInsightCard extends StatelessWidget {
  const ExplainableInsightCard({
    required this.title,
    required this.recommendation,
    required this.evidenceSummary,
    required this.reasoning,
    required this.confidence,
    required this.suggestedAction,
    this.onActionPressed,
    super.key,
  });

  final String title;
  final String recommendation;
  final String evidenceSummary;
  final String reasoning;
  final double confidence;
  final String suggestedAction;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignColors.accentBlue.withValues(alpha: 0.15),
            DesignColors.accentPurple.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: DesignRadius.card,
        border: Border.all(color: DesignColors.accentBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: DesignColors.accentBlue, size: 20),
              const SizedBox(width: 12),
              Text(
                title.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: DesignColors.accentBlue,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              _ConfidencePill(confidence: confidence),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            recommendation,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          _InsightSection(
            label: 'Evidence',
            icon: Icons.verified_user_rounded,
            content: evidenceSummary,
          ),
          const SizedBox(height: 16),
          _InsightSection(
            label: 'Reasoning',
            icon: Icons.psychology_rounded,
            content: reasoning,
          ),
          
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onActionPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignColors.accentBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            icon: const Icon(Icons.bolt_rounded),
            label: Text(
              suggestedAction.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfidencePill extends StatelessWidget {
  const _ConfidencePill({required this.confidence});
  final double confidence;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: DesignColors.white10,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '${(confidence * 100).toInt()}% CONFIDENCE',
        style: const TextStyle(
          color: DesignColors.secondary,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _InsightSection extends StatelessWidget {
  const _InsightSection({required this.label, required this.icon, required this.content});
  final String label;
  final IconData icon;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: DesignColors.secondary),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: DesignColors.secondary,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Text(
            content,
            style: const TextStyle(
              color: DesignColors.primary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
