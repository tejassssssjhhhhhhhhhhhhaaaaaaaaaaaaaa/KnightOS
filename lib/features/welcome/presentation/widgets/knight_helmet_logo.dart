import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class KnightHelmetLogo extends StatelessWidget {
  const KnightHelmetLogo({this.size = 100, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HelmetPainter(),
      ),
    );
  }
}

class _HelmetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          DesignColors.accentBlue,
          DesignColors.accentBlue.withOpacity(0.7),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Draw a stylized helmet shape
    final w = size.width;
    final h = size.height;
    
    // Crest/Top
    path.moveTo(w * 0.5, h * 0.05);
    path.quadraticBezierTo(w * 0.8, h * 0.1, w * 0.85, h * 0.4);
    
    // Side/Back
    path.lineTo(w * 0.85, h * 0.7);
    path.quadraticBezierTo(w * 0.8, h * 0.9, w * 0.55, h * 0.95);
    
    // Neck
    path.lineTo(w * 0.5, h * 0.85); // Pointy center bottom
    
    // Mirror to left side
    path.lineTo(w * 0.45, h * 0.95);
    path.quadraticBezierTo(w * 0.2, h * 0.9, w * 0.15, h * 0.7);
    path.lineTo(w * 0.15, h * 0.4);
    path.quadraticBezierTo(w * 0.2, h * 0.1, w * 0.5, h * 0.05);
    
    // Faceplate opening (negative space)
    final opening = Path();
    opening.moveTo(w * 0.5, h * 0.3);
    opening.lineTo(w * 0.7, h * 0.4);
    opening.lineTo(w * 0.7, h * 0.6);
    opening.lineTo(w * 0.5, h * 0.7);
    opening.lineTo(w * 0.3, h * 0.6);
    opening.lineTo(w * 0.3, h * 0.4);
    opening.close();

    final finalPath = Path.combine(PathOperation.difference, path, opening);
    
    // Add some glow
    canvas.drawShadow(finalPath, DesignColors.accentBlue.withOpacity(0.5), 10, true);
    canvas.drawPath(finalPath, paint);
    
    // Add a subtle border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(finalPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
