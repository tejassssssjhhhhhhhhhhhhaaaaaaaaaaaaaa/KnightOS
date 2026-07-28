import 'package:flutter/material.dart';
import '../../../../app/widgets/home/home_constants.dart';
import '../../../../app/widgets/knight_progress_indicator.dart';
import '../../domain/focus_area.dart';

/// A card that displays progress and status for a specific focus area.
class FocusCard extends StatelessWidget {
  /// Creates a [FocusCard].
  const FocusCard({required this.focusArea, this.onTap, super.key});

  /// The data model for the focus area.
  final FocusArea focusArea;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressInt = (focusArea.completionProgress * 100).toInt();

    return Semantics(
      label:
          '${focusArea.title} focus area, $progressInt% complete. ${focusArea.statusBadge ?? ''}',
      button: onTap != null,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HomeSpacing.borderRadius),
          side: BorderSide(
            color: focusArea.isAiPrioritized
                ? theme.colorScheme.primary.withValues(alpha: 0.4)
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
            width: focusArea.isAiPrioritized ? 2.0 : 1.0,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(HomeSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    ExcludeSemantics(
                      child: Stack(
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
                              focusArea.category.icon,
                              size: 22,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          if (focusArea.isAiPrioritized)
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
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            focusArea.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          if (focusArea.statusBadge != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                focusArea.statusBadge!.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$progressInt%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (focusArea.reminderCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, right: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.notifications_none_rounded,
                                  size: 12,
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${focusArea.reminderCount}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  focusArea.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.8,
                    ),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                KnightProgressIndicator(
                  value: focusArea.completionProgress,
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
