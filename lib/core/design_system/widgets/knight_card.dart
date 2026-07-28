import 'package:flutter/material.dart';
import '../design_constants.dart';

class KnightHeroCard extends StatelessWidget {
  const KnightHeroCard({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.onCtaPressed,
    this.accentColor = DesignColors.focus,
    super.key,
  });

  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback onCtaPressed;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh,
        borderRadius: BorderRadius.circular(DesignRadius.xl),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 50,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignRadius.xl),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DesignSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STRATEGIC OBJECTIVE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: DesignSpacing.m),
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.displayMedium?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: DesignSpacing.s),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white60),
                  ),
                  const SizedBox(height: DesignSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onCtaPressed,
                      style: FilledButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(ctaLabel.toUpperCase()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KnightFeatureCard extends StatelessWidget {
  const KnightFeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: DesignRadius.card,
        child: Padding(
          padding: const EdgeInsets.all(DesignSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: accentColor, size: 24),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white24,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KnightStatCard extends StatelessWidget {
  const KnightStatCard({
    required this.label,
    required this.value,
    this.unit,
    this.trend,
    this.icon,
    this.color = DesignColors.primary,
    super.key,
  });

  final String label;
  final String value;
  final String? unit;
  final String? trend;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSpacing.l),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              if (icon != null)
                Icon(icon, size: 14, color: color.withValues(alpha: 0.5)),
            ],
          ),
          const SizedBox(height: DesignSpacing.m),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: Theme.of(context).textTheme.headlineLarge),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(unit!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
          if (trend != null) ...[
            const SizedBox(height: DesignSpacing.s),
            Text(
              trend!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: trend!.startsWith('+')
                    ? DesignColors.finance
                    : DesignColors.health,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class KnightPremiumCard extends StatelessWidget {
  const KnightPremiumCard({
    required this.content,
    this.isGlass = false,
    super.key,
  });

  final Widget content;
  final bool isGlass;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(24.0), child: content),
    );
  }
}
