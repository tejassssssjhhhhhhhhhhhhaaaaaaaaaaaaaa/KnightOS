import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/domain/entities/mission.dart';
import 'package:knight_os/core/domain/entities/conflict.dart';
import 'package:knight_os/core/intelligence/conflict_resolver.dart';

void main() {
  late ConflictResolver resolver;

  setUp(() {
    resolver = ConflictResolver();
  });

  group('ConflictResolver Analysis', () {
    test('Detects energy overload when total > 10', () {
      final now = DateTime.now();
      final m1 = Mission(
        id: '1', title: 'Task 1', type: MissionType.task, owningDomain: 'test',
        status: MissionStatus.active, priority: MissionPriority.high,
        importance: 5, urgency: 5, alignmentScore: 0.5, createdAt: now,
        dueDate: now, estimatedEnergyRequirement: 6,
      );
      final m2 = Mission(
        id: '2', title: 'Task 2', type: MissionType.task, owningDomain: 'test',
        status: MissionStatus.active, priority: MissionPriority.high,
        importance: 5, urgency: 5, alignmentScore: 0.5, createdAt: now,
        dueDate: now, estimatedEnergyRequirement: 5,
      );

      final conflicts = resolver.analyze([m1, m2]);
      expect(conflicts.any((c) => c.type == ConflictType.energyOverload), isTrue);
    });

    test('Detects urgency overlap when > 2 high urgency missions', () {
      final now = DateTime.now();
      final m1 = Mission(id: '1', title: 'U1', type: MissionType.task, owningDomain: 't', status: MissionStatus.active, priority: MissionPriority.high, importance: 5, urgency: 9, alignmentScore: 0.5, createdAt: now);
      final m2 = Mission(id: '2', title: 'U2', type: MissionType.task, owningDomain: 't', status: MissionStatus.active, priority: MissionPriority.high, importance: 5, urgency: 9, alignmentScore: 0.5, createdAt: now);
      final m3 = Mission(id: '3', title: 'U3', type: MissionType.task, owningDomain: 't', status: MissionStatus.active, priority: MissionPriority.high, importance: 5, urgency: 9, alignmentScore: 0.5, createdAt: now);

      final conflicts = resolver.analyze([m1, m2, m3]);
      expect(conflicts.any((c) => c.type == ConflictType.priorityMismatch), isTrue);
    });
  });

  group('ConflictResolver Resolution', () {
    test('Proposes deferring mission with lowest alignment', () {
      final now = DateTime.now();
      final m1 = Mission(id: '1', title: 'Low Align', type: MissionType.task, owningDomain: 't', status: MissionStatus.active, priority: MissionPriority.high, importance: 5, urgency: 5, alignmentScore: 0.1, createdAt: now);
      final m2 = Mission(id: '2', title: 'High Align', type: MissionType.task, owningDomain: 't', status: MissionStatus.active, priority: MissionPriority.high, importance: 5, urgency: 5, alignmentScore: 0.9, createdAt: now);

      final conflict = Conflict(id: 'c1', type: ConflictType.priorityMismatch, description: 'Test', involvedMissionIds: ['1', '2']);
      final resolution = resolver.proposeResolution(conflict, [m1, m2]);

      expect(resolution.actionPlan.first, contains('Low Align'));
    });
  });
}
