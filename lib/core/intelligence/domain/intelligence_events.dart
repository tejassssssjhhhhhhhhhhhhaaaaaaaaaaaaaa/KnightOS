import 'package:flutter/foundation.dart';
import 'knight_memory.dart';
import 'cognitive_models.dart';

/// Base class for all events that trigger intelligence recomputation.
@immutable
abstract class IntelligenceEvent {
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
