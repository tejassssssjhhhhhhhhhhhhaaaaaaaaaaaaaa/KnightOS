import 'dart:convert';
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
    registerFallbackValue(TimelineEvent(
      id: 'any',
      type: TimelineEventType.activity,
      title: 'any',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    ));
  });

  group('Timeline Integrity Validation', () {
    test('Metadata serialization handling', () async {
      final complexMetadata = {
        'nested': {'key': 'value'},
        'list': [1, 2, 3],
        'bool': true,
      };

      when(() => mockRepository.storeEvent(any())).thenAnswer((_) async {});

      final event = await timelineService.record(
        type: TimelineEventType.transaction,
        title: 'Lunch',
        startTime: DateTime.now(),
        metadata: complexMetadata,
      );

      expect(event.metadata, complexMetadata);
      verify(() => mockRepository.storeEvent(any())).called(1);
    });

    test('Cross-domain event support', () async {
      when(() => mockRepository.storeEvent(any())).thenAnswer((_) async {});

      // Career Event
      await timelineService.record(
        type: TimelineEventType.promotion,
        title: 'Senior Engineer',
        startTime: DateTime.now(),
        metadata: {'level': 6},
      );

      // Health Event
      await timelineService.record(
        type: TimelineEventType.healthMetric,
        title: 'Morning Run',
        startTime: DateTime.now(),
        metadata: {'distance': 5000},
      );

      verify(() => mockRepository.storeEvent(any())).called(2);
    });

    test('Time range query logic', () async {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 12, 31);

      when(() => mockRepository.getEvents(start: start, end: end))
          .thenAnswer((_) async => []);

      await timelineService.query(start: start, end: end);

      verify(() => mockRepository.getEvents(start: start, end: end)).called(1);
    });
  });

  group('Performance Simulation', () {
    test('Bulk ingestion latency simulation', () async {
      when(() => mockRepository.storeEvent(any())).thenAnswer((_) async {});
      
      final stopwatch = Stopwatch()..start();
      for (var i = 0; i < 100; i++) {
        await timelineService.record(
          type: TimelineEventType.activity,
          title: 'Event $i',
          startTime: DateTime.now(),
        );
      }
      stopwatch.stop();
      
      // Target: < 2ms per ingestion on mock (just logic overhead)
      expect(stopwatch.elapsedMilliseconds, lessThan(200));
    });
  });
}
