import 'package:flutter/material.dart';

class OnboardingChoiceChips extends StatelessWidget {
  const OnboardingChoiceChips({
    required this.label,
    required this.options,
    required this.selection,
    required this.onSelected,
    super.key,
  });

  final String label;
  final List<String> options;
  final String selection;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selection;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
