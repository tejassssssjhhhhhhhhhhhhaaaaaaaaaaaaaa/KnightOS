import 'package:flutter/material.dart';
import '../../../../app/widgets/home/home_constants.dart';
import '../../../../app/widgets/knight_progress_indicator.dart';
import '../../domain/recovery_metric.dart';

/// A card that displays a specific recovery metric with progress and status.
class RecoveryCard extends StatelessWidget {
  /// Creates a [RecoveryCard].
  const RecoveryCard({required this.metric, this.onTap, super.key});

  /// The recovery metric to display.
  final RecoveryMetric metric;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Value is assumed to be 0-100 for percentage-based metrics.
    final progress = (metric.value / 100).clamp(0.0, 1.0);

    return Semantics(
      label:
          '${metric.category.label} metric, ${metric.value.toInt()}${metric.unit}. ${metric.status}',
      button: onTap != null,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HomeSpacing.borderRadius),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(HomeSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            metric.category.icon,
                            size: 22,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        if (metric.isAiOptimized)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        metric.category.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${metric.value.toInt()}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      metric.unit,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  metric.status,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.8,
                    ),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 20),
                KnightProgressIndicator(value: progress, height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
