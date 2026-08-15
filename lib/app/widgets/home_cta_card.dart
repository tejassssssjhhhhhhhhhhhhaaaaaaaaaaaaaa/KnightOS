import 'package:flutter/material.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/design_system/knight_tokens.dart';

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
    return Semantics(
      label: '$title. $subtitle',
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.xl),
          decoration: BoxDecoration(
            color: DesignColors.surfaceHigh.withValues(alpha: 0.6),
            borderRadius: DesignRadius.card,
            border: Border.all(
              color: DesignColors.accentBlue.withValues(alpha: 0.2),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: DesignColors.accentBlue.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: KnightTokens.subheadline,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DesignColors.accentBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DesignColors.accentBlue.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: DesignColors.accentBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
