import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class PlannerHero extends StatelessWidget {
  const PlannerHero({
    required this.mainFocus,
    required this.completionPercentage,
    super.key,
  });

  final String mainFocus;
  final double completionPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        DesignSpacing.m,
        DesignSpacing.xl,
        DesignSpacing.m,
        DesignSpacing.l,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TODAY\'S FOCUS',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: DesignColors.focus,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: DesignSpacing.m),
                Text(
                  mainFocus,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(completionPercentage * 100).toInt()}% of daily objectives secured.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white38),
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignSpacing.m),
          _buildProgressRing(context),
        ],
      ),
    );
  }

  Widget _buildProgressRing(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: completionPercentage,
            strokeWidth: 8,
            backgroundColor: Colors.white10,
            color: DesignColors.focus,
            strokeCap: StrokeCap.round,
          ),
        ),
        Text(
          '${(completionPercentage * 100).toInt()}%',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
      ],
    );
  }
}
