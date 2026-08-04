import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/router/app_routes.dart';

class CareerQuickActions extends StatelessWidget {
  const CareerQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK ACTIONS',
          style: TextStyle(
            color: DesignColors.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _ActionTile(
              label: 'North Star',
              icon: Icons.star_rounded,
              onTap: () => context.push(AppRoutes.northStar),
            ),
            _ActionTile(
              label: 'Mission Center',
              icon: Icons.flag_rounded,
              onTap: () => context.push(AppRoutes.missionCenter),
            ),
            _ActionTile(
              label: 'Career DNA',
              icon: Icons.psychology_rounded,
              onTap: () => context.push(AppRoutes.careerDna),
            ),
            _ActionTile(
              label: 'Achievement Vault',
              icon: Icons.account_balance_wallet_rounded,
              onTap: () => context.push(AppRoutes.careerVault),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: DesignRadius.card,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: DesignColors.surfaceHigh.withValues(alpha: 0.8),
          borderRadius: DesignRadius.card,
          border: Border.all(color: DesignColors.white05),
        ),
        child: Row(
          children: [
            Icon(icon, color: DesignColors.accentBlue, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: DesignColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
