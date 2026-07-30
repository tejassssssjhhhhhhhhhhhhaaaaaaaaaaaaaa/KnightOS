import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/intelligence/domain/reasoning_models.dart';
import '../../../../core/intelligence/domain/intelligence_models.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/router/app_routes.dart';

class IntelligenceFeedList extends StatefulWidget {
  const IntelligenceFeedList({required this.reasoning, super.key});

  final ReasoningResult reasoning;

  @override
  State<IntelligenceFeedList> createState() => _IntelligenceFeedListState();
}

class _IntelligenceFeedListState extends State<IntelligenceFeedList> {
  final Set<String> _dismissedIds = {};

  @override
  Widget build(BuildContext context) {
    final insights = widget.reasoning.insights.where((i) => !_dismissedIds.contains(i.id)).toList();
    final recommendations = widget.reasoning.recommendations.where((r) => !_dismissedIds.contains(r.id)).toList();
    final warnings = widget.reasoning.warnings;

    if (insights.isEmpty && recommendations.isEmpty && warnings.isEmpty) {
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
        ...warnings.take(1).map((w) => IntelligenceCard.fromWarning(w)),
        ...insights.take(2).map((i) => IntelligenceCard(
          title: i.title,
          description: i.description,
          icon: Icons.lightbulb_outline_rounded,
          color: DesignColors.accentBlue,
          reasoning: i.explanation,
          domain: 'custom', // Map appropriately in real logic
          onFeedback: (f) {
            setState(() => _dismissedIds.add(i.id));
          },
        )),
        ...recommendations.take(2).map((r) => IntelligenceCard(
          title: r.title,
          description: r.description,
          icon: Icons.auto_awesome_rounded,
          color: DesignColors.accentPurple,
          reasoning: r.reason.summary,
          domain: r.category.name,
          onFeedback: (f) {
            setState(() => _dismissedIds.add(r.id));
          },
        )),
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

class IntelligenceCard extends ConsumerWidget {
  const IntelligenceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.reasoning,
    this.domain,
    this.onFeedback,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? reasoning;
  final String? domain;
  final ValueChanged<IntelligenceFeedback>? onFeedback;

  factory IntelligenceCard.fromWarning(String warning) {
    return IntelligenceCard(
      title: 'High Priority Alert',
      description: warning,
      icon: Icons.warning_amber_rounded,
      color: DesignColors.error,
      reasoning: 'Critical environmental trigger',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                if (domain != null) ...[
                  IconButton(
                    onPressed: () => _handleFeedback(ref, IntelligenceFeedback.helpful),
                    icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white24, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => _handleFeedback(ref, IntelligenceFeedback.ignore),
                    icon: const Icon(Icons.close_rounded, color: Colors.white24, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
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
                  color: Colors.white.withOpacity(0.03),
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

  void _handleFeedback(WidgetRef ref, IntelligenceFeedback feedback) {
    if (domain != null) {
      ref.read(reasoningServiceProvider).provideFeedback(domain!, feedback);
      onFeedback?.call(feedback);
    }
  }
}
