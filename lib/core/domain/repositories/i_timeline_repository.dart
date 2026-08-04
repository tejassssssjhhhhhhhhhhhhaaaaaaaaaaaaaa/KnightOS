import '../entities/timeline_event.dart';

/// Interface for chronological data persistence.
abstract class ITimelineRepository {
  /// Inserts or updates an event in the timeline.
  Future<void> storeEvent(TimelineEvent event);

  /// Retrieves events within a specific time range.
  Future<List<TimelineEvent>> getEvents({
    required DateTime start,
    required DateTime end,
    TimelineEventType? type,
  });

  /// Retrieves the most recent events.
  Future<List<TimelineEvent>> getRecent(int limit);

  /// Deletes an event by ID.
  Future<void> deleteEvent(String id);
}
