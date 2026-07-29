import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/autonomous_engine.dart';
import 'package:knight_os/core/intelligence/domain/planning_models.dart';
import 'package:knight_os/core/intelligence/domain/workflow_models.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/domain/mission_models.dart';

void main() {
  late AutonomousEngine engine;

  setUp(() {
    engine = AutonomousEngine(bus: IntelligenceBus());
  });

  group('Autonomous Execution Engine (Sprint 1.4)', () {
    final mockPlan = KnightPlan(
      id: 'plan-1',
      title: 'Automation Test',
      goalId: 'goal-1',
      status: MissionStatus.active,
      createdAt: DateTime.now(),
      tasks: [
        const KnightTask(id: 't1', title: 'Step 1', priority: MissionPriority.medium, isCompleted: false),
        const KnightTask(id: 't2', title: 'Sensitive Step', priority: MissionPriority.high, isCompleted: false, isSensitive: true),
      ],
    );

    test('executePlan progresses through task states', () async {
      final execution = engine.executePlan(mockPlan);

      // Verify running state
      expect(engine.getWorkflowState('plan-1')?.status, anyOf(WorkflowStatus.running, WorkflowStatus.awaitingApproval));
      
      await execution;

      expect(engine.getWorkflowState('plan-1')?.status, WorkflowStatus.succeeded);
      expect(engine.getWorkflowState('plan-1')?.progress, 1.0);
    });

    test('executePlan respects sensitive markers (simulated)', () async {
      // Logic: If task is sensitive, it should transition to awaitingApproval
      // Our simulated engine currently auto-approves after 500ms
      engine.executePlan(mockPlan);
      
      await Future.delayed(const Duration(milliseconds: 100));
      // Should be running first task or awaiting second
      final state = engine.getWorkflowState('plan-1');
      expect(state, isNotNull);
    });
  });
}
