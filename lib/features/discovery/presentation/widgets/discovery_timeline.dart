import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class DiscoveryTimeline extends StatelessWidget {
  const DiscoveryTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(DesignSpacing.l),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: DesignRadius.card,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KNOWLEDGE ACQUISITION VELOCITY',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const Spacer(),
          // Placeholder for a high-fidelity chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final height = (index + 1) * 15.0 + (index % 2 == 0 ? 20 : 0);
              return Container(
                width: 30,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      DesignColors.knowledge.withValues(alpha: 0.6),
                      DesignColors.knowledge.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MON',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'TUE',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'WED',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'THU',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'FRI',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'SAT',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'SUN',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
