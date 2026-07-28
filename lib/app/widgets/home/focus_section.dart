import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/focus/presentation/focus_controller.dart';
import '../../../features/focus/presentation/widgets/focus_card.dart';
import 'home_section_base.dart';

class HomeFocusSection extends ConsumerWidget {
  const HomeFocusSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusAreasAsync = ref.watch(focusAreasProvider);

    return HomeSectionBase(
      title: 'Today\'s Focus',
      subtitle: 'Current priorities and missions',
      child: focusAreasAsync.when(
        data: (focusAreas) => LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            if (width > 720) {
              // Tablet/Wide: 3 columns with consistent height
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < focusAreas.length; i++) ...[
                      Expanded(child: FocusCard(focusArea: focusAreas[i])),
                      if (i < focusAreas.length - 1) const SizedBox(width: 12),
                    ],
                  ],
                ),
              );
            } else if (width > 480) {
              // Medium Phone/Small Tablet: 2 columns + 1 bottom
              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: FocusCard(focusArea: focusAreas[0])),
                        const SizedBox(width: 12),
                        Expanded(child: FocusCard(focusArea: focusAreas[1])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FocusCard(focusArea: focusAreas[2]),
                ],
              );
            } else {
              // Small Phone: Single column
              return Column(
                children: [
                  for (var i = 0; i < focusAreas.length; i++) ...[
                    FocusCard(focusArea: focusAreas[i]),
                    if (i < focusAreas.length - 1) const SizedBox(height: 12),
                  ],
                ],
              );
            }
          },
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Failed to load focus areas',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
