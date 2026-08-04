import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/knight_context_provider.dart';

class IntelligenceDashboardScreen extends ConsumerWidget {
  const IntelligenceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return KnightPageScaffold(
      title: 'Intelligence',
      showBackButton: true,
      body: contextAsync.when(
        data: (knightContext) => SingleChildScrollView(
          padding: const EdgeInsets.all(DesignSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(knightContext),
              const SizedBox(height: 32),
              const Text('ACTIVE REASONING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
              const SizedBox(height: 16),
              if (knightContext.reasoning != null && knightContext.reasoning!.insights.isNotEmpty)
                ...knightContext.reasoning!.insights.map((insight) => Card(
                  color: DesignColors.surface.withValues(alpha: 0.4),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.auto_awesome_rounded, color: DesignColors.accentBlue, size: 18),
                    title: Text(insight.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: Text(insight.description, style: const TextStyle(fontSize: 11, color: Colors.white24)),
                  ),
                ))
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text('Autonomous logic nominal.', style: TextStyle(color: Colors.white10)),
                  ),
                ),
              const SizedBox(height: 140),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildStatusCard(dynamic knightContext) {
    return Card(
      color: DesignColors.surfaceHigh,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('COGNITIVE STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
                Icon(Icons.check_circle_outline_rounded, color: DesignColors.success, size: 16),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniStat(label: 'Knowledge', value: '${knightContext.recentMemoriesCount}'),
                _MiniStat(label: 'Identity', value: 'STABLE'),
                _MiniStat(label: 'Confidence', value: '92%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: DesignColors.accentBlue)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white24)),
      ],
    );
  }
}
