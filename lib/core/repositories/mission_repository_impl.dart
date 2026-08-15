import 'dart:convert';
import 'package:drift/drift.dart';
import '../domain/entities/mission.dart';
import '../domain/repositories/i_mission_repository.dart';
import '../internal/storage/drift/knight_database.dart';

class MissionRepositoryImpl implements IMissionRepository {
  MissionRepositoryImpl(this._dao);

  final MissionDao _dao;

  @override
  Future<void> storeMission(Mission mission) async {
    await _dao.upsertMission(
      MissionTableCompanion.insert(
        id: mission.id,
        title: mission.title,
        description: Value(mission.description),
        type: mission.type.name,
        owningDomain: mission.owningDomain,
        status: Value(mission.status.name),
        priority: Value(mission.priority.name),
        importance: Value(mission.importance),
        urgency: Value(mission.urgency),
        dueDate: Value(mission.dueDate),
        progress: Value(mission.progress),
        alignmentScore: Value(mission.alignmentScore),
        completedAt: Value(mission.completedAt),
        metadata: Value(json.encode(mission.metadata)),
      ),
    );

    // Sprint V5.2: Mirror basic tasks to TaskTable for Planner UI compatibility
    if (mission.type == MissionType.task) {
      await _dao.upsertMission(const MissionTableCompanion(
        id: Value('system'),
        title: Value('System Mission'),
        type: Value('system'),
        owningDomain: Value('system'),
      ));

      await _dao.upsertGoal(const GoalTableCompanion(
        id: Value('legacy-uncategorized'),
        missionId: Value('system'),
        title: Value('System Tasks'),
      ));
      
      await _dao.upsertTask(TaskTableCompanion.insert(
        id: mission.id,
        goalId: 'legacy-uncategorized', // Default goal anchor
        title: mission.title,
        isCompleted: Value(mission.status == MissionStatus.completed),
        priority: Value(mission.priority.name),
      ));
    }
  }

  @override
  Future<Mission?> getById(String id) async {
    // Basic implementation: needs a getById in the DAO
    final all = await _dao.getAllMissions();
    try {
      final data = all.firstWhere((m) => m.id == id);
      return _mapToEntity(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Mission>> getActiveMissions() async {
    final all = await _dao.getAllMissions();
    return all
        .where((m) => m.status == MissionStatus.active.name)
        .map(_mapToEntity)
        .toList();
  }

  @override
  Future<List<Mission>> getAll() async {
    final all = await _dao.getAllMissions();
    return all.map(_mapToEntity).toList();
  }

  @override
  Future<void> deleteMission(String id) async {
    // Needs deleteById in DAO
  }

  Mission _mapToEntity(MissionData data) {
    Map<String, dynamic> decodedMetadata = {};
    try {
      final meta = data.metadata;
      if (meta != null && meta.trim().isNotEmpty) {
        final decoded = json.decode(meta);
        if (decoded is Map<String, dynamic>) {
          decodedMetadata = decoded;
        }
      }
    } catch (e) {
      // P1: Fail-safe for corrupted JSON in metadata
      print('[MISSION REPO] Metadata decode failed for ${data.id}');
    }

    return Mission(
      id: data.id,
      title: data.title,
      description: data.description,
      type: MissionType.values.firstWhere(
        (t) => t.name == data.type,
        orElse: () => MissionType.task,
      ),
      owningDomain: data.owningDomain,
      status: MissionStatus.values.firstWhere(
        (s) => s.name == data.status,
        orElse: () => MissionStatus.draft,
      ),
      priority: MissionPriority.values.firstWhere(
        (p) => p.name == data.priority,
        orElse: () => MissionPriority.medium,
      ),
      importance: data.importance,
      urgency: data.urgency,
      dueDate: data.dueDate,
      progress: data.progress,
      alignmentScore: data.alignmentScore,
      createdAt: data.createdAt,
      completedAt: data.completedAt,
      metadata: decodedMetadata,
    );
  }
}
