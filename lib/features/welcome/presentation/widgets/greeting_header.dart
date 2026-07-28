import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GreetingHeader extends StatefulWidget {
  const GreetingHeader({super.key, required this.greeting});

  final String greeting;

  @override
  State<GreetingHeader> createState() => _GreetingHeaderState();
}

class _GreetingHeaderState extends State<GreetingHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _greetingOpacity;
  late final Animation<Offset> _greetingSlide;

  late final Animation<double> _line1Opacity;
  late final Animation<Offset> _line1Slide;

  late final Animation<double> _line2Opacity;
  late final Animation<Offset> _line2Slide;

  late final Animation<double> _line3Opacity;
  late final Animation<Offset> _line3Slide;

  @override
  void initState() {
    super.initState();
    // Total Duration adjusted for 300ms intervals effectively
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // EaseOutCubic for all
    const curve = Curves.easeOutCubic;

    // Greeting: 0ms - 800ms
    _greetingOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.22, curve: Curves.easeIn),
    );
    _greetingSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.25, curve: curve),
          ),
        );

    // Line 1: 800ms - 1300ms (~300ms pause after greeting finish)
    _line1Opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.42, curve: Curves.easeIn),
    );
    _line1Slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.28, 0.45, curve: curve),
          ),
        );

    // Line 2: 1300ms - 1800ms (Interval includes ~300ms pause from previous)
    _line2Opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.48, 0.62, curve: Curves.easeIn),
    );
    _line2Slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.48, 0.65, curve: curve),
          ),
        );

    // Line 3: 1800ms - 2300ms
    _line3Opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.68, 0.82, curve: Curves.easeIn),
    );
    _line3Slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.68, 0.85, curve: curve),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary Hero
        FadeTransition(
          opacity: _greetingOpacity,
          child: SlideTransition(
            position: _greetingSlide,
            child: Text(
              widget.greeting,
              style: GoogleFonts.inter(
                fontSize: 62, // Further refined
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -2.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 48), // Flagship breathing room
        // Limited width for maximum readability
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            children: [
              _AnimatedMissionLine(
                text: 'Your Life.',
                opacity: _line1Opacity,
                slide: _line1Slide,
              ),
              const SizedBox(height: 12),
              _AnimatedMissionLine(
                text: 'One System.',
                opacity: _line2Opacity,
                slide: _line2Slide,
              ),
              const SizedBox(height: 12),
              _AnimatedMissionLine(
                text: 'Infinite Discipline.',
                opacity: _line3Opacity,
                slide: _line3Slide,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedMissionLine extends StatelessWidget {
  const _AnimatedMissionLine({
    required this.text,
    required this.opacity,
    required this.slide,
  });

  final String text;
  final Animation<double> opacity;
  final Animation<Offset> slide;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: slide,
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 22, // Flagship size
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.95), // High contrast
            letterSpacing: 0.2,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
