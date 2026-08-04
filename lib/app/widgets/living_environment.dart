import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/internal/services/greeting_service.dart';
import '../../core/design_system/knight_tokens.dart';

class LivingEnvironment extends StatefulWidget {
  const LivingEnvironment({required this.period, required this.child, super.key});

  final KnightDayPeriod period;
  final Widget child;

  @override
  State<LivingEnvironment> createState() => _LivingEnvironmentState();
}

class _LivingEnvironmentState extends State<LivingEnvironment> with TickerProviderStateMixin {
  late final AnimationController _motionController;
  
  // For smooth transitions between periods
  KnightDayPeriod? _previousPeriod;
  double _transitionValue = 1.0;
  late final AnimationController _transitionController;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    
    if (!kDebugMode || !Platform.environment.containsKey('FLUTTER_TEST')) {
       _motionController.repeat();
    }

    _transitionController = AnimationController(
      vsync: this,
      duration: KnightTokens.transitionSlow,
    )..addListener(() {
        setState(() {
          _transitionValue = _transitionController.value;
        });
      });
    
    _previousPeriod = widget.period;
    _transitionController.value = 1.0;
  }

  @override
  void didUpdateWidget(LivingEnvironment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period) {
      _previousPeriod = oldWidget.period;
      _transitionController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _motionController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: Listenable.merge([_motionController]),
            builder: (context, _) {
              return CustomPaint(
                painter: _AtmospherePainter(
                  period: widget.period,
                  previousPeriod: _previousPeriod ?? widget.period,
                  transitionProgress: _transitionValue,
                  motionProgress: _motionController.value,
                ),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _AtmospherePainter extends CustomPainter {
  _AtmospherePainter({
    required this.period,
    required this.previousPeriod,
    required this.transitionProgress,
    required this.motionProgress,
  });

  final KnightDayPeriod period;
  final KnightDayPeriod previousPeriod;
  final double transitionProgress;
  final double motionProgress;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Previous Period (Background)
    _drawPeriodIdentity(canvas, size, previousPeriod, 1.0);

    // 2. Draw Current Period (Overlay with opacity)
    if (transitionProgress < 1.0) {
      _drawPeriodIdentity(canvas, size, period, transitionProgress);
    } else {
      _drawPeriodIdentity(canvas, size, period, 1.0);
    }
  }

  void _drawPeriodIdentity(Canvas canvas, Size size, KnightDayPeriod p, double opacity) {
    final paint = Paint();
    final rect = Offset.zero & size;

    // Gradient
    final colors = KnightTokens.backgroundGradient(p).map((c) => c.withValues(alpha: opacity)).toList();
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
    );
    paint.shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Animated Elements
    switch (p) {
      case KnightDayPeriod.dawn:
        _drawMorning(canvas, size, opacity);
        break;
      case KnightDayPeriod.day:
        _drawAfternoon(canvas, size, opacity);
        break;
      case KnightDayPeriod.dusk:
        _drawEvening(canvas, size, opacity);
        break;
      case KnightDayPeriod.night:
        _drawNight(canvas, size, opacity);
        break;
    }
  }

  void _drawMorning(Canvas canvas, Size size, double opacity) {
    // Subtle birds
    for (var i = 0; i < 3; i++) {
      final x = (size.width * (motionProgress + i * 0.3)) % size.width;
      final y = size.height * (0.2 + i * 0.1);
      _drawBird(canvas, Offset(x, y), 10, opacity);
    }
  }

  void _drawAfternoon(Canvas canvas, Size size, double opacity) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03 * opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    
    for (var i = 0; i < 2; i++) {
      final x = (size.width * (motionProgress * 0.5 + i * 0.5)) % (size.width + 400) - 200;
      final y = size.height * (0.1 + i * 0.2);
      canvas.drawCircle(Offset(x, y), 150, paint);
    }
  }

  void _drawEvening(Canvas canvas, Size size, double opacity) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.orange.withValues(alpha: 0.15 * opacity), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4));
    
    canvas.drawRect(Offset.zero & size, paint);
  }

  void _drawNight(Canvas canvas, Size size, double opacity) {
    final rand = Random(42);
    final paint = Paint()..color = Colors.white;

    for (var i = 0; i < 60; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height * 0.7;
      final sparkle = 0.5 + 0.5 * sin(motionProgress * 2 * pi + i);
      final alpha = (0.1 + rand.nextDouble() * 0.5) * sparkle * opacity;
      paint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), rand.nextDouble() * 1.5, paint);
    }
  }

  void _drawBird(Canvas canvas, Offset pos, double size, double opacity) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    
    final path = Path()
      ..moveTo(pos.dx - size, pos.dy)
      ..quadraticBezierTo(pos.dx - size / 2, pos.dy - size / 2, pos.dx, pos.dy)
      ..quadraticBezierTo(pos.dx + size / 2, pos.dy - size / 2, pos.dx + size, pos.dy);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AtmospherePainter oldDelegate) => true;
}
