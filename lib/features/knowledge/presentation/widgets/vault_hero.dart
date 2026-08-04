import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_constants.dart';

class VaultHero extends ConsumerWidget {
  const VaultHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(DesignSpacing.m, 40, DesignSpacing.m, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SEMANTIC VAULT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: DesignColors.accentBlue, letterSpacing: 2.0)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), shape: BoxShape.circle),
                child: const Icon(Icons.inventory_2_rounded, size: 14, color: Colors.white38),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Personal Intelligence', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 8),
          const Text('A unified semantic repository of your life events, documents, and expert knowledge.', style: TextStyle(fontSize: 14, color: Colors.white38, height: 1.5)),
          const SizedBox(height: 32),
          _buildQuickStats(ref),
        ],
      ),
    );
  }

  Widget _buildQuickStats(WidgetRef ref) {
    return Row(
      children: [
        _buildStatItem('45', 'AI Memories'),
        const SizedBox(width: 40),
        _buildStatItem('147', 'Graph Nodes'),
        const SizedBox(width: 40),
        _buildStatItem('AES-256', 'Security'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ],
    );
  }
}
