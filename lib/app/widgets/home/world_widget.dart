import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/intelligence/knight_context_provider.dart';
import '../../../core/design_system/design_constants.dart';

class WorldWidget extends ConsumerWidget {
  const WorldWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(currentContextNotifierProvider);

    return contextAsync.when(
      data: (knightContext) {
        final world = knightContext.worldState;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _WorldItem(
                icon: _getWeatherIcon(world.weather),
                label: world.weather.toUpperCase(),
              ),
              const SizedBox(width: 16),
              Container(width: 1, height: 16, color: Colors.white10),
              const SizedBox(width: 16),
              _WorldItem(
                icon: Icons.account_balance_rounded,
                label: 'MARKET ${world.marketStatus.toUpperCase()}',
                color: world.marketStatus.toLowerCase() == 'open' ? DesignColors.success : Colors.white24,
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  IconData _getWeatherIcon(String weather) {
    final w = weather.toLowerCase();
    if (w.contains('sun') || w.contains('clear')) return Icons.wb_sunny_rounded;
    if (w.contains('cloud')) return Icons.cloud_rounded;
    if (w.contains('rain')) return Icons.umbrella_rounded;
    return Icons.wb_cloudy_rounded;
  }
}

class _WorldItem extends StatelessWidget {
  const _WorldItem({required this.icon, required this.label, this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? Colors.white38;
    return Row(
      children: [
        Icon(icon, size: 14, color: activeColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 9, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1.2, 
            color: activeColor
          ),
        ),
      ],
    );
  }
}
