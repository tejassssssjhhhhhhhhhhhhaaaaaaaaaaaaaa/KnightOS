import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/intelligence/providers/intelligence_providers.dart';
import '../../core/intelligence/domain/workflow_models.dart';

class AutonomousMonitorOverlay extends ConsumerWidget {
  const AutonomousMonitorOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync = ref.watch(activeExecutionsProvider);

    return activeAsync.when(
      data: (states) {
        if (states.isEmpty) return const SizedBox.shrink();
        
        return Positioned(
          top: 60,
          right: 20,
          child: Column(
            children: states.map((s) => _ExecutionCard(state: s)).toList(),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _ExecutionCard extends StatelessWidget {
  const _ExecutionCard({required this.state});
  final WorkflowState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignColors.accentBlue.withValues(alpha: 0.3)),
        boxShadow: DesignShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: DesignColors.accentBlue,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'KNIGHT EXECUTING',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: DesignColors.accentBlue),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Step: ${state.currentTaskId ?? "Initializing"}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: state.progress,
              minHeight: 4,
              backgroundColor: DesignColors.white05,
              color: DesignColors.accentBlue,
            ),
          ),
        ],
      ),
    );
  }
}
