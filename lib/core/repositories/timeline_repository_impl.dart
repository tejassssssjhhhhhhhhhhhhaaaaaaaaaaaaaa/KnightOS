import 'dart:convert';
import 'package:drift/drift.dart';
import '../domain/entities/timeline_event.dart';
import '../domain/repositories/i_timeline_repository.dart';
import '../internal/storage/drift/knight_database.dart';

class TimelineRepositoryImpl implements ITimelineRepository {
  TimelineRepositoryImpl(this._dao);

  final TimelineDao _dao;

  @override
  Future<void> storeEvent(TimelineEvent event) async {
    await _dao.insertEvents([
      TimelineEventTableCompanion.insert(
        id: event.id,
        type: event.type.name,
        title: event.title,
        startTime: event.startTime,
        endTime: event.endTime,
        location: Value(event.location),
        metadata: Value(json.encode(event.metadata)),
        originProviderId: Value(event.originProviderId),
        originResourceId: Value(event.originResourceId),
        confidenceScore: Value(event.confidenceScore),
        verificationState: Value(event.verificationState.name.toUpperCase()),
      )
    ]);
  }

  @override
  Future<List<TimelineEvent>> getEvents({
    required DateTime start,
    required DateTime end,
    TimelineEventType? type,
  }) async {
    final data = await _dao.getEventsInRange(start, end);
    var entities = data.map(_mapToEntity).toList();
    
    if (type != null) {
      entities = entities.where((e) => e.type == type).toList();
    }
    
    return entities;
  }

  @override
  Future<List<TimelineEvent>> getRecent(int limit) async {
    final data = await _dao.getRecentEvents(limit: limit);
    return data.map(_mapToEntity).toList();
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _dao.deleteById(id);
  }

  TimelineEvent _mapToEntity(TimelineEventData data) {
    return TimelineEvent(
      id: data.id,
      type: TimelineEventType.values.firstWhere(
        (t) => t.name == data.type,
        orElse: () => TimelineEventType.activity,
      ),
      title: data.title,
      startTime: data.startTime,
      endTime: data.endTime,
      location: data.location,
      metadata: data.metadata != null 
          ? json.decode(data.metadata!) as Map<String, dynamic> 
          : {},
      originProviderId: data.originProviderId,
      originResourceId: data.originResourceId,
      confidenceScore: data.confidenceScore,
      verificationState: VerificationState.values.firstWhere(
        (v) => v.name.toUpperCase() == data.verificationState,
        orElse: () => VerificationState.unverified,
      ),
    );
  }
}
