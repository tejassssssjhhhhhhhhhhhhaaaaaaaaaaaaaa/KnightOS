import 'package:flutter/material.dart';
import '../../internal/services/greeting_service.dart';
import '../knight_tokens.dart';

enum ShieldState { idle, listening, thinking, speaking, syncing, offline, perception }

class KnightCircuitShield extends StatelessWidget {
  const KnightCircuitShield({
    this.size = 100,
    required this.period,
    this.state = ShieldState.idle,
    this.animationValue = 0.0,
    super.key,
  });

  final double size;
  final KnightDayPeriod period;
  final ShieldState state;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Knight Circuit Shield',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CircuitShieldPainter(
            period: period,
            state: state,
            animationValue: animationValue,
          ),
        ),
      ),
    );
  }
}

class _CircuitShieldPainter extends CustomPainter {
  _CircuitShieldPainter({
    required this.period,
    required this.state,
    required this.animationValue,
  });

  final KnightDayPeriod period;
  final ShieldState state;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final materialColors = _getMaterialColors(period);
    final accentColor = KnightTokens.accent(period);

    // 1. Draw Shield Path (Concept 08 - Premium Hex/Shield hybrid)
    final shieldPath = Path();
    shieldPath.moveTo(w * 0.5, h * 0.02); // Top Center
    shieldPath.lineTo(w * 0.92, h * 0.15); // Top Right
    shieldPath.lineTo(w * 0.98, h * 0.45); // Middle Right
    shieldPath.lineTo(w * 0.92, h * 0.75); // Bottom Right
    shieldPath.quadraticBezierTo(w * 0.5, h * 0.98, w * 0.5, h * 1.0); // Bottom Center Point
    shieldPath.quadraticBezierTo(w * 0.5, h * 0.98, w * 0.08, h * 0.75); // Bottom Left
    shieldPath.lineTo(w * 0.02, h * 0.45); // Middle Left
    shieldPath.lineTo(w * 0.08, h * 0.15); // Top Left
    shieldPath.close();

    // 2. Base Material with Depth
    final mainPaint = Paint()
      ..shader = LinearGradient(
        colors: materialColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(shieldPath, mainPaint);

    // 3. Draw Sophisticated Circuit Paths (Concept 08)
    _drawConcept08Circuits(canvas, size, accentColor);

    // 4. Draw Ambient Reflections
    _drawReflections(canvas, size);

    // 5. Draw State Overlay (Glow/Pulse)
    _drawStateOverlay(canvas, size, accentColor);

    // 6. Specular Highlight (Rim)
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = Colors.white.withValues(alpha: period == KnightDayPeriod.night ? 0.15 : 0.3);
    canvas.drawPath(shieldPath, rimPaint);
  }

  List<Color> _getMaterialColors(KnightDayPeriod period) {
    switch (period) {
      case KnightDayPeriod.morning: 
        return [const Color(0xFFFDE68A), const Color(0xFFF59E0B), const Color(0xFFD97706)]; // Warm Gold
      case KnightDayPeriod.day:
        return [const Color(0xFFF1F5F9), const Color(0xFFCBD5E1), const Color(0xFF94A3B8)]; // Silver
      case KnightDayPeriod.afternoon:
        return [const Color(0xFFE2E8F0), const Color(0xFF94A3B8), const Color(0xFF64748B)]; // Mid-Day Silver
      case KnightDayPeriod.evening:
        return [const Color(0xFFFB923C), const Color(0xFFEA580C), const Color(0xFF9A3412)]; // Copper
      case KnightDayPeriod.night:
        return [const Color(0xFF1E293B), const Color(0xFF0F172A), const Color(0xFF020617)]; // Slate to Dark
      case KnightDayPeriod.lateNight:
        return [const Color(0xFF0F172A), const Color(0xFF020408), const Color(0xFF000000)]; // Deep Slate to Black
    }
  }

  void _drawConcept08Circuits(Canvas canvas, Size size, Color color) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color.withValues(alpha: period == KnightDayPeriod.night ? 0.7 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.015
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Central Hex Hub
    final hubRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.55), width: w * 0.25, height: h * 0.25);
    path.addOval(hubRect); // Simplified hub

    // Radiating Circuit Traces
    // Top Left Branch
    path.moveTo(w * 0.38, h * 0.48);
    path.lineTo(w * 0.25, h * 0.35);
    path.lineTo(w * 0.25, h * 0.20);
    
    // Top Right Branch
    path.moveTo(w * 0.62, h * 0.48);
    path.lineTo(w * 0.75, h * 0.35);
    path.lineTo(w * 0.75, h * 0.20);

    // Bottom Trace
    path.moveTo(w * 0.5, h * 0.68);
    path.lineTo(w * 0.5, h * 0.85);

    canvas.drawPath(path, paint);

    // Nodes at terminals
    final nodePaint = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.25, h * 0.20), w * 0.02, nodePaint);
    canvas.drawCircle(Offset(w * 0.75, h * 0.20), w * 0.02, nodePaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.85), w * 0.02, nodePaint);

    if (state != ShieldState.idle && state != ShieldState.offline) {
       final flowPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.02
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);
      canvas.drawPath(path, flowPaint);
      
      // Radiant energy dots
      final activeNodePaint = Paint()
        ..color = Colors.white
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(w * 0.5, h * 0.55), w * 0.03 * animationValue, activeNodePaint);
    }
  }

  void _drawReflections(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.12), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.center,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    
    canvas.drawOval(Rect.fromLTWH(w * 0.2, h * 0.05, w * 0.6, h * 0.25), paint);
  }

  void _drawStateOverlay(Canvas canvas, Size size, Color accent) {
    final w = size.width;
    final h = size.height;

    if (state == ShieldState.listening) {
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = accent.withValues(alpha: 0.8 * (1.0 - animationValue));
      canvas.drawCircle(Offset(w / 2, h / 2), (w * 0.45) + (20 * animationValue), ringPaint);
    }

    if (state == ShieldState.speaking) {
       final pulsePaint = Paint()
        ..color = accent.withValues(alpha: 0.4 * (1.0 - animationValue))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
      canvas.drawCircle(Offset(w / 2, h / 2), w * 0.5, pulsePaint);
    }
    
    if (state == ShieldState.thinking) {
       final rotatePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
       
       canvas.save();
       canvas.translate(w/2, h/2);
       canvas.rotate(animationValue * 2 * 3.14159);
       canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: w * 0.35), 0, 1, false, rotatePaint);
       canvas.restore();
    }

    if (state == ShieldState.perception) {
       final perceptionPaint = Paint()
        ..color = accent.withValues(alpha: 0.3 + (0.2 * animationValue))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      
      final rect = Rect.fromCenter(center: Offset(w / 2, h / 2), width: w * 0.8, height: h * 0.8);
      canvas.drawOval(rect, perceptionPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircuitShieldPainter oldDelegate) {
    return oldDelegate.period != period ||
        oldDelegate.state != state ||
        oldDelegate.animationValue != animationValue;
  }
}
