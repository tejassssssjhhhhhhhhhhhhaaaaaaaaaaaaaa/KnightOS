import 'package:flutter/material.dart';

/// A sophisticated pulsing skeleton for content loading states.
class KnightSkeleton extends StatefulWidget {
  const KnightSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<KnightSkeleton> createState() => _KnightSkeletonState();
}

class _KnightSkeletonState extends State<KnightSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulse = Tween<double>(begin: 0.02, end: 0.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _pulse.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.02)),
          ),
        );
      },
    );
  }
}

/// Pre-configured skeleton for a standard Knight dashboard card.
class KnightCardSkeleton extends StatelessWidget {
  const KnightCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KnightSkeleton(width: 80, height: 10, borderRadius: 4),
        const SizedBox(height: 16),
        const KnightSkeleton(width: double.infinity, height: 100, borderRadius: 24),
      ],
    );
  }
}
