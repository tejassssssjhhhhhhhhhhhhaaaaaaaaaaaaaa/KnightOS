import 'package:flutter/material.dart';

/// A prominent call-to-action card for the Home screen.
class HomeCtaCard extends StatelessWidget {
  /// Creates a [HomeCtaCard].
  const HomeCtaCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    super.key,
  });

  /// The main title of the CTA.
  final String title;

  /// A descriptive subtitle for the CTA.
  final String subtitle;

  /// The icon representing the action.
  final IconData icon;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$title. $subtitle',
      button: onTap != null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          color: theme.colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.onPrimaryContainer,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.75),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ExcludeSemantics(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.12,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.1),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 36,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
