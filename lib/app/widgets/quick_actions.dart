import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = <_QuickActionData>[
      const _QuickActionData(
        label: 'Sleep',
        icon: Icons.bed_outlined,
        route: AppRoutes.sleep,
      ),
      const _QuickActionData(
        label: 'Work',
        icon: Icons.work_outline_rounded,
        route: AppRoutes.work,
      ),
      const _QuickActionData(
        label: 'Finance',
        icon: Icons.account_balance_wallet_outlined,
        route: AppRoutes.finance,
      ),
      const _QuickActionData(
        label: 'Fitness',
        icon: Icons.fitness_center_outlined,
        route: AppRoutes.fitness,
      ),
      const _QuickActionData(
        label: 'Timeline',
        icon: Icons.timeline_rounded,
        route: AppRoutes.timeline,
      ),
      const _QuickActionData(
        label: 'Search',
        icon: Icons.search_rounded,
        route: AppRoutes.search,
      ),
      const _QuickActionData(
        label: 'Planner',
        icon: Icons.event_note_outlined,
        route: AppRoutes.planner,
      ),
      const _QuickActionData(
        label: 'Settings',
        icon: Icons.settings_outlined,
        route: AppRoutes.settings,
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions.map((action) {
        return SizedBox(
          width: 110,
          child: FilledButton.tonal(
            onPressed: () => context.go(action.route),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Column(
              children: [
                Icon(action.icon),
                const SizedBox(height: 8),
                Text(action.label),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
