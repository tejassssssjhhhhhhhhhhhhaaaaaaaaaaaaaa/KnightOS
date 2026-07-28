import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    super.key,
    required this.colors,
    this.parallaxOffset = Offset.zero,
  });

  final List<Color> colors;
  final Offset parallaxOffset;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24), // Slower breathing
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Base Gradient
        AnimatedContainer(
          duration: const Duration(milliseconds: 2500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
            ),
          ),
        ),

        // 2. Animated Aurora Waves (Flagship Pass: Even more subtle)
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return RepaintBoundary(
                child: Transform.translate(
                  offset: widget.parallaxOffset * 0.3, // Distant layer
                  child: CustomPaint(
                    painter: _AuroraPainter(
                      progress: _controller.value,
                      // Reduced for maximum calm
                      color: Colors.white.withValues(alpha: 0.018),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // 3. Layered Floating Orbs
        _FloatingOrb(
          controller: _controller,
          color: widget.colors.last.withValues(alpha: 0.1),
          size: 450,
          top: -120,
          right: -100,
          baseOffset: 0.0,
          speedMultiplier: 0.6,
          parallaxOffset: widget.parallaxOffset * 0.7,
        ),
        _FloatingOrb(
          controller: _controller,
          color: widget.colors.first.withValues(alpha: 0.06),
          size: 550,
          bottom: -180,
          left: -150,
          baseOffset: math.pi / 1.5,
          speedMultiplier: 0.5,
          parallaxOffset: widget.parallaxOffset * 1.1,
        ),

        // 4. Content Contrast Overlay (20% darken)
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
              ),
            ),
          ),
        ),

        // 5. Strong Flagship Vignette
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.4,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingOrb extends StatelessWidget {
  const _FloatingOrb({
    required this.controller,
    required this.color,
    required this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.baseOffset,
    this.speedMultiplier = 1.0,
    required this.parallaxOffset,
  });

  final AnimationController controller;
  final Color color;
  final double size;
  final double? top, bottom, left, right;
  final double baseOffset;
  final double speedMultiplier;
  final Offset parallaxOffset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final angle =
            controller.value * 2 * math.pi * speedMultiplier + baseOffset;
        final x = math.sin(angle) * 30;
        final y = math.cos(angle) * 30;

        return Positioned(
          top: top != null ? top! + y + parallaxOffset.dy : null,
          bottom: bottom != null ? bottom! + y - parallaxOffset.dy : null,
          left: left != null ? left! + x + parallaxOffset.dx : null,
          right: right != null ? right! + x - parallaxOffset.dx : null,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: const SizedBox.expand(),
            ),
          ),
        );
      },
    );
  }
}

class _AuroraPainter extends CustomPainter {
  const _AuroraPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Distant Wave
    final path = Path();
    final yOffset = size.height * 0.68;
    path.moveTo(0, yOffset);
    for (var x = 0.0; x <= size.width; x += 4) {
      final animationOffset = math.sin(progress * 2 * math.pi + (x / 150)) * 20;
      final y = yOffset + math.sin(x / 200) * 35 + animationOffset;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Mid Wave
    final path2 = Path();
    final yOffset2 = size.height * 0.74;
    path2.moveTo(0, yOffset2);
    for (var x = 0.0; x <= size.width; x += 4) {
      final animationOffset = math.cos(progress * 2 * math.pi + (x / 180)) * 15;
      final y = yOffset2 + math.cos(x / 240) * 45 + animationOffset;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    paint.color = color.withValues(alpha: color.a * 0.6);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) => true;
}
