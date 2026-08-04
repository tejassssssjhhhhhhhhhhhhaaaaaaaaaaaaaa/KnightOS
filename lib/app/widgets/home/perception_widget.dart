import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';

class PerceptionWidget extends ConsumerWidget {
  const PerceptionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perception = ref.watch(perceptionEngineProvider);
    
    if (perception == 'stationary') return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.sensors_rounded, color: Colors.blueAccent, size: 16),
          const SizedBox(width: 12),
          Text(
            'ACTIVE PERCEPTION: ${perception.toUpperCase()}',
            style: KnightTokens.label.copyWith(fontSize: 10, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}
