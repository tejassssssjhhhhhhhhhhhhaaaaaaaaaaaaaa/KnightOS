import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/core/domain/entities/mission.dart';
import 'package:knight_os/core/domain/repositories/i_mission_repository.dart';
import 'package:knight_os/core/domain/providers/i_mission_provider.dart';
import 'package:knight_os/core/services/mission_service.dart';

class MockMissionRepository extends Mock implements IMissionRepository {}
class MockMissionProvider extends Mock implements IMissionProvider {}

void main() {
  late MissionService missionService;
  late MockMissionRepository mockRepository;

  setUp(() {
    mockRepository = MockMissionRepository();
    missionService = MissionService(mockRepository);

    registerFallbackValue(Mission(
      id: 'any',
      title: 'any',
      type: MissionType.task,
      owningDomain: 'test',
      status: MissionStatus.draft,
      priority: MissionPriority.medium,
      importance: 5,
      urgency: 5,
      alignmentScore: 0.5,
      createdAt: DateTime.now(),
    ));
  });

  group('MissionService Lifecycle', () {
    test('createMission() stores mission in repository', () async {
      when(() => mockRepository.storeMission(any())).thenAnswer((_) async {});

      final mission = await missionService.createMission(
        title: 'Learn AI Architecture',
        type: MissionType.learning,
        owningDomain: 'career',
        priority: MissionPriority.high,
        importance: 8,
      );

      expect(mission.title, 'Learn AI Architecture');
      expect(mission.owningDomain, 'career');
      expect(mission.importance, 8);
      verify(() => mockRepository.storeMission(any())).called(1);
    });

    test('updateStatus() completes mission and notifies provider', () async {
      final mission = Mission(
        id: 'm1',
        title: 'Task 1',
        type: MissionType.task,
        owningDomain: 'finance',
        status: MissionStatus.active,
        priority: MissionPriority.medium,
        importance: 5,
        urgency: 5,
        alignmentScore: 0.5,
        createdAt: DateTime.now(),
      );

      final mockProvider = MockMissionProvider();
      when(() => mockProvider.domain).thenReturn('finance');
      when(() => mockProvider.onMissionUpdated(any())).thenAnswer((_) async {});
      
      missionService.registerProvider(mockProvider);

      when(() => mockRepository.getById('m1')).thenAnswer((_) async => mission);
      when(() => mockRepository.storeMission(any())).thenAnswer((_) async {});

      await missionService.updateStatus('m1', MissionStatus.completed);

      verify(() => mockRepository.storeMission(any(that: isA<Mission>().having((m) => m.status, 'status', MissionStatus.completed)))).called(1);
      verify(() => mockProvider.onMissionUpdated(any())).called(1);
    });
  });

  group('MissionService Prioritization (Daily Focus)', () {
    test('getDailyFocus() ranks missions based on importance/urgency/alignment', () async {
      final m1 = Mission(
        id: '1', title: 'Low Priority', type: MissionType.task, owningDomain: 'test',
        status: MissionStatus.active, priority: MissionPriority.low, importance: 2, urgency: 2, alignmentScore: 0.1, createdAt: DateTime.now(),
      );
      final m2 = Mission(
        id: '2', title: 'High Priority', type: MissionType.task, owningDomain: 'test',
        status: MissionStatus.active, priority: MissionPriority.high, importance: 9, urgency: 9, alignmentScore: 0.9, createdAt: DateTime.now(),
      );

      when(() => mockRepository.getActiveMissions()).thenAnswer((_) async => [m1, m2]);

      final focus = await missionService.getDailyFocus();

      expect(focus.first.id, '2');
      expect(focus.last.id, '1');
    });
  });
}
