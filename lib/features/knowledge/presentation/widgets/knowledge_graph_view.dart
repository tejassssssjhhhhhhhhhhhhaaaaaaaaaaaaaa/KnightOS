import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/intelligence/domain/knight_memory.dart';
import '../../../../core/intelligence/domain/memory_relation.dart';

class KnowledgeGraphView extends StatefulWidget {
  const KnowledgeGraphView({
    required this.memories,
    required this.relations,
    super.key,
  });

  final List<KnightMemory> memories;
  final List<MemoryRelation> relations;

  @override
  State<KnowledgeGraphView> createState() => _KnowledgeGraphViewState();
}

class _KnowledgeGraphViewState extends State<KnowledgeGraphView> with SingleTickerProviderStateMixin {
  late Map<String, Offset> _nodePositions;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializePositions();
  }

  void _initializePositions() {
    _nodePositions = {};
    for (var memory in widget.memories) {
      _nodePositions[memory.memoryId] = Offset(
        _random.nextDouble() * 300 + 50,
        _random.nextDouble() * 500 + 50,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Simple global drag (Future: Drag individual nodes)
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: _KnowledgeGraphPainter(
          memories: widget.memories,
          relations: widget.relations,
          positions: _nodePositions,
        ),
      ),
    );
  }
}

class _KnowledgeGraphPainter extends CustomPainter {
  _KnowledgeGraphPainter({
    required this.memories,
    required this.relations,
    required this.positions,
  });

  final List<KnightMemory> memories;
  final List<MemoryRelation> relations;
  final Map<String, Offset> positions;

  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()..style = PaintingStyle.fill;

    // 1. Draw Edges
    for (var rel in relations) {
      final start = positions[rel.sourceId];
      final end = positions[rel.targetId];
      if (start != null && end != null) {
        canvas.drawLine(start, end, edgePaint);
      }
    }

    // 2. Draw Nodes
    for (var memory in memories) {
      final pos = positions[memory.memoryId];
      if (pos != null) {
        nodePaint.color = memory.category.color.withValues(alpha: 0.8);
        canvas.drawCircle(pos, 8, nodePaint);
        
        // Label
        final textPainter = TextPainter(
          text: TextSpan(
            text: memory.summary ?? 'Unit',
            style: const TextStyle(color: Colors.white38, fontSize: 8),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, pos + const Offset(12, -4));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension on dynamic {
  Color get color => Colors.blue; // Fallback for BookCategory mapping
}
