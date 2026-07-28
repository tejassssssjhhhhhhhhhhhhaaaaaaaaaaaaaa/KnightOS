import 'package:flutter/material.dart';
import 'home_constants.dart';

/// A consistent base layout for sections on the Home screen.
class HomeSectionBase extends StatelessWidget {
  /// Creates a [HomeSectionBase].
  const HomeSectionBase({
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    super.key,
  });

  /// The section title.
  final String title;

  /// An optional descriptive subtitle.
  final String? subtitle;

  /// The main content of the section.
  final Widget child;

  /// An optional widget to display on the right side of the header.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      header: true,
      container: true,
      label: '$title section. ${subtitle ?? ''}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(HomeSpacing.cardPadding),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(HomeSpacing.borderRadius),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
