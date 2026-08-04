import '../domain/entities/mission.dart';
import '../domain/entities/conflict.dart';
import 'package:uuid/uuid.dart';

/// Analyzes and proposes resolutions for multi-domain priority conflicts.
class ConflictResolver {
  final _uuid = const Uuid();

  /// Analyzes a list of active missions for potential collisions.
  List<Conflict> analyze(List<Mission> missions) {
    final conflicts = <Conflict>[];

    // 1. Energy Overload Check (Simulated for missions on the same day)
    final dailyEnergyMap = <String, int>{};
    for (final mission in missions) {
      if (mission.dueDate != null && mission.estimatedEnergyRequirement != null) {
        final dateKey = '${mission.dueDate!.year}-${mission.dueDate!.month}-${mission.dueDate!.day}';
        dailyEnergyMap[dateKey] = (dailyEnergyMap[dateKey] ?? 0) + mission.estimatedEnergyRequirement!;
        
        if (dailyEnergyMap[dateKey]! > 10) {
          conflicts.add(Conflict(
            id: _uuid.v4(),
            type: ConflictType.energyOverload,
            description: 'Daily energy requirement exceeds threshold (10) on $dateKey',
            involvedMissionIds: missions
                .where((m) => m.dueDate?.year == mission.dueDate!.year && 
                               m.dueDate?.month == mission.dueDate!.month && 
                               m.dueDate?.day == mission.dueDate!.day)
                .map((m) => m.id)
                .toList(),
            severity: 8,
          ));
          // Break to avoid duplicate energy conflicts for the same day
          break; 
        }
      }
    }

    // 2. High Urgency Overlap
    final highUrgencyMissions = missions.where((m) => m.urgency >= 9).toList();
    if (highUrgencyMissions.length > 2) {
      conflicts.add(Conflict(
        id: _uuid.v4(),
        type: ConflictType.priorityMismatch,
        description: 'Too many high-urgency missions active simultaneously.',
        involvedMissionIds: highUrgencyMissions.map((m) => m.id).toList(),
        severity: 7,
      ));
    }

    return conflicts;
  }

  /// Proposes a resolution for a given conflict.
  Resolution proposeResolution(Conflict conflict, List<Mission> allMissions) {
    final involved = allMissions.where((m) => conflict.involvedMissionIds.contains(m.id)).toList();
    
    if (involved.isEmpty) {
      return Resolution(
        id: _uuid.v4(),
        conflictId: conflict.id,
        description: 'No missions found to resolve.',
        actionPlan: [],
      );
    }

    // Basic heuristic: Defer the one with lowest alignment score
    involved.sort((a, b) => a.alignmentScore.compareTo(b.alignmentScore));
    final toDefer = involved.first;

    return Resolution(
      id: _uuid.v4(),
      conflictId: conflict.id,
      description: 'Heuristic resolution: Defer mission with lowest North Star alignment.',
      actionPlan: [
        'Reschedule mission: ${toDefer.title} to a future date.',
        'Prioritize mission: ${involved.last.title} based on higher alignment.',
      ],
    );
  }
}
