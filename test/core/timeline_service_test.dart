import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/core/domain/entities/timeline_event.dart';
import 'package:knight_os/core/domain/repositories/i_timeline_repository.dart';
import 'package:knight_os/core/services/timeline_service.dart';

class MockTimelineRepository extends Mock implements ITimelineRepository {}

void main() {
  late TimelineService timelineService;
  late MockTimelineRepository mockRepository;

  setUp(() {
    mockRepository = MockTimelineRepository();
    timelineService = TimelineService(mockRepository);

    registerFallbackValue(
      TimelineEvent(
        id: 'any',
        type: TimelineEventType.activity,
        title: 'any',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
      ),
    );
  });

  group('TimelineService Ingestion', () {
    test('record() correctly creates and stores an event', () async {
      when(() => mockRepository.storeEvent(any())).thenAnswer((_) async {});

      final now = DateTime.now();
      final event = await timelineService.record(
        type: TimelineEventType.milestone,
        title: 'Project Alpha Completed',
        startTime: now,
        location: 'Office',
        metadata: {'project': 'Alpha'},
      );

      expect(event.title, 'Project Alpha Completed');
      expect(event.type, TimelineEventType.milestone);
      expect(event.location, 'Office');
      expect(event.metadata['project'], 'Alpha');
      
      verify(() => mockRepository.storeEvent(any())).called(1);
    });
  });

  group('TimelineService Querying', () {
    test('getEventsForDay() calls repository with correct range', () async {
      final day = DateTime(2026, 8, 4);
      final start = DateTime(2026, 8, 4);
      final end = start.add(const Duration(days: 1));

      when(() => mockRepository.getEvents(
        start: any(named: 'start'),
        end: any(named: 'end'),
      )).thenAnswer((_) async => []);

      await timelineService.getEventsForDay(day);

      verify(() => mockRepository.getEvents(
        start: start,
        end: end,
      )).called(1);
    });
  });
}
