import 'dart:async';
import '../domain/entities/mission.dart';
import '../domain/repositories/i_mission_repository.dart';
import '../domain/providers/i_mission_provider.dart';
import '../domain/events/integration_events.dart';
import '../intelligence/i_mission_prioritizer.dart';
import '../internal/utils/knight_logger.dart';
import 'event_bus.dart';
import 'package:uuid/uuid.dart';

/// Domain-agnostic central service for managing life missions.
class MissionService {
  MissionService(
    this._repository, {
    IMissionPrioritizer? prioritizer,
    EventBus? eventBus,
  })  : _prioritizer = prioritizer ?? _DefaultPrioritizer(),
        _eventBus = eventBus ?? EventBus.instance {
    _initListeners();
  }

  final IMissionRepository _repository;
  final IMissionPrioritizer _prioritizer;
  final EventBus _eventBus;
  final List<IMissionProvider> _domainProviders = [];
  final _uuid = const Uuid();

  void _initListeners() {
    _eventBus.on<EvidenceImported>().listen((event) {
      _handleEvidenceImported(event);
    });
  }

  Future<void> _handleEvidenceImported(EvidenceImported event) async {
    KnightLogger.info('[MISSION] Evidence received from Hub: ${event.evidenceId}. Evaluating missions...');
    
    // Propose a mission based on the imported type
    if (event.type == 'resume') {
      await createMission(
        title: 'Review and update Career DNA',
        description: 'New resume imported. Ensure your skill DNA reflects your latest achievements.',
        type: MissionType.learning,
        owningDomain: 'career',
        priority: MissionPriority.medium,
        alignmentScore: 0.8,
        metadata: {'source_evidence_id': event.evidenceId},
      );
    } else if (event.type == 'certificate') {
      await createMission(
        title: 'Verify new certification',
        description: 'A new certificate was detected. Add it to your professional legacy.',
        type: MissionType.milestone,
        owningDomain: 'career',
        priority: MissionPriority.high,
        alignmentScore: 0.9,
        metadata: {'source_evidence_id': event.evidenceId},
      );
    }
  }

  /// Registers a domain-specific mission provider.
  void registerProvider(IMissionProvider provider) {
    _domainProviders.add(provider);
    KnightLogger.info('[MISSION] Provider registered for domain: ${provider.domain}');
  }

  /// Creates a new mission, ensuring it follows core standards.
  Future<Mission> createMission({
    required String title,
    String? description,
    required MissionType type,
    required String owningDomain,
    required MissionPriority priority,
    int importance = 5,
    int urgency = 5,
    DateTime? dueDate,
    double alignmentScore = 0.5,
    Map<String, dynamic> metadata = const {},
  }) async {
    final mission = Mission(
      id: _uuid.v4(),
      title: title,
      description: description,
      type: type,
      owningDomain: owningDomain,
      status: MissionStatus.active,
      priority: priority,
      importance: importance,
      urgency: urgency,
      dueDate: dueDate,
      alignmentScore: alignmentScore,
      createdAt: DateTime.now(),
      metadata: metadata,
    );

    await _repository.storeMission(mission);
    KnightLogger.info('[MISSION] Created: ${mission.title} in domain: ${mission.owningDomain}');
    return mission;
  }

  /// Returns the "Daily Focus" - a ranked list of active missions.
  Future<List<Mission>> getDailyFocus() async {
    // 1. Collect missions from repository
    var missions = await _repository.getActiveMissions();

    // 2. Collect transient missions from domain providers
    for (final provider in _domainProviders) {
      final domainMissions = await provider.getMissions();
      missions.addAll(domainMissions);
    }

    // 3. Rank using the pluggable prioritizer
    return await _prioritizer.rank(missions);
  }

  /// Updates a mission's status and notifies providers.
  Future<void> updateStatus(String id, MissionStatus status) async {
    final mission = await _repository.getById(id);
    if (mission == null) return;

    final updated = mission.copyWith(
      status: status,
      completedAt: status == MissionStatus.completed ? DateTime.now() : null,
    );

    await _repository.storeMission(updated);
    
    // Notify domain provider if registered
    for (final provider in _domainProviders) {
      if (provider.domain == updated.owningDomain) {
        await provider.onMissionUpdated(updated);
      }
    }

    KnightLogger.info('[MISSION] Status updated: ${updated.title} -> ${updated.status}');
  }
}

/// A basic prioritization engine that uses importance and urgency.
class _DefaultPrioritizer implements IMissionPrioritizer {
  @override
  Future<List<Mission>> rank(List<Mission> missions) async {
    // Simple logic: sort by (Importance + Urgency) * Alignment
    final sorted = List<Mission>.from(missions);
    sorted.sort((a, b) {
      final scoreA = (a.importance + a.urgency) * (1 + a.alignmentScore);
      final scoreB = (b.importance + b.urgency) * (1 + b.alignmentScore);
      return scoreB.compareTo(scoreA);
    });
    return sorted;
  }
}
