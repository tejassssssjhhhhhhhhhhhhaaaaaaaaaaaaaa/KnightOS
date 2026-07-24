import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _transitionController;
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentOffset;
  late final Animation<double> _buttonOpacity;
  late final Animation<double> _backgroundZoom;
  late final Animation<double> _backgroundShift;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _transitionController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _contentOpacity = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic));
    _contentOffset = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic)),
    );
    _buttonOpacity = CurvedAnimation(parent: _controller, curve: const Interval(0.72, 1.0, curve: Curves.easeOutCubic));
    _backgroundZoom = Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _transitionController, curve: Curves.easeOutCubic));
    _backgroundShift = Tween<double>(begin: 0.0, end: 0.12).animate(CurvedAnimation(parent: _transitionController, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  Future<void> _handleGetStarted() async {
    if (_isTransitioning) return;
    setState(() => _isTransitioning = true);
    await _transitionController.forward();
    if (!mounted) return;
    context.go(AppRoutes.auth);
  }

  _TimeWindow _currentTimeWindow() {
    final hour = DateTime.now().hour;
    if (hour < 12) return _TimeWindow.morning;
    if (hour < 18) return _TimeWindow.afternoon;
    if (hour < 22) return _TimeWindow.evening;
    return _TimeWindow.night;
  }

  String _greeting() {
    switch (_currentTimeWindow()) {
      case _TimeWindow.morning:
        return 'Good Morning';
      case _TimeWindow.afternoon:
        return 'Good Afternoon';
      case _TimeWindow.evening:
        return 'Good Evening';
      case _TimeWindow.night:
        return 'Good Night';
    }
  }

  List<Color> _backgroundColors() {
    switch (_currentTimeWindow()) {
      case _TimeWindow.morning:
        return const [Color(0xFFF5D9A4), Color(0xFFB2D2E7), Color(0xFF6C8FAE)];
      case _TimeWindow.afternoon:
        return const [Color(0xFF7EC0FF), Color(0xFFBCE7FF), Color(0xFF7AA4C6)];
      case _TimeWindow.evening:
        return const [Color(0xFFFFB36B), Color(0xFF8E4E2D), Color(0xFF2C2336)];
      case _TimeWindow.night:
        return const [Color(0xFF07111E), Color(0xFF15253F), Color(0xFF23405F)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColors = _backgroundColors();
    final timeWindow = _currentTimeWindow();
    final contentOpacity = _isTransitioning ? 1 - _transitionController.value : _contentOpacity.value;
    final contentOffset = _isTransitioning ? const Offset(0, 0.0) : _contentOffset.value;

    return Scaffold(
      backgroundColor: backgroundColors.first,
      body: AnimatedBuilder(
        animation: Listenable.merge([_controller, _transitionController]),
        builder: (context, child) {
          final zoom = _isTransitioning ? _backgroundZoom.value : 1.0;
          final shift = _isTransitioning ? _backgroundShift.value : 0.0;
          final glowOpacity = timeWindow == _TimeWindow.night ? 0.18 : 0.12;
          return Stack(
            children: [
              Positioned.fill(
                child: Transform.scale(
                  scale: zoom,
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: backgroundColors,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 72 + shift * 120,
                          right: 48,
                          child: _DecorativeOrb(
                            color: timeWindow == _TimeWindow.night ? Colors.white.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.28),
                            size: timeWindow == _TimeWindow.night ? 120 : 140,
                          ),
                        ),
                        Positioned(
                          bottom: -40 + shift * 40,
                          left: -60,
                          right: -60,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 700),
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(60)),
                              color: theme.colorScheme.surface.withValues(alpha: timeWindow == _TimeWindow.night ? 0.14 : 0.18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 24,
                                  offset: const Offset(0, -6),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _WelcomeBackgroundPainter(
                              timeWindow: timeWindow,
                              progress: _controller.value,
                              shift: shift,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: glowOpacity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment.topCenter,
                                    radius: 1.1,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.16),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 700),
                            opacity: contentOpacity,
                            child: Transform.translate(
                              offset: Offset(0, 18 * (1 - contentOpacity) + contentOffset.dy * 24),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
                                ),
                                child: Text(
                                  'KnightOS',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    letterSpacing: 1.8,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 700),
                            opacity: contentOpacity,
                            child: Transform.translate(
                              offset: Offset(0, 18 * (1 - contentOpacity) + contentOffset.dy * 24),
                              child: Text(
                                _greeting(),
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 700),
                            opacity: contentOpacity,
                            child: Transform.translate(
                              offset: Offset(0, 18 * (1 - contentOpacity) + contentOffset.dy * 24),
                              child: Text(
                                'Welcome to KnightOS',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 700),
                            opacity: contentOpacity,
                            child: Transform.translate(
                              offset: Offset(0, 16 * (1 - contentOpacity) + contentOffset.dy * 24),
                              child: Text(
                                'Your AI-powered Life Operating System',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.86),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 34),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 700),
                            opacity: _isTransitioning ? 1 - _transitionController.value : _buttonOpacity.value,
                            child: Transform.translate(
                              offset: Offset(0, 12 * (1 - _buttonOpacity.value) + (_isTransitioning ? 8 * _transitionController.value : 0)),
                              child: SizedBox(
                                width: 220,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _handleGetStarted,
                                      borderRadius: BorderRadius.circular(999),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(999),
                                          color: Colors.white.withValues(alpha: 0.95),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.16),
                                              blurRadius: 24,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.rocket_launch_rounded, color: Color(0xFF1F2D3D)),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Get Started',
                                              style: theme.textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF1F2D3D),
                                              ),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DecorativeOrb extends StatelessWidget {
  const _DecorativeOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 8,
          ),
        ],
      ),
    );
  }
}

class _WelcomeBackgroundPainter extends CustomPainter {
  const _WelcomeBackgroundPainter({required this.timeWindow, required this.progress, required this.shift});

  final _TimeWindow timeWindow;
  final double progress;
  final double shift;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width * 0.5, size.height * 0.72);

    switch (timeWindow) {
      case _TimeWindow.morning:
        paint.color = Colors.white.withValues(alpha: 0.16);
        canvas.drawCircle(center, size.height * 0.10 + progress * 4, paint);
        final wave = Path();
        wave.moveTo(0, size.height * 0.78);
        for (var x = 0.0; x <= size.width; x += 18) {
          final y = size.height * 0.78 + math.sin((x / 82) + progress * 2) * 10 + shift * 10;
          wave.lineTo(x, y);
        }
        wave.lineTo(size.width, size.height);
        wave.lineTo(0, size.height);
        wave.close();
        paint.color = Colors.white.withValues(alpha: 0.12);
        canvas.drawPath(wave, paint);
        break;
      case _TimeWindow.afternoon:
        paint.color = Colors.white.withValues(alpha: 0.12);
        canvas.drawCircle(center, size.height * 0.09, paint);
        final wave = Path();
        wave.moveTo(0, size.height * 0.79);
        for (var x = 0.0; x <= size.width; x += 20) {
          final y = size.height * 0.79 + math.cos((x / 90) + progress * 1.2) * 8 + shift * 6;
          wave.lineTo(x, y);
        }
        wave.lineTo(size.width, size.height);
        wave.lineTo(0, size.height);
        wave.close();
        paint.color = Colors.white.withValues(alpha: 0.10);
        canvas.drawPath(wave, paint);
        break;
      case _TimeWindow.evening:
        paint.color = Colors.white.withValues(alpha: 0.12);
        canvas.drawCircle(center, size.height * 0.08, paint);
        final wave = Path();
        wave.moveTo(0, size.height * 0.80);
        for (var x = 0.0; x <= size.width; x += 16) {
          final y = size.height * 0.80 + math.sin((x / 70) + progress * 1.4) * 9 + shift * 5;
          wave.lineTo(x, y);
        }
        wave.lineTo(size.width, size.height);
        wave.lineTo(0, size.height);
        wave.close();
        paint.color = Colors.white.withValues(alpha: 0.10);
        canvas.drawPath(wave, paint);
        break;
      case _TimeWindow.night:
        for (var i = 0; i < 10; i++) {
          final x = (size.width / 10) * i + (progress * 12);
          final y = 90 + (i % 3) * 34;
          paint.color = Colors.white.withValues(alpha: 0.18);
          canvas.drawCircle(Offset(x % size.width, y.toDouble()), 1.6, paint);
        }
        paint.color = Colors.white.withValues(alpha: 0.12);
        canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.2), 26, paint);
        final wave = Path();
        wave.moveTo(0, size.height * 0.81);
        for (var x = 0.0; x <= size.width; x += 24) {
          final y = size.height * 0.81 + math.sin((x / 100) + progress * 1.1) * 7 + shift * 4;
          wave.lineTo(x, y);
        }
        wave.lineTo(size.width, size.height);
        wave.lineTo(0, size.height);
        wave.close();
        paint.color = Colors.white.withValues(alpha: 0.08);
        canvas.drawPath(wave, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _WelcomeBackgroundPainter oldDelegate) {
    return oldDelegate.timeWindow != timeWindow || oldDelegate.progress != progress || oldDelegate.shift != shift;
  }
}

enum _TimeWindow { morning, afternoon, evening, night }
