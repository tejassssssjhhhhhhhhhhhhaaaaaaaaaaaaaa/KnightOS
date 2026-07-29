import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/design_system/design_constants.dart';

class VoiceWaveform extends StatefulWidget {
  const VoiceWaveform({required this.isActive, super.key});

  final bool isActive;

  @override
  State<VoiceWaveform> createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<VoiceWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(VoiceWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
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
        return CustomPaint(
          size: const Size(double.infinity, 100),
          painter: _WaveformPainter(
            animationValue: _controller.value,
            isActive: widget.isActive,
            color: DesignColors.accentBlue,
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.animationValue,
    required this.isActive,
    required this.color,
  });

  final double animationValue;
  final bool isActive;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: isActive ? 0.8 : 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final centerY = size.height / 2;
    final width = size.width;

    for (int i = 0; i < 50; i++) {
      final double progress = i / 50;
      final double xPos = progress * width;
      
      double amplitude = 20.0;
      if (isActive) {
        amplitude = 20.0 + sin(animationValue * 2 * pi + i) * 15;
      }

      final double yPos = centerY + sin(progress * 4 * pi + animationValue * 5) * amplitude;
      
      if (i == 0) {
        path.moveTo(xPos, yPos);
      } else {
        path.lineTo(xPos, yPos);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
