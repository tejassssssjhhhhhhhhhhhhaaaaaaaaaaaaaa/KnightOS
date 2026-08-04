import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/widgets/knight_page_scaffold.dart';
import '../../../../core/design_system/design_constants.dart';
import '../controllers/career_mission_controller.dart';
import '../widgets/explainable_insight_card.dart';
import '../../../../core/domain/entities/mission.dart';

class MissionCenterScreen extends ConsumerWidget {
  const MissionCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(careerMissionControllerProvider);

    return KnightPageScaffold(
      title: 'Mission Center',
      showBackButton: true,
      body: stateAsync.when(
        data: (state) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMissionStats(state),
              const SizedBox(height: 40),
              
              const ExplainableInsightCard(
                title: 'Tactical Optimization',
                recommendation: 'Complete "System Design Review" first.',
                evidenceSummary: 'High energy requirements (8/10) and upcoming deadline.',
                reasoning: 'Your current focus peak is morning hours; finishing this high-impact task now yields the best result.',
                confidence: 0.96,
                suggestedAction: 'Activate Priority Mission.',
              ),
              const SizedBox(height: 40),

              _buildActiveMissionsSection(context, ref, state.activeMissions),
              const SizedBox(height: 100),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildMissionStats(CareerMissionState state) {
    return Row(
      children: [
        _MetricSquare(label: 'TOTAL ENERGY', value: '${state.totalEnergyRequirement}', icon: Icons.bolt_rounded, color: DesignColors.warning),
        const SizedBox(width: 12),
        _MetricSquare(label: 'EST. TIME', value: '${state.totalEstimatedMinutes}m', icon: Icons.access_time_rounded, color: DesignColors.accentBlue),
        const SizedBox(width: 12),
        _MetricSquare(label: 'ACTIVE', value: '${state.activeMissions.length}', icon: Icons.flag_rounded, color: DesignColors.career),
      ],
    );
  }

  Widget _buildActiveMissionsSection(BuildContext context, WidgetRef ref, List<Mission> missions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MISSION PIPELINE',
          style: TextStyle(color: DesignColors.secondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        const SizedBox(height: 16),
        if (missions.isEmpty)
          const Text('No active missions in the pipeline.', 
            style: TextStyle(color: DesignColors.secondary, fontSize: 12, fontStyle: FontStyle.italic))
        else
          ...missions.map((m) => _MissionControlTile(mission: m)),
      ],
    );
  }
}

class _MetricSquare extends StatelessWidget {
  const _MetricSquare({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DesignColors.white05,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DesignColors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: DesignColors.secondary, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}

class _MissionControlTile extends StatelessWidget {
  const _MissionControlTile({required this.mission});
  final Mission mission;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DesignColors.white05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TypeIcon(type: mission.type),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mission.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'Impact: ${mission.alignmentScore > 0.8 ? "STRATEGIC" : "MODERATE"}',
                      style: TextStyle(color: DesignColors.accentCyan, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              _AlignmentBadge(score: mission.alignmentScore),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _DetailChip(label: '${mission.estimatedDurationMinutes ?? 0}m', icon: Icons.access_time),
              const SizedBox(width: 12),
              _DetailChip(label: 'Energy: ${mission.estimatedEnergyRequirement ?? 5}/10', icon: Icons.bolt),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline_rounded, color: DesignColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});
  final MissionType type;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (type) {
      case MissionType.learning: icon = Icons.school_rounded; break;
      case MissionType.certification: icon = Icons.verified_user_rounded; break;
      case MissionType.project: icon = Icons.rocket_launch_rounded; break;
      case MissionType.networking: icon = Icons.people_rounded; break;
      default: icon = Icons.flag_rounded;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: DesignColors.white10, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}

class _AlignmentBadge extends StatelessWidget {
  const _AlignmentBadge({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: DesignColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: DesignColors.warning.withValues(alpha: 0.2)),
      ),
      child: Text(
        'ALIGNED ${(score * 100).toInt()}%',
        style: const TextStyle(color: DesignColors.warning, fontSize: 8, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: DesignColors.secondary),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: DesignColors.secondary, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
