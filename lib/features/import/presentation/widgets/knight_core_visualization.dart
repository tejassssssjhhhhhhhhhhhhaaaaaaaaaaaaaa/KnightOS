import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/design_system/widgets/knight_circuit_shield.dart';
import '../../../../core/internal/services/greeting_service.dart';

enum SourceStatus { connected, syncing, processing, upToDate, attention, error, notConnected }

class ConnectedSource {
  final String id;
  final String label;
  final IconData icon;
  final SourceStatus status;

  ConnectedSource({
    required this.id,
    required this.label,
    required this.icon,
    required this.status,
  });
}

class KnightCoreVisualization extends StatefulWidget {
  const KnightCoreVisualization({
    required this.sources,
    this.size = 350,
    super.key,
  });

  final List<ConnectedSource> sources;
  final double size;

  @override
  State<KnightCoreVisualization> createState() => _KnightCoreVisualizationState();
}

class _KnightCoreVisualizationState extends State<KnightCoreVisualization>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient connections (lines)
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _ConnectionLinePainter(
              sourceCount: widget.sources.length,
              rotation: _controller.value,
            ),
          ),
          // Central Core
          KnightCircuitShield(
            size: widget.size * 0.35,
            period: KnightDayPeriod.night,
            state: widget.sources.any((s) => s.status == SourceStatus.syncing || s.status == SourceStatus.processing)
                ? ShieldState.syncing
                : ShieldState.idle,
            animationValue: _controller.value,
          ),
          // Radiating Sources
          ...widget.sources.asMap().entries.map((entry) {
            final index = entry.key;
            final source = entry.value;
            final angle = (index / widget.sources.length) * 2 * math.pi;
            final radius = widget.size * 0.4;

            return _SourceIcon(
              source: source,
              offset: Offset(
                radius * math.cos(angle),
                radius * math.sin(angle),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SourceIcon extends StatelessWidget {
  const _SourceIcon({required this.source, required this.offset});
  final ConnectedSource source;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(source.status);
    
    return Transform.translate(
      offset: offset,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 10, spreadRadius: 1),
              ],
            ),
            child: Icon(source.icon, color: color, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            source.label.toUpperCase(),
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
          _StatusIndicator(status: source.status),
        ],
      ),
    );
  }

  Color _getStatusColor(SourceStatus status) {
    switch (status) {
      case SourceStatus.connected: return Colors.blueAccent;
      case SourceStatus.syncing:
      case SourceStatus.processing: return Colors.cyanAccent;
      case SourceStatus.upToDate: return Colors.greenAccent;
      case SourceStatus.attention: return Colors.orangeAccent;
      case SourceStatus.error: return Colors.redAccent;
      case SourceStatus.notConnected: return Colors.white10;
    }
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.status});
  final SourceStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name.toUpperCase().replaceAll('UPTODATE', 'UP TO DATE'),
        style: TextStyle(
          fontSize: 6,
          fontWeight: FontWeight.bold,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(SourceStatus status) {
    switch (status) {
      case SourceStatus.connected: return Colors.blueAccent;
      case SourceStatus.syncing:
      case SourceStatus.processing: return Colors.cyanAccent;
      case SourceStatus.upToDate: return Colors.greenAccent;
      case SourceStatus.attention: return Colors.orangeAccent;
      case SourceStatus.error: return Colors.redAccent;
      case SourceStatus.notConnected: return Colors.white10;
    }
  }
}

class _ConnectionLinePainter extends CustomPainter {
  final int sourceCount;
  final double rotation;

  _ConnectionLinePainter({required this.sourceCount, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < sourceCount; i++) {
      final angle = (i / sourceCount) * 2 * math.pi;
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      // Draw dashed connection line
      _drawDashedLine(canvas, center, end, paint);
    }
    
    // Ambient rotating rings
    canvas.drawCircle(center, size.width * 0.25, paint);
    canvas.drawCircle(center, size.width * 0.35, paint);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    final distance = (p2 - p1).distance;
    final dx = (p2.dx - p1.dx) / distance;
    final dy = (p2.dy - p1.dy) / distance;
    var currentDist = 0.0;
    while (currentDist < distance) {
      canvas.drawLine(
        Offset(p1.dx + dx * currentDist, p1.dy + dy * currentDist),
        Offset(p1.dx + dx * math.min(currentDist + dashWidth, distance), p1.dy + dy * math.min(currentDist + dashWidth, distance)),
        paint,
      );
      currentDist += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectionLinePainter oldDelegate) => 
      oldDelegate.sourceCount != sourceCount || oldDelegate.rotation != rotation;
}
