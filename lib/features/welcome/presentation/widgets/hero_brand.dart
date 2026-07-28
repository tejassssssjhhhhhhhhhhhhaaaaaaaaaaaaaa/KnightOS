import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class HeroBrand extends StatelessWidget {
  const HeroBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'K',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 72,
            color: DesignColors.accentBlue,
            fontFamily: 'Serif',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'KNIGHTOS',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 12.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 60,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.0),
                DesignColors.accentBlue,
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
