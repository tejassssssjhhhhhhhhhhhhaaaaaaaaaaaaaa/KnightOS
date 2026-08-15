import 'package:flutter/material.dart';
import '../../core/design_system/widgets/knight_card.dart';

/// Standardized wrapper for statistics displayed in dashboards.
class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    required this.label,
    required this.value,
    this.icon,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return KnightStatCard(
      label: label,
      value: value,
      icon: icon,
    );
  }
}
