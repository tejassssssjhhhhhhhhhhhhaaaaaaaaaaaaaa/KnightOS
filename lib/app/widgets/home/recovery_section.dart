import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/recovery/presentation/recovery_controller.dart';
import '../../../features/recovery/presentation/widgets/recovery_card.dart';
import 'home_section_base.dart';

class HomeRecoverySection extends ConsumerWidget {
  const HomeRecoverySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(recoveryStateProvider);

    return HomeSectionBase(
      title: 'Recovery',
      subtitle: 'Sleep, energy, and stress',
      child: stateAsync.when(
        data: (state) {
          final metrics = state.metrics;
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              if (width > 720) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < metrics.length; i++) ...[
                        Expanded(child: RecoveryCard(metric: metrics[i])),
                        if (i < metrics.length - 1) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                );
              } else if (width > 480) {
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: RecoveryCard(metric: metrics[0])),
                          const SizedBox(width: 12),
                          Expanded(child: RecoveryCard(metric: metrics[1])),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    RecoveryCard(metric: metrics[2]),
                  ],
                );
              } else {
                return Column(
                  children: [
                    for (var i = 0; i < metrics.length; i++) ...[
                      RecoveryCard(metric: metrics[i]),
                      if (i < metrics.length - 1) const SizedBox(height: 12),
                    ],
                  ],
                );
              }
            },
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Failed to load recovery metrics',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
