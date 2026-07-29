import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:knight_os/core/theme/knight_theme_extensions.dart';

class PremiumCTA extends StatefulWidget {
  const PremiumCTA({super.key, required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  State<PremiumCTA> createState() => _PremiumCTAState();
}

class _PremiumCTAState extends State<PremiumCTA> with TickerProviderStateMixin {
  bool _isPressed = false;

  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    // Entrance Animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Subtle Glow Pulse (Almost imperceptible, 8s duration)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _glow = Tween<double>(begin: 0.1, end: 0.16).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    // Flagship Delay: Appears after complete mission reveal (~3200ms)
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final premiumTheme = theme.extension<KnightPremiumTheme>();

    final accentColor = premiumTheme?.accentColor ?? Colors.white;
    final glassBlur = premiumTheme?.glassBlur ?? 20.0;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: widget.onPressed,
            child: AnimatedScale(
              scale: _isPressed ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack, // Spring back
              child: AnimatedBuilder(
                animation: _glow,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: _glow.value),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: glassBlur + 10, // Increased
                      sigmaY: glassBlur + 10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.28,
                          ), // Brighter
                          width: 1.5,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.18),
                            Colors.white.withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: accentColor.withValues(alpha: 1.0),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
