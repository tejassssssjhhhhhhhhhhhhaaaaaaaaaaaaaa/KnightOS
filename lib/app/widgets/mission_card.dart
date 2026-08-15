import 'package:flutter/material.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/design_system/knight_tokens.dart';
import '../../core/design_system/widgets/knight_card.dart';

/// A card displaying the user's primary objective and progress metrics.
class MissionCard extends StatelessWidget {
  const MissionCard({
    required this.mission,
    required this.streak,
    required this.message,
    super.key,
  });

  final String mission;
  final String streak;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignSpacing.xl),
      decoration: BoxDecoration(
        color: DesignColors.surface.withValues(alpha: 0.4),
        borderRadius: DesignRadius.card,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: DesignColors.accentBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'TODAY\'S MISSION',
                style: KnightTokens.label.copyWith(color: DesignColors.accentBlue),
              ),
            ],
          ),
          const SizedBox(height: DesignSpacing.l),
          Text(
            mission,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: DesignSpacing.xl),
          Row(
            children: [
              Expanded(
                child: KnightStatCard(
                  label: 'STREAK',
                  value: streak,
                  color: DesignColors.accentPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: KnightStatCard(
                  label: 'MOMENTUM',
                  value: message,
                  color: DesignColors.accentCyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
