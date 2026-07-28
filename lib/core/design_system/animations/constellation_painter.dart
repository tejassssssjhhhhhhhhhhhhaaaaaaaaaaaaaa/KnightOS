import 'dart:math';
import 'package:flutter/material.dart';

class ConstellationPainter extends CustomPainter {
  ConstellationPainter({required this.progress, required this.seed})
    : _random = Random(seed);

  final double progress;
  final int seed;
  final Random _random;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.8;
    final starCount = 5 + _random.nextInt(4);
    final points = <Offset>[];

    final paintStar = Paint()
      ..color = Colors.white.withValues(alpha: (1.0 - progress))
      ..style = PaintingStyle.fill;

    final paintLine = Paint()
      ..color = Colors.white.withValues(alpha: (1.0 - progress) * 0.3)
      ..strokeWidth = 1.0;

    // Generate Stars
    for (var i = 0; i < starCount; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final dist = _random.nextDouble() * radius;
      final pos = Offset(
        center.dx + cos(angle) * dist,
        center.dy + sin(angle) * dist,
      );
      points.add(pos);
      canvas.drawCircle(pos, 1.5, paintStar);
    }

    // Connect them
    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paintLine);
    }
    // Close the loop for a "constellation" feel
    canvas.drawLine(points.last, points.first, paintLine);
  }

  @override
  bool shouldRepaint(covariant ConstellationPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
