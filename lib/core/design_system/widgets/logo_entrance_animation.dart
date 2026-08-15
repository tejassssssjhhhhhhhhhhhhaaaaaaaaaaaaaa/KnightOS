import 'package:flutter/material.dart';
import 'knight_circuit_shield.dart';
import '../../internal/services/greeting_service.dart';

class LogoEntranceAnimation extends StatefulWidget {
  const LogoEntranceAnimation({
    required this.period,
    this.size = 120,
    super.key,
  });

  final KnightDayPeriod period;
  final double size;

  @override
  State<LogoEntranceAnimation> createState() => _LogoEntranceAnimationState();
}

class _LogoEntranceAnimationState extends State<LogoEntranceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

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
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Subtle Glow
                Container(
                  width: widget.size * 1.5,
                  height: widget.size * 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1 * _glowAnimation.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                KnightCircuitShield(
                  size: widget.size,
                  period: widget.period,
                  state: _controller.value < 0.5 ? ShieldState.thinking : ShieldState.idle,
                  animationValue: _controller.value,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
