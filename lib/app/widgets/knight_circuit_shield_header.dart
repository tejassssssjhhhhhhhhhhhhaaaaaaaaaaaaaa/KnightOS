import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/knight_theme_provider.dart';
import '../../core/design_system/widgets/knight_circuit_shield.dart';

class KnightCircuitShieldHeader extends ConsumerWidget {
  const KnightCircuitShieldHeader({this.size = 28, super.key});
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(currentPeriodProvider);
    return KnightCircuitShield(
      size: size,
      period: period,
    );
  }
}
