import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/core/services/integration_hub.dart';
import 'package:knight_os/core/services/evidence_service.dart';
import 'package:knight_os/core/services/timeline_service.dart';
import 'package:knight_os/core/services/mission_service.dart';
import 'package:knight_os/core/services/event_bus.dart';
import 'package:knight_os/core/intelligence/normalization_pipeline.dart';
import 'package:knight_os/core/connectors/manual_connector.dart';
import 'package:knight_os/core/domain/entities/evidence.dart';
import 'package:knight_os/core/domain/entities/timeline_event.dart';
import 'package:knight_os/core/domain/entities/mission.dart';
import 'package:knight_os/core/domain/repositories/i_evidence_repository.dart';
import 'package:knight_os/core/domain/repositories/i_timeline_repository.dart';
import 'package:knight_os/core/domain/repositories/i_mission_repository.dart';
import 'package:knight_os/core/domain/connectors/i_connector.dart';

class MockEvidenceRepository extends Mock implements IEvidenceRepository {}
class MockTimelineRepository extends Mock implements ITimelineRepository {}
class MockMissionRepository extends Mock implements IMissionRepository {}

void main() {
  late IntegrationHub hub;
  late NormalizationPipeline pipeline;
  late ManualConnector connector;
  late EvidenceService evidenceService;
  late TimelineService timelineService;
  late MissionService missionService;
  late EventBus eventBus;

  late MockEvidenceRepository mockEvidenceRepo;
  late MockTimelineRepository mockTimelineRepo;
  late MockMissionRepository mockMissionRepo;

  setUp(() {
    mockEvidenceRepo = MockEvidenceRepository();
    mockTimelineRepo = MockTimelineRepository();
    mockMissionRepo = MockMissionRepository();

    eventBus = EventBus.instance;
    evidenceService = EvidenceService(mockEvidenceRepo);
    timelineService = TimelineService(mockTimelineRepo);
    missionService = MissionService(mockMissionRepo, eventBus: eventBus);

    pipeline = NormalizationPipeline(
      evidenceService: evidenceService,
      timelineService: timelineService,
      eventBus: eventBus,
    );

    connector = ManualConnector(pipeline: pipeline);
    hub = IntegrationHub.instance;
    hub.register(connector);

    registerFallbackValue(TimelineEventType.activity);
    registerFallbackValue(Mission(
      id: 'any', title: 'any', type: MissionType.task, owningDomain: 'test',
      status: MissionStatus.draft, priority: MissionPriority.medium,
      importance: 5, urgency: 5, alignmentScore: 0.5, createdAt: DateTime.now(),
    ));
    registerFallbackValue(TimelineEvent(
      id: 'any', type: TimelineEventType.activity, title: 'any',
      startTime: DateTime.now(), endTime: DateTime.now(),
    ));
    registerFallbackValue(Evidence(
      caid: 'any', originalName: 'any', mimeType: 'any', fileSize: 0,
      ingestedAt: DateTime.now(), storagePath: 'any',
    ));
  });

  group('M3-WP2 Manual Import Integration', () {
    test('Importing a resume creates Evidence, TimelineEvent and Mission', () async {
      final now = DateTime.now();
      
      when(() => mockEvidenceRepo.store(any())).thenAnswer((_) async {});
      when(() => mockTimelineRepo.storeEvent(any())).thenAnswer((_) async {});
      when(() => mockMissionRepo.storeMission(any())).thenAnswer((_) async {});

      await connector.importFile(
        type: 'resume',
        path: '/dummy/resume.pdf',
        caid: 'caid_resume_123',
        name: 'my_resume.pdf',
        metadata: {
          'timestamp': now.toIso8601String(),
          'title': 'Resume: my_resume.pdf',
        },
      );

      // Verify Evidence was ingested
      verify(() => mockEvidenceRepo.store(any(that: isA<Evidence>().having((e) => e.caid, 'caid', 'caid_resume_123')))).called(1);

      // Verify Timeline Event was recorded
      verify(() => mockTimelineRepo.storeEvent(any(that: isA<TimelineEvent>().having((e) => e.title, 'title', 'Resume: my_resume.pdf')))).called(1);

      // Verify Mission was suggested
      await Future.delayed(const Duration(milliseconds: 100));
      verify(() => mockMissionRepo.storeMission(any(that: isA<Mission>().having((m) => m.title, 'title', 'Review and update Career DNA')))).called(1);
    });

    test('Import failure updates connector status to failed', () async {
      when(() => mockEvidenceRepo.store(any())).thenThrow(Exception('Disk Full'));

      try {
        await connector.importFile(
          type: 'csv',
          path: '/dummy/data.csv',
          caid: 'caid_csv_failed',
          name: 'data.csv',
        );
      } catch (_) {
        // Expected
      }

      expect(connector.status, ConnectorStatus.failed);
    });
  });
}
