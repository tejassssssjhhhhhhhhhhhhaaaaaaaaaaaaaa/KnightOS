import 'package:flutter/material.dart';
import '../../../../core/design_system/widgets/knight_card.dart';
import '../../../../core/domain/models/models.dart';

class VaultCategoryCard extends StatelessWidget {
  const VaultCategoryCard({
    required this.category,
    required this.count,
    this.onTap,
    super.key,
  });

  final DocumentCategory category;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return KnightFeatureCard(
      title: category.label,
      subtitle: '$count items',
      icon: category.icon,
      accentColor: category.color,
      onTap: onTap,
    );
  }
}
