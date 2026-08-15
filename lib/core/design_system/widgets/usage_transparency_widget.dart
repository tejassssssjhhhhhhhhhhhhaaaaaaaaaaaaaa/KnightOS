import 'package:flutter/material.dart';
import '../design_constants.dart';

class UsageTransparencyWidget extends StatelessWidget {
  const UsageTransparencyWidget({
    super.key,
    required this.resourceName,
    required this.used,
    required this.total,
    this.unit = '',
    this.resetInfo,
  });

  final String resourceName;
  final double used;
  final double total;
  final String unit;
  final String? resetInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (used / total * 100).clamp(0.0, 100.0).toInt();

    return Container(
      padding: const EdgeInsets.all(DesignSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: DesignRadius.card,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI CORE USAGE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.white38,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$percentage% USED',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              value: used / total,
              backgroundColor: Colors.white10,
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
            ),
          ),
        ],
      ),
    );
  }
}
