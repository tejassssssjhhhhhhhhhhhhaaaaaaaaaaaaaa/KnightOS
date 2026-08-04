import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/knight_theme_provider.dart';

class FloatingNavBar extends ConsumerWidget {
  const FloatingNavBar({required this.currentLocation, super.key});

  final String currentLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accentColor = ref.watch(adaptiveAccentProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavIcon(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: currentLocation == AppRoutes.home || currentLocation == AppRoutes.dashboard,
                  onTap: () => context.go(AppRoutes.home),
                  accentColor: accentColor,
                ),
                _NavIcon(
                  icon: Icons.grid_view_rounded,
                  label: 'My Hub',
                  isActive: currentLocation.startsWith(AppRoutes.myPlace),
                  onTap: () => context.go(AppRoutes.myPlace),
                  accentColor: accentColor,
                ),
                _NavIcon(
                  icon: Icons.task_alt_rounded,
                  label: 'Planner',
                  isActive: currentLocation.startsWith(AppRoutes.planner),
                  onTap: () => context.go(AppRoutes.planner),
                  accentColor: accentColor,
                ),
                _NavIcon(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isActive: currentLocation.startsWith(AppRoutes.settings),
                  onTap: () => context.go(AppRoutes.settings),
                  accentColor: accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: DesignAnimations.fast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? Colors.white : Colors.white24,
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: accentColor, blurRadius: 4),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
