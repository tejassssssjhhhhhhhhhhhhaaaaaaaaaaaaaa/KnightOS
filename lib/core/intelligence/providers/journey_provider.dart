import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/event_bus.dart';
import '../../domain/events/integration_events.dart';

enum JourneyStageStatus { waiting, active, completed, failed }

class JourneyStage {
  final String id;
  final String label;
  final String humanExplanation;
  final String technicalDetail;
  final JourneyStageStatus status;
  final String? error;

  JourneyStage({
    required this.id,
    required this.label,
    required this.humanExplanation,
    required this.technicalDetail,
    this.status = JourneyStageStatus.waiting,
    this.error,
  });

  JourneyStage copyWith({
    JourneyStageStatus? status,
    String? humanExplanation,
    String? technicalDetail,
    String? error,
  }) {
    return JourneyStage(
      id: id,
      label: label,
      humanExplanation: humanExplanation ?? this.humanExplanation,
      technicalDetail: technicalDetail ?? this.technicalDetail,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class PipelineJourney {
  final String connectorId;
  final String resourceId;
  final List<JourneyStage> stages;
  final DateTime startTime;

  PipelineJourney({
    required this.connectorId,
    required this.resourceId,
    required this.stages,
    required this.startTime,
  });

  bool get isFailed => stages.any((s) => s.status == JourneyStageStatus.failed);
  bool get isCompleted => stages.every((s) => s.status == JourneyStageStatus.completed);
}

class JourneyNotifier extends Notifier<PipelineJourney?> {
  StreamSubscription? _subscription;

  @override
  PipelineJourney? build() {
    _subscription?.cancel();
    _subscription = EventBus.instance.on<PipelineStageEvent>().listen((event) {
      if (event is PipelineStageStarted) {
        _handleStarted(event);
      } else if (event is PipelineStageCompleted) {
        _handleCompleted(event);
      } else if (event is PipelineStageFailed) {
        _handleFailed(event);
      }
    });

    ref.onDispose(() => _subscription?.cancel());
    return null;
  }

  void _handleStarted(PipelineStageStarted event) {
    if (state == null || state!.resourceId != event.resourceId) {
      state = PipelineJourney(
        connectorId: event.connectorId,
        resourceId: event.resourceId ?? 'unknown',
        startTime: event.timestamp,
        stages: _initialStages(),
      );
    }

    final index = state!.stages.indexWhere((s) => s.id == event.stage);
    if (index != -1) {
      final updatedStages = List<JourneyStage>.from(state!.stages);
      updatedStages[index] = updatedStages[index].copyWith(
        status: JourneyStageStatus.active,
        humanExplanation: event.humanExplanation,
        technicalDetail: event.technicalDetail,
      );
      state = PipelineJourney(
        connectorId: state!.connectorId,
        resourceId: state!.resourceId,
        startTime: state!.startTime,
        stages: updatedStages,
      );
    }
  }

  void _handleCompleted(PipelineStageCompleted event) {
    if (state == null || state!.resourceId != event.resourceId) return;

    final index = state!.stages.indexWhere((s) => s.id == event.stage);
    if (index != -1) {
      final updatedStages = List<JourneyStage>.from(state!.stages);
      updatedStages[index] = updatedStages[index].copyWith(
        status: JourneyStageStatus.completed,
        humanExplanation: event.humanExplanation,
        technicalDetail: event.technicalDetail,
      );
      state = PipelineJourney(
        connectorId: state!.connectorId,
        resourceId: state!.resourceId,
        startTime: state!.startTime,
        stages: updatedStages,
      );
    }
  }

  void _handleFailed(PipelineStageFailed event) {
    if (state == null || state!.resourceId != event.resourceId) return;

    final index = state!.stages.indexWhere((s) => s.id == event.stage);
    if (index != -1) {
      final updatedStages = List<JourneyStage>.from(state!.stages);
      updatedStages[index] = updatedStages[index].copyWith(
        status: JourneyStageStatus.failed,
        humanExplanation: event.humanExplanation,
        technicalDetail: event.technicalDetail,
        error: event.error,
      );
      state = PipelineJourney(
        connectorId: state!.connectorId,
        resourceId: state!.resourceId,
        startTime: state!.startTime,
        stages: updatedStages,
      );
    }
  }

  List<JourneyStage> _initialStages() {
    return [
      JourneyStage(id: 'received', label: 'Received', humanExplanation: 'Waiting...', technicalDetail: 'Idle'),
      JourneyStage(id: 'checked', label: 'Checked', humanExplanation: 'Waiting...', technicalDetail: 'Idle'),
      JourneyStage(id: 'understood', label: 'Understood', humanExplanation: 'Waiting...', technicalDetail: 'Idle'),
      JourneyStage(id: 'compared', label: 'Compared', humanExplanation: 'Waiting...', technicalDetail: 'Idle'),
      JourneyStage(id: 'categorized', label: 'Categorized', humanExplanation: 'Waiting...', technicalDetail: 'Idle'),
      JourneyStage(id: 'saved', label: 'Saved', humanExplanation: 'Waiting...', technicalDetail: 'Idle'),
      JourneyStage(id: 'available', label: 'Available', humanExplanation: 'Waiting...', technicalDetail: 'Idle'),
    ];
  }
}

final journeyProvider = NotifierProvider<JourneyNotifier, PipelineJourney?>(JourneyNotifier.new);
