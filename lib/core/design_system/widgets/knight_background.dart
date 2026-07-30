import 'package:flutter/material.dart';
import '../design_constants.dart';
import '../../internal/utils/knight_logger.dart';

class KnightBackground extends StatelessWidget {
  const KnightBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    KnightLogger.info('[UI] KnightBackground build()');
    return SizedBox.expand(
      child: Stack(
        children: [
          // Base Background
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: DesignColors.background),
            ),
          ),

          // Radial Atmospheric Glow
          Positioned(
            top: -200,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      DesignColors.focus.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Surface Child
          child,
        ],
      ),
    );
  }
}
