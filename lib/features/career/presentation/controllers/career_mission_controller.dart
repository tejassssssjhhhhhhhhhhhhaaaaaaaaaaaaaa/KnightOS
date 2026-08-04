import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/entities/mission.dart';
import '../../../../core/providers/mission_providers.dart';

class CareerMissionState {
  const CareerMissionState({
    this.activeMissions = const [],
    this.completedMissionsCount = 0,
    this.totalEnergyRequirement = 0,
    this.totalEstimatedMinutes = 0,
  });

  final List<Mission> activeMissions;
  final int completedMissionsCount;
  final int totalEnergyRequirement;
  final int totalEstimatedMinutes;

  CareerMissionState copyWith({
    List<Mission>? activeMissions,
    int? completedMissionsCount,
    int? totalEnergyRequirement,
    int? totalEstimatedMinutes,
  }) {
    return CareerMissionState(
      activeMissions: activeMissions ?? this.activeMissions,
      completedMissionsCount: completedMissionsCount ?? this.completedMissionsCount,
      totalEnergyRequirement: totalEnergyRequirement ?? this.totalEnergyRequirement,
      totalEstimatedMinutes: totalEstimatedMinutes ?? this.totalEstimatedMinutes,
    );
  }
}

class CareerMissionNotifier extends AsyncNotifier<CareerMissionState> {
  @override
  Future<CareerMissionState> build() async {
    final missionService = ref.watch(missionServiceProvider);
    
    final missions = await missionService.getDailyFocus();
    final careerMissions = missions.where((m) => m.owningDomain == 'career').toList();
    
    final totalEnergy = careerMissions.fold<int>(0, (sum, m) => sum + (m.estimatedEnergyRequirement ?? 0));
    final totalMinutes = careerMissions.fold<int>(0, (sum, m) => sum + (m.estimatedDurationMinutes ?? 0));

    return CareerMissionState(
      activeMissions: careerMissions,
      totalEnergyRequirement: totalEnergy,
      totalEstimatedMinutes: totalMinutes,
    );
  }

  Future<void> completeMission(String id) async {
    final missionService = ref.read(missionServiceProvider);
    await missionService.updateStatus(id, MissionStatus.completed);
    ref.invalidateSelf();
  }
}

final careerMissionControllerProvider = AsyncNotifierProvider<CareerMissionNotifier, CareerMissionState>(
  CareerMissionNotifier.new,
);
