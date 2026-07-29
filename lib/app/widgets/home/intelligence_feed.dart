import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/intelligence/domain/reasoning_models.dart';
import '../../../../core/platform/engine/recommendation_models.dart';
import '../../../../core/router/app_routes.dart';

class IntelligenceFeedList extends StatelessWidget {
  const IntelligenceFeedList({required this.reasoning, super.key});

  final ReasoningResult reasoning;

  @override
  Widget build(BuildContext context) {
    final insights = reasoning.insights;
    final recommendations = reasoning.recommendations;

    if (insights.isEmpty && recommendations.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'INTELLIGENCE FEED',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                letterSpacing: 2.0,
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.intelligence),
              child: const Text('VIEW ALL', style: TextStyle(fontSize: 10)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...insights.take(2).map((i) => IntelligenceCard.fromInsight(i)),
        ...recommendations.take(2).map((r) => IntelligenceCard.fromRecommendation(r)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INTELLIGENCE FEED',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 16),
        const Text(
          'No new insights currently. Knight is analyzing your patterns...',
          style: TextStyle(color: Colors.white24, fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class IntelligenceCard extends StatelessWidget {
  const IntelligenceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.reasoning,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? reasoning;

  factory IntelligenceCard.fromInsight(KnightInsight insight) {
    return IntelligenceCard(
      title: insight.title,
      description: insight.description,
      icon: Icons.lightbulb_outline_rounded,
      color: DesignColors.accentBlue,
      reasoning: insight.explanation,
    );
  }

  factory IntelligenceCard.fromRecommendation(KnightRecommendation rec) {
    return IntelligenceCard(
      title: rec.title,
      description: rec.description,
      icon: Icons.auto_awesome_rounded,
      color: DesignColors.accentPurple,
      reasoning: rec.reason.summary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
            if (reasoning != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'WHY: $reasoning',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white24,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
