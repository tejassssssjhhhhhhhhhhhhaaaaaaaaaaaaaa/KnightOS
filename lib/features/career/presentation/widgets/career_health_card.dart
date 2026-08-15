import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/router/app_routes.dart';

class CareerHealthCard extends StatelessWidget {
  const CareerHealthCard({
    required this.momentum,
    required this.skillGrowth,
    required this.learningProgress,
    super.key,
  });

  final double momentum;
  final double skillGrowth;
  final double learningProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.push(AppRoutes.careerDna),
      borderRadius: DesignRadius.card,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: DesignColors.surfaceHigh.withValues(alpha: 0.6),
          borderRadius: DesignRadius.card,
          border: Border.all(color: DesignColors.white05),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Career Health',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: DesignColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: DesignColors.career.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'STATUS: NOMINAL',
                    style: TextStyle(
                      color: DesignColors.career,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _HealthMetricRow(
              label: 'Execution Consistency',
              value: momentum,
              color: DesignColors.career,
            ),
            const SizedBox(height: 16),
            _HealthMetricRow(
              label: 'Skill Growth (Monthly)',
              value: skillGrowth,
              color: DesignColors.accentCyan,
              isPercentageChange: true,
            ),
            const SizedBox(height: 16),
            _HealthMetricRow(
              label: 'Knowledge Acquisition',
              value: learningProgress,
              color: DesignColors.accentPurple,
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthMetricRow extends StatelessWidget {
  const _HealthMetricRow({
    required this.label,
    required this.value,
    required this.color,
    this.isPercentageChange = false,
  });

  final String label;
  final double value;
  final Color color;
  final bool isPercentageChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: DesignColors.secondary, fontSize: 13)),
            Text(
              isPercentageChange ? '+${(value * 100).toInt()}%' : '${(value * 100).toInt()}%',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: DesignColors.white10,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
