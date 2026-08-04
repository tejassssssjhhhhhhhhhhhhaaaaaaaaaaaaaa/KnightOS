import '../domain/entities/timeline_event.dart';
import '../domain/repositories/i_timeline_repository.dart';
import '../internal/utils/knight_logger.dart';
import 'package:uuid/uuid.dart';

/// Service for managing the Universal Life Timeline.
class TimelineService {
  TimelineService(this._repository);

  final ITimelineRepository _repository;
  final _uuid = const Uuid();

  /// Records a new event in the timeline.
  Future<TimelineEvent> record({
    required TimelineEventType type,
    required String title,
    required DateTime startTime,
    DateTime? endTime,
    String? location,
    Map<String, dynamic> metadata = const {},
    String? originProviderId,
    String? originResourceId,
    double? confidenceScore,
  }) async {
    final event = TimelineEvent(
      id: _uuid.v4(),
      type: type,
      title: title,
      startTime: startTime,
      endTime: endTime ?? startTime,
      location: location,
      metadata: metadata,
      originProviderId: originProviderId,
      originResourceId: originResourceId,
      confidenceScore: confidenceScore,
    );

    await _repository.storeEvent(event);
    KnightLogger.info('[TIMELINE] Event recorded: ${event.title} (${event.type.name})');
    return event;
  }

  /// Retrieves events for a specific day.
  Future<List<TimelineEvent>> getEventsForDay(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return await _repository.getEvents(start: start, end: end);
  }

  /// Retrieves the most recent timeline events.
  Future<List<TimelineEvent>> getRecent(int limit) async {
    return await _repository.getRecent(limit);
  }

  /// Searches events by type or content (basic implementation).
  Future<List<TimelineEvent>> query({
    DateTime? start,
    DateTime? end,
    TimelineEventType? type,
  }) async {
    final effectiveStart = start ?? DateTime.fromMillisecondsSinceEpoch(0);
    final effectiveEnd = end ?? DateTime.now().add(const Duration(days: 3650));
    
    return await _repository.getEvents(
      start: effectiveStart,
      end: effectiveEnd,
      type: type,
    );
  }
}
