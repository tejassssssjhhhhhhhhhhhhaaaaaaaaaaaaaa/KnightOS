import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

class IndiaTravelMap extends StatelessWidget {
  const IndiaTravelMap({
    super.key,
    required this.trips,
    this.onTripTap,
  });

  final List<TripData> trips;
  final Function(TripData)? onTripTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DesignColors.white05),
        boxShadow: [
          BoxShadow(
            color: DesignColors.travel.withValues(alpha: 0.05),
            blurRadius: 40,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Base Layer: India Outline
            Positioned.fill(
              child: CustomPaint(
                painter: _IndiaMapPainter(),
              ),
            ),
            // Interaction Layer: Cities & Routes
            Positioned.fill(
              child: _MapInteractionLayer(trips: trips, onTripTap: onTripTap),
            ),
            // Overlay Info
            const Positioned(
              top: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('INDIA EXPLORER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: DesignColors.travel)),
                  SizedBox(height: 4),
                  Text('2.5D RELATIONAL VIZ', style: TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapInteractionLayer extends StatelessWidget {
  const _MapInteractionLayer({required this.trips, this.onTripTap});
  final List<TripData> trips;
  final Function(TripData)? onTripTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<Widget> markers = [];
        
        // Map common Indian cities to relative coordinates (0.0 to 1.0)
        final cityCoords = {
          'Delhi': const Offset(0.42, 0.28),
          'Mumbai': const Offset(0.28, 0.65),
          'Bangalore': const Offset(0.45, 0.82),
          'Chennai': const Offset(0.55, 0.84),
          'Kolkata': const Offset(0.82, 0.48),
          'Hyderabad': const Offset(0.48, 0.68),
          'Goa': const Offset(0.32, 0.78),
          'Ahmedabad': const Offset(0.26, 0.48),
          'Pune': const Offset(0.32, 0.68),
          'Jaipur': const Offset(0.38, 0.38),
        };

        for (final trip in trips) {
          final cityName = _detectCity(trip.title);
          final coord = cityCoords[cityName];
          
          if (coord != null) {
            markers.add(
              Positioned(
                left: coord.dx * constraints.maxWidth - 12,
                top: coord.dy * constraints.maxHeight - 12,
                child: _CityMarker(
                  trip: trip,
                  onTap: () => onTripTap?.call(trip),
                ),
              ),
            );
          }
        }

        return Stack(children: markers);
      },
    );
  }

  String _detectCity(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('delhi')) return 'Delhi';
    if (lower.contains('mumbai')) return 'Mumbai';
    if (lower.contains('bangalore') || lower.contains('bengaluru')) return 'Bangalore';
    if (lower.contains('chennai')) return 'Chennai';
    if (lower.contains('kolkata')) return 'Kolkata';
    if (lower.contains('hyderabad')) return 'Hyderabad';
    if (lower.contains('goa')) return 'Goa';
    if (lower.contains('ahmedabad')) return 'Ahmedabad';
    if (lower.contains('pune')) return 'Pune';
    if (lower.contains('jaipur')) return 'Jaipur';
    return 'Unknown';
  }
}

class _CityMarker extends StatefulWidget {
  const _CityMarker({required this.trip, required this.onTap});
  final TripData trip;
  final VoidCallback onTap;

  @override
  State<_CityMarker> createState() => _CityMarkerState();
}

class _CityMarkerState extends State<_CityMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DesignColors.travel.withValues(alpha: (1.0 - _controller.value) * 0.5),
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: DesignColors.travel,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: DesignColors.travel.withValues(alpha: 0.8), blurRadius: 10, spreadRadius: 2),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IndiaMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Simplified India Polygon Coordinates (Relative 0-1)
    final path = Path();
    path.moveTo(size.width * 0.45, size.height * 0.05); // North
    path.lineTo(size.width * 0.55, size.height * 0.15);
    path.lineTo(size.width * 0.95, size.height * 0.45); // East
    path.lineTo(size.width * 0.85, size.height * 0.65);
    path.lineTo(size.width * 0.55, size.height * 0.95); // South
    path.lineTo(size.width * 0.45, size.height * 0.95);
    path.lineTo(size.width * 0.15, size.height * 0.65); // West
    path.lineTo(size.width * 0.05, size.height * 0.45);
    path.lineTo(size.width * 0.25, size.height * 0.15);
    path.close();

    // 2.5D Depth Effect (Subtle shadow shift)
    canvas.save();
    canvas.translate(4, 4);
    canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: 0.2));
    canvas.restore();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, outlinePaint);

    // Draw Grid Lines
    final gridPaint = Paint()..color = Colors.white.withValues(alpha: 0.02)..strokeWidth = 0.5;
    for (var i = 1; i < 10; i++) {
      canvas.drawLine(Offset(0, size.height * i / 10), Offset(size.width, size.height * i / 10), gridPaint);
      canvas.drawLine(Offset(size.width * i / 10, 0), Offset(size.width * i / 10, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
