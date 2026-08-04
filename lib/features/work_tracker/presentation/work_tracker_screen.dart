import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/knight_context_provider.dart';

class WorkTrackerScreen extends ConsumerWidget {
  const WorkTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return KnightPageScaffold(
      title: 'Career',
      showBackButton: true,
      body: contextAsync.when(
        data: (knightContext) => _buildContent(context, knightContext),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic knightContext) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCareerScore(),
          const SizedBox(height: 32),
          const Text('RECENT SESSIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
          const SizedBox(height: 16),
          _buildEmptyState(),
          const SizedBox(height: 140),
        ],
      ),
    );
  }

  Widget _buildCareerScore() {
    return Card(
      color: DesignColors.surfaceHigh,
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PROFESSIONAL MOMENTUM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
                Icon(Icons.trending_up_rounded, color: DesignColors.success, size: 16),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniStat(label: 'Focus', value: '8.2'),
                _MiniStat(label: 'Output', value: 'High'),
                _MiniStat(label: 'Skills', value: '12'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.work_history_outlined, size: 48, color: Colors.white10),
          const SizedBox(height: 16),
          const Text('No work sessions logged.', style: TextStyle(color: Colors.white24)),
          TextButton(onPressed: () {}, child: const Text('Initialize Work Tracker')),
        ],
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
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white24)),
      ],
    );
  }
}
