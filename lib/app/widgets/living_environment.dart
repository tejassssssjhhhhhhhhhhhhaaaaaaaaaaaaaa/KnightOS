import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/internal/services/greeting_service.dart';
import '../../core/design_system/knight_tokens.dart';

class LivingEnvironment extends StatefulWidget {
  const LivingEnvironment({
    required this.period, 
    required this.child, 
    this.isRelaxed = false,
    super.key
  });

  final KnightDayPeriod period;
  final bool isRelaxed;
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
            animation: Listenable.merge([_motionController, _transitionController]),
            builder: (context, _) {
              return CustomPaint(
                painter: _AtmospherePainter(
                  period: widget.period,
                  previousPeriod: _previousPeriod ?? widget.period,
                  transitionProgress: _transitionValue,
                  motionProgress: _motionController.value,
                  isRelaxed: widget.isRelaxed,
                ),
              );
            },
          ),
        ),
        if (widget.isRelaxed)
           Positioned.fill(
             child: IgnorePointer(
               child: Container(
                 color: Colors.black.withValues(alpha: 0.2), 
               ),
             ),
           ),
        // RepaintBoundary to isolate app content from background animation
        RepaintBoundary(child: widget.child),
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
    this.isRelaxed = false,
  });

  final KnightDayPeriod period;
  final KnightDayPeriod previousPeriod;
  final double transitionProgress;
  final double motionProgress;
  final bool isRelaxed;

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
    
    // 3. Apply Cinematic Vignette
    _drawVignette(canvas, size);
  }

  void _drawVignette(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black.withValues(alpha: isRelaxed ? 0.6 : 0.4)],
        stops: const [0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Offset.zero & size, paint);
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
      case KnightDayPeriod.morning:
        _drawMorning(canvas, size, opacity);
        break;
      case KnightDayPeriod.day:
        _drawDay(canvas, size, opacity);
        break;
      case KnightDayPeriod.afternoon:
        _drawAfternoon(canvas, size, opacity);
        break;
      case KnightDayPeriod.evening:
        _drawEvening(canvas, size, opacity);
        break;
      case KnightDayPeriod.night:
        _drawNight(canvas, size, opacity);
        break;
      case KnightDayPeriod.lateNight:
        _drawLateNight(canvas, size, opacity);
        break;
    }
  }

  void _drawMorning(Canvas canvas, Size size, double opacity) {
    // Sunrise glow (Enhanced)
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFDE68A).withValues(alpha: 0.15 * opacity), 
          Colors.transparent
        ],
      ).createShader(Rect.fromLTWH(-size.width * 0.2, -size.height * 0.2, size.width * 0.8, size.height * 0.8));
    canvas.drawRect(Offset.zero & size, paint);

    // Subtle Sunlight Rays
    final rayPaint = Paint()
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 3; i++) {
      final rayOpacity = 0.03 * opacity * (0.5 + 0.5 * sin(motionProgress * 2 * pi + i));
      rayPaint.color = const Color(0xFFFDE68A).withValues(alpha: rayOpacity);
      
      final path = Path()
        ..moveTo(0, 0)
        ..lineTo(size.width * (0.2 + i * 0.3), size.height)
        ..lineTo(size.width * (0.4 + i * 0.3), size.height)
        ..close();
      canvas.drawPath(path, rayPaint);
    }

    // Soft Morning Mist
    final mistPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02 * opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3), mistPaint);

    // Subtle birds
    for (var i = 0; i < 4; i++) {
      final x = (size.width * (motionProgress * 0.15 + i * 0.25)) % (size.width + 200) - 100;
      final y = size.height * (0.15 + i * 0.05);
      _drawBird(canvas, Offset(x, y), 8, opacity * 0.5);
    }
  }

  void _drawDay(Canvas canvas, Size size, double opacity) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04 * opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    
    // Soft clouds
    for (var i = 0; i < 3; i++) {
      final x = (size.width * (motionProgress * 0.1 + i * 0.3)) % (size.width + 600) - 300;
      final y = size.height * (0.1 + i * 0.15);
      canvas.drawOval(Rect.fromCenter(center: Offset(x, y), width: 300, height: 100), paint);
    }
  }

  void _drawAfternoon(Canvas canvas, Size size, double opacity) {
    // Light particles
    final rand = Random(88);
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (var i = 0; i < 20; i++) {
      final startX = rand.nextDouble() * size.width;
      final startY = rand.nextDouble() * size.height;
      final x = (startX + sin(motionProgress * 2 * pi + i) * 20) % size.width;
      final y = (startY - motionProgress * 100 - i * 10) % size.height;
      
      paint.color = Colors.white.withValues(alpha: 0.05 * opacity * rand.nextDouble());
      canvas.drawCircle(Offset(x, y), rand.nextDouble() * 2 + 1, paint);
    }
  }

  void _drawEvening(Canvas canvas, Size size, double opacity) {
    // Sunset transition
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [const Color(0xFFFB923C).withValues(alpha: 0.1 * opacity), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5));
    canvas.drawRect(Offset.zero & size, paint);

    // Birds returning
    for (var i = 0; i < 3; i++) {
      final x = size.width - ((size.width * (motionProgress * 0.1 + i * 0.3)) % (size.width + 200));
      final y = size.height * (0.3 + i * 0.08);
      _drawBird(canvas, Offset(x, y), 6, opacity * 0.4);
    }
  }

  void _drawNight(Canvas canvas, Size size, double opacity) {
    final rand = Random(42);
    final paint = Paint()..color = Colors.white;

    // Stars
    for (var i = 0; i < 80; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height * 0.8;
      final sparkle = 0.4 + 0.6 * sin(motionProgress * 4 * pi + i);
      final alpha = (0.1 + rand.nextDouble() * 0.4) * sparkle * opacity;
      paint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), rand.nextDouble() * 1.2, paint);
    }

    // Rare shooting star
    if (motionProgress > 0.8 && motionProgress < 0.82) {
      final p = (motionProgress - 0.8) / 0.02;
      final start = Offset(size.width * 0.7, size.height * 0.1);
      final end = Offset(size.width * 0.3, size.height * 0.3);
      final pos = Offset.lerp(start, end, p)!;
      
      final streakPaint = Paint()
        ..shader = LinearGradient(
          colors: [Colors.white.withValues(alpha: opacity), Colors.transparent],
        ).createShader(Rect.fromPoints(pos, pos - const Offset(50, -20)));
      
      canvas.drawLine(pos, pos - const Offset(40, -15), streakPaint);
    }
  }

  void _drawLateNight(Canvas canvas, Size size, double opacity) {
    final rand = Random(99);
    final paint = Paint()..color = Colors.white;

    // Sparse stars
    for (var i = 0; i < 30; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height * 0.6;
      final sparkle = 0.3 + 0.7 * sin(motionProgress * 2 * pi + i);
      paint.color = Colors.white.withValues(alpha: 0.2 * sparkle * opacity);
      canvas.drawCircle(Offset(x, y), 0.8, paint);
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
