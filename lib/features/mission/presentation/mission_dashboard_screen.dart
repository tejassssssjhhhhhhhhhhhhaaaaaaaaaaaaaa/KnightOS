import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/repositories/mission_repository.dart';

class MissionDashboardScreen extends ConsumerWidget {
  const MissionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionsAsync = ref.watch(_missionsWithProgressProvider);

    return KnightPageScaffold(
      title: 'Missions',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            missionsAsync.when(
              data: (missions) {
                if (missions.isEmpty) {
                  return _buildEmptyState();
                }
                final top = missions.first; 
                return _buildActiveMission(top);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
            const SizedBox(height: 32),
            const Text('UPCOMING OBJECTIVES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38, letterSpacing: 1.0)),
            const SizedBox(height: 16),
            missionsAsync.when(
              data: (missions) => Column(
                children: missions.skip(1).map((m) => _buildMissionTile(m)).toList(),
              ),
              loading: () => const SizedBox.shrink(),
              error: (e, s) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      color: DesignColors.surfaceHigh.withValues(alpha: 0.3),
      child: const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.rocket_launch_rounded, size: 48, color: Colors.white10),
              SizedBox(height: 16),
              Text('No active missions.', style: TextStyle(color: Colors.white24)),
              Text('Initialize a new objective to begin.', style: TextStyle(fontSize: 12, color: Colors.white10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveMission(MissionWithProgress mwp) {
    return Card(
      color: DesignColors.surfaceHigh,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ACTIVE MISSION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white38)),
            const SizedBox(height: 16),
            Text(mwp.mission.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(mwp.mission.description ?? '', style: const TextStyle(fontSize: 13, color: Colors.white70)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: mwp.progress,
                    backgroundColor: Colors.white10,
                    color: DesignColors.accentBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Text('${(mwp.progress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 8),
            Text('${mwp.completedTasks}/${mwp.totalTasks} tasks completed', style: const TextStyle(fontSize: 10, color: Colors.white24)),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionTile(MissionWithProgress mwp) {
    return Card(
      color: DesignColors.surface.withValues(alpha: 0.4),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(mwp.mission.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(mwp.mission.status.toUpperCase(), style: const TextStyle(fontSize: 10, color: DesignColors.accentPurple, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        trailing: Text('${(mwp.progress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white24)),
      ),
    );
  }
}

final _missionsWithProgressProvider = FutureProvider<List<MissionWithProgress>>((ref) async {
  return ref.watch(missionRepositoryProvider).getMissionsWithProgress();
});
