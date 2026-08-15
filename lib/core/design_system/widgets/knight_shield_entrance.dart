import 'package:flutter/material.dart';
import 'knight_circuit_shield.dart';
import '../../internal/services/greeting_service.dart';

class KnightShieldEntrance extends StatefulWidget {
  const KnightShieldEntrance({
    required this.onComplete,
    this.size = 180,
    super.key,
  });

  final VoidCallback onComplete;
  final double size;

  @override
  State<KnightShieldEntrance> createState() => _KnightShieldEntranceState();
}

class _KnightShieldEntranceState extends State<KnightShieldEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _illuminationAnimation;
  late final Animation<double> _mechanicalAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 1.05).chain(CurveTween(curve: Curves.easeOut)), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 70),
    ]).animate(_controller);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _illuminationAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.4), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.4, end: 0.8), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8)));

    _mechanicalAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), widget.onComplete);
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Internal Illumination Glow
                  Container(
                    width: widget.size * 1.8,
                    height: widget.size * 1.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.blueAccent.withValues(alpha: 0.15 * _illuminationAnimation.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // The Shield
                  KnightCircuitShield(
                    size: widget.size,
                    period: KnightDayPeriod.night, // Futuristic feel
                    state: _controller.value < 0.6 ? ShieldState.thinking : ShieldState.perception,
                    animationValue: _mechanicalAnimation.value,
                  ),
                  // Subtle Technical Movement (Overlay)
                  if (_controller.value > 0.4)
                    CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: _MechanicalOverlayPainter(
                        progress: _mechanicalAnimation.value,
                        opacity: _opacityAnimation.value,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MechanicalOverlayPainter extends CustomPainter {
  final double progress;
  final double opacity;

  _MechanicalOverlayPainter({required this.progress, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1 * opacity * (1.0 - progress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Subtle expanding technical rings
    canvas.drawCircle(Offset(w / 2, h / 2), (w * 0.4) + (w * 0.2 * progress), paint);
    canvas.drawCircle(Offset(w / 2, h / 2), (w * 0.45) + (w * 0.1 * progress), paint);
  }

  @override
  bool shouldRepaint(covariant _MechanicalOverlayPainter oldDelegate) => 
      oldDelegate.progress != progress || oldDelegate.opacity != opacity;
}
