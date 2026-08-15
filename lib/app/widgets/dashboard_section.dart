import 'package:flutter/material.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/design_system/knight_tokens.dart';

/// A standardized section container for dashboard modules.
class DashboardSection extends StatelessWidget {
  const DashboardSection({
    required this.title,
    required this.child,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignSpacing.l),
      decoration: BoxDecoration(
        color: DesignColors.surface.withValues(alpha: 0.5),
        borderRadius: DesignRadius.card,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: KnightTokens.label,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: KnightTokens.subheadline,
            ),
          ],
          const SizedBox(height: DesignSpacing.l),
          child,
        ],
      ),
    );
  }
}
