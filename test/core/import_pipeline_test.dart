import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/core/intelligence/normalization_pipeline.dart';
import 'package:knight_os/core/services/evidence_service.dart';
import 'package:knight_os/core/services/timeline_service.dart';
import 'package:knight_os/core/services/event_bus.dart';
import 'package:knight_os/core/domain/entities/evidence.dart';
import 'package:knight_os/core/domain/entities/timeline_event.dart';
import 'package:knight_os/core/domain/events/integration_events.dart';

class MockEvidenceService extends Mock implements EvidenceService {}
class MockTimelineService extends Mock implements TimelineService {}

void main() {
  late NormalizationPipeline pipeline;
  late MockEvidenceService mockEvidence;
  late MockTimelineService mockTimeline;
  late EventBus eventBus;

  setUp(() {
    mockEvidence = MockEvidenceService();
    mockTimeline = MockTimelineService();
    eventBus = EventBus.instance;
    pipeline = NormalizationPipeline(
      evidenceService: mockEvidence,
      timelineService: mockTimeline,
    );

    registerFallbackValue(TimelineEventType.activity);
  });

  group('NormalizationPipeline Integration', () {
    test('process() creates evidence and records timeline event', () async {
      final now = DateTime.now();
      final evidence = Evidence(
        caid: 'hash123',
        originalName: 'test.pdf',
        mimeType: 'application/pdf',
        fileSize: 1024,
        ingestedAt: now,
        storagePath: '/vault/test.pdf',
      );

      when(() => mockEvidence.ingest(
        caid: any(named: 'caid'),
        originalName: any(named: 'originalName'),
        mimeType: any(named: 'mimeType'),
        fileSize: any(named: 'fileSize'),
        storagePath: any(named: 'storagePath'),
        metadata: any(named: 'metadata'),
      )).thenAnswer((_) async => evidence);

      when(() => mockTimeline.record(
        type: any(named: 'type'),
        title: any(named: 'title'),
        startTime: any(named: 'startTime'),
        endTime: any(named: 'endTime'),
        location: any(named: 'location'),
        originProviderId: any(named: 'originProviderId'),
        originResourceId: any(named: 'originResourceId'),
        metadata: any(named: 'metadata'),
      )).thenAnswer((_) async => TimelineEvent(
        id: 'e1',
        type: TimelineEventType.activity,
        title: 'test',
        startTime: now,
        endTime: now,
      ));

      final events = <KnightEvent>[];
      eventBus.on<EvidenceImported>().listen(events.add);

      await pipeline.process(
        connectorId: 'manual',
        type: 'certificate',
        caid: 'hash123',
        rawData: {
          'source_name': 'Cert.pdf',
          'timestamp': now.toIso8601String(),
          'title': 'Flutter Expert Cert',
        },
      );

      final capturedMetadata = verify(() => mockEvidence.ingest(
        caid: any(named: 'caid'),
        originalName: any(named: 'originalName'),
        mimeType: any(named: 'mimeType'),
        fileSize: any(named: 'fileSize'),
        storagePath: any(named: 'storagePath'),
        metadata: captureAny(named: 'metadata'),
      )).captured.first as Map<String, dynamic>;

      expect(capturedMetadata['source_connector'], 'manual');
      expect(capturedMetadata['original_type'], 'certificate');
      expect(capturedMetadata.containsKey('ingestion_timestamp'), isTrue);
      
      expect(events.length, 1);
      expect((events.first as EvidenceImported).evidenceId, 'hash123');
    });
  });
}
