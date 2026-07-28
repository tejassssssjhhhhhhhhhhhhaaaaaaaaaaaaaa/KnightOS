import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/finance/presentation/money_controller.dart';
import '../../../features/finance/presentation/widgets/money_card.dart';
import 'home_section_base.dart';

class HomeMoneySection extends ConsumerWidget {
  const HomeMoneySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(moneyStateProvider);

    return HomeSectionBase(
      title: 'Money',
      subtitle: 'Finances and expenses',
      child: stateAsync.when(
        data: (state) {
          final metrics = state.metrics;
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              if (width > 900) {
                // Large tablet / Desktop: 4 columns
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < metrics.length; i++) ...[
                        Expanded(child: MoneyCard(metric: metrics[i])),
                        if (i < metrics.length - 1) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                );
              } else if (width > 600) {
                // Small tablet: 2x2 grid
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: MoneyCard(metric: metrics[0])),
                          const SizedBox(width: 12),
                          Expanded(child: MoneyCard(metric: metrics[1])),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: MoneyCard(metric: metrics[2])),
                          const SizedBox(width: 12),
                          Expanded(child: MoneyCard(metric: metrics[3])),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Phone: 2x2 grid (compact) or List
                // Let's go with 2x2 grid for consistency with the "Dashboard" feel
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: MoneyCard(metric: metrics[0])),
                          const SizedBox(width: 12),
                          Expanded(child: MoneyCard(metric: metrics[1])),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: MoneyCard(metric: metrics[2])),
                          const SizedBox(width: 12),
                          Expanded(child: MoneyCard(metric: metrics[3])),
                        ],
                      ),
                    ),
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
              'Failed to load money metrics',
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
