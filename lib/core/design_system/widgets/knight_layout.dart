import 'package:flutter/material.dart';
import '../design_constants.dart';

class KnightSectionHeader extends StatelessWidget {
  const KnightSectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionPressed,
    this.useDesignPadding = true,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool useDesignPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: useDesignPadding
          ? const EdgeInsets.fromLTRB(
              DesignSpacing.m,
              DesignSpacing.l,
              DesignSpacing.m,
              DesignSpacing.s,
            )
          : const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          if (actionLabel != null && onActionPressed != null)
            TextButton(
              onPressed: onActionPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSpacing.m,
                ),
                visualDensity: VisualDensity.compact,
              ),
              child: Row(
                children: [
                  Text(
                    actionLabel!,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class KnightQuickActionTile extends StatelessWidget {
  const KnightQuickActionTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    this.color,
    required this.onTap,
    super.key,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignRadius.l),
          child: Padding(
            padding: const EdgeInsets.all(DesignSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: themeColor, size: DesignIconSize.m),
                const Spacer(),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white24,
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
