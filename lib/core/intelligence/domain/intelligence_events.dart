import 'package:flutter/foundation.dart';
import '../../platform/engine/engine_types.dart';
import 'knight_memory.dart';
import 'cognitive_models.dart';
import 'workflow_models.dart';

/// Base class for all events that trigger intelligence recomputation.
@immutable
abstract class IntelligenceEvent extends KnightEngineEvent {
  const IntelligenceEvent({required this.timestamp});
  final DateTime timestamp;
}

/// Emitted when new memories are added or existing ones are updated.
class DataChangedEvent extends IntelligenceEvent {
  const DataChangedEvent({
    required super.timestamp,
    required this.memories,
    this.isImport = false,
  });

  final List<KnightMemory> memories;
  final bool isImport;
}

/// Emitted when the user's physical or digital context changes.
class ContextChangedEvent extends IntelligenceEvent {
  const ContextChangedEvent({
    required super.timestamp,
    required this.contextLabel,
  });

  final String contextLabel;
}

/// Emitted when the user's physical environment characteristics change.
class EnvironmentChangedEvent extends IntelligenceEvent {
  const EnvironmentChangedEvent({
    required super.timestamp,
    required this.environmentId,
    this.metadata = const {},
  });

  final String environmentId;
  final Map<String, dynamic> metadata;
}

/// Emitted when a user interacts with the system or explicitly asks a question.
class UserInteractionEvent extends IntelligenceEvent {
  const UserInteractionEvent({
    required super.timestamp,
    required this.intent,
    required this.payload,
  });

  final KnightIntent intent;
  final Map<String, dynamic> payload;
}

/// Emitted when a mission progress is updated.
class MissionUpdatedEvent extends IntelligenceEvent {
  const MissionUpdatedEvent({
    required super.timestamp,
    required this.missionId,
    required this.progress,
  });

  final String missionId;
  final double progress;
}

/// Emitted when a user provides feedback on intelligence.
class FeedbackReceivedEvent extends IntelligenceEvent {
  const FeedbackReceivedEvent({
    required super.timestamp,
    required this.intelligenceId,
    required this.feedback,
  });

  final String intelligenceId;
  final dynamic feedback; // Usually IntelligenceFeedback
}

/// Emitted when an autonomous workflow state changes.
class WorkflowUpdatedEvent extends IntelligenceEvent {
  WorkflowUpdatedEvent({required this.state}) : super(timestamp: DateTime.now());
  final WorkflowState state;
}

/// Emitted when a sensitive action requires human approval.
class ApprovalRequestedEvent extends IntelligenceEvent {
  ApprovalRequestedEvent({required this.request}) : super(timestamp: DateTime.now());
  final dynamic request; // ApprovalRequest
}

/// Emitted when an approval request is resolved.
class ApprovalResolvedEvent extends IntelligenceEvent {
  ApprovalResolvedEvent({required this.requestId, required this.status}) : super(timestamp: DateTime.now());
  final String requestId;
  final dynamic status; // ApprovalStatus
}

/// Emitted when a remote device broadcasts its status.
class DeviceHeartbeatEvent extends IntelligenceEvent {
  DeviceHeartbeatEvent({required this.deviceId, required this.status}) : super(timestamp: DateTime.now());
  final String deviceId;
  final dynamic status; // DeviceStatus
}

/// Emitted when a task is delegated to a specific device.
class RemoteTaskExecutionEvent extends IntelligenceEvent {
  RemoteTaskExecutionEvent({
    required this.taskId, 
    required this.deviceId, 
    required this.planId,
  }) : super(timestamp: DateTime.now());

  final String taskId;
  final String deviceId;
  final String planId;
}

/// Emitted when a remote task completes.
class RemoteTaskCompletedEvent extends IntelligenceEvent {
  RemoteTaskCompletedEvent({
    required this.taskId, 
    required this.planId, 
    this.error,
  }) : super(timestamp: DateTime.now());

  final String taskId;
  final String planId;
  final String? error;
}

/// Emitted when a workflow attempts to heal itself from a failure.
class WorkflowHealingEvent extends IntelligenceEvent {
  WorkflowHealingEvent({
    required this.planId, 
    required this.failedTaskId, 
    this.fallbackTaskId,
  }) : super(timestamp: DateTime.now());

  final String planId;
  final String failedTaskId;
  final String? fallbackTaskId;
}

/// Base class for all intelligence requests sent via the bus.
abstract class IntelligenceRequest<T> {
  const IntelligenceRequest({required this.requestId, required this.timestamp});
  final String requestId;
  final DateTime timestamp;
}

/// Base class for all intelligence responses sent via the bus.
abstract class IntelligenceResponse<T> {
  const IntelligenceResponse({
    required this.requestId, 
    required this.data, 
    this.error,
    required this.timestamp,
  });
  final String requestId;
  final T? data;
  final String? error;
  final DateTime timestamp;

  bool get isSuccess => error == null;
}
