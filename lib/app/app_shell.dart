import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/design_constants.dart';
import '../core/internal/utils/knight_logger.dart';
import '../core/router/app_routes.dart';
import 'widgets/knight_orb.dart';

class KnightShell extends StatelessWidget {
  const KnightShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    String location = '';
    try {
      location = GoRouterState.of(context).matchedLocation;
    } catch (_) {}

    return Scaffold(
      backgroundColor: DesignColors.background,
      body: child,
      floatingActionButton: const KnightOrb(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildNavigation(context, location),
    );
  }

  Widget _buildNavigation(BuildContext context, String location) {
    return Container(
      height: 100,
      padding: const EdgeInsets.fromLTRB(DesignSpacing.xl, 0, DesignSpacing.xl, DesignSpacing.l),
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: DesignColors.surface.withOpacity(0.9),
          borderRadius: DesignRadius.pill,
          border: Border.all(color: DesignColors.white05),
          boxShadow: DesignShadows.subtle,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: location == AppRoutes.home || location == AppRoutes.dashboard,
              onTap: () => context.go(AppRoutes.home),
            ),
            const SizedBox(width: 60), // Space for Central AI FAB
            _NavItem(
              icon: Icons.grid_view_rounded,
              label: 'My Place',
              isActive: location.startsWith(AppRoutes.myPlace),
              onTap: () => context.go(AppRoutes.myPlace),
            ),
            _NavItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              isActive: location.startsWith(AppRoutes.settings),
              onTap: () => context.go(AppRoutes.settings),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? DesignColors.accentBlue : Colors.white24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : Colors.white24,
            ),
          ),
        ],
      ),
    );
  }
}
