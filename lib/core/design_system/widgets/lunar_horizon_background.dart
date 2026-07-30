import 'package:flutter/material.dart';
import '../design_constants.dart';

class LunarHorizonBackground extends StatelessWidget {
  const LunarHorizonBackground({
    this.child,
    this.opacity = 1.0,
    super.key,
  });

  final Widget? child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DesignColors.accentBlue : const Color(0xFF3B82F6);
    
    // ROOT CAUSE FIX: Horizon design system assumes a dark cinematic background.
    // Using theme background in light mode causes white-on-white visibility issues
    // because many welcome widgets hardcode light colors for cinematic effect.
    // We force a deep Navy background regardless of theme to preserve visual integrity.
    final bgColor = DesignColors.background;

    return Stack(
      children: [
        // 1. Space Base
        Container(color: bgColor),

        // 2. Cinematic Atmospheric Gradient
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.4),
                  radius: 1.2,
                  colors: [
                    primaryColor.withOpacity(isDark ? 0.15 : 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // 3. Horizon Line
        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          left: -MediaQuery.of(context).size.width * 0.5,
          right: -MediaQuery.of(context).size.width * 0.5,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.5,
                  colors: [
                    primaryColor.withOpacity(isDark ? 0.3 : 0.2),
                    bgColor.withOpacity(0.8),
                    bgColor,
                  ],
                  stops: const [0.0, 0.15, 0.25],
                ),
              ),
            ),
          ),
        ),

        // 4. Subtle Stars (Only in Dark Mode or Force enabled)
        // forced for cinematic feel
        const Positioned.fill(child: _StarsOverlay()),

        if (child != null) Positioned.fill(child: child!),
      ],
    );
  }
}

class _StarsOverlay extends StatelessWidget {
  const _StarsOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _StarsPainter(),
      ),
    );
  }
}

class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.2);
    
    // Deterministic random stars
    final List<Offset> points = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.05),
      Offset(size.width * 0.4, size.height * 0.25),
      Offset(size.width * 0.7, size.height * 0.1),
      Offset(size.width * 0.25, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.4),
    ];

    for (var p in points) {
      canvas.drawCircle(p, 0.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
