import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class AtlasHero extends StatelessWidget {
  const AtlasHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        DesignSpacing.m,
        DesignSpacing.xl,
        DesignSpacing.m,
        DesignSpacing.l,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LIFE ATLAS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: DesignColors.travel,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: DesignSpacing.m),
          Text(
            'Your Life Journey',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 36),
          ),
          const SizedBox(height: 8),
          Text(
            'Tracing 1,402 memories across 12 countries and 4 career stages.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white38,
              height: 1.4,
            ),
          ),
          const SizedBox(height: DesignSpacing.l),
          Row(
            children: [
              _buildMetric(context, '1.4k', 'Memories'),
              const SizedBox(width: DesignSpacing.l),
              _buildMetric(context, '28', 'Achievements'),
              const SizedBox(width: DesignSpacing.l),
              _buildMetric(context, '92%', 'Confidence'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.white24,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
