import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/domain/models/models.dart';

class AtlasFilters extends StatelessWidget {
  const AtlasFilters({
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  final TimelineCategory? selectedCategory;
  final ValueChanged<TimelineCategory?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
      child: Row(
        children: [
          _buildChip(
            context,
            null,
            'All',
            Icons.all_inclusive_rounded,
            DesignColors.primary,
          ),
          ...TimelineCategory.values.map((category) {
            return _buildChip(
              context,
              category,
              category.label,
              category.icon,
              category.color,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    TimelineCategory? category,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onCategorySelected(category),
        selectedColor: color.withValues(alpha: 0.2),
        checkmarkColor: color,
        labelStyle: TextStyle(
          color: isSelected ? color : Colors.white60,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          fontSize: 12,
        ),
        backgroundColor: DesignColors.surface,
        side: BorderSide(
          color: isSelected
              ? color.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.05),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignRadius.m),
        ),
      ),
    );
  }
}
