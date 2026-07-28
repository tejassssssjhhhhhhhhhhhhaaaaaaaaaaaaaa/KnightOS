import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/upcoming/presentation/upcoming_controller.dart';
import '../../../features/upcoming/presentation/widgets/upcoming_card.dart';
import 'home_section_base.dart';

class HomeUpcomingSection extends ConsumerWidget {
  const HomeUpcomingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(upcomingProvider);

    return HomeSectionBase(
      title: 'Upcoming',
      subtitle: 'Events and reminders',
      child: stateAsync.when(
        data: (state) {
          final items = state.items;
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              if (width > 720) {
                // Tablet: Grid or Two columns
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 110,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return UpcomingCard(
                      item: items[index],
                      onToggleComplete: (val) {
                        ref
                            .read(upcomingProvider.notifier)
                            .completeItem(items[index].id, val ?? false);
                      },
                    );
                  },
                );
              } else {
                // Phone: Single column list
                return Column(
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      UpcomingCard(
                        item: items[i],
                        onToggleComplete: (val) {
                          ref
                              .read(upcomingProvider.notifier)
                              .completeItem(items[i].id, val ?? false);
                        },
                      ),
                      if (i < items.length - 1) const SizedBox(height: 12),
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
              'Failed to load upcoming items',
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
