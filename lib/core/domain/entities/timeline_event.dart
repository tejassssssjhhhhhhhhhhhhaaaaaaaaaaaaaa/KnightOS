import 'package:equatable/equatable.dart';

/// Supported types of life events in the Universal Timeline.
enum TimelineEventType {
  visit,
  activity,
  milestone,
  meeting,
  task,
  transaction,
  workSession,
  healthMetric,
  promotion,
  education,
  internship,
  employment,
  salaryMilestone,
  certification,
  project,
  award,
  performanceReview,
}

/// Verification state of a timeline event.
enum VerificationState {
  unverified,
  verified,
  disputed,
  archived,
}

/// A unified chronological record of a significant event in the user's life.
class TimelineEvent extends Equatable {
  const TimelineEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.location,
    this.metadata = const {},
    this.originProviderId,
    this.originResourceId,
    this.confidenceScore,
    this.verificationState = VerificationState.unverified,
  });

  /// Unique identifier for the event.
  final String id;

  /// The category of the event.
  final TimelineEventType type;

  /// User-friendly title.
  final String title;

  /// When the event started.
  final DateTime startTime;

  /// When the event ended (can be same as startTime for point events).
  final DateTime endTime;

  /// Optional geographic or logical location.
  final String? location;

  /// Domain-specific metadata.
  final Map<String, dynamic> metadata;

  /// ID of the provider that generated this event (e.g., 'google.com', 'knight.career').
  final String? originProviderId;

  /// Unique ID within the origin provider.
  final String? originResourceId;

  /// AI-generated confidence score (0.0 - 1.0).
  final double? confidenceScore;

  /// Current verification status.
  final VerificationState verificationState;

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        startTime,
        endTime,
        location,
        metadata,
        originProviderId,
        originResourceId,
        confidenceScore,
        verificationState,
      ];

  @override
  bool? get stringify => true;
}
