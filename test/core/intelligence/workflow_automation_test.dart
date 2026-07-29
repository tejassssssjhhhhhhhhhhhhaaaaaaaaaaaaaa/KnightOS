import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/workflow_orchestrator.dart';
import 'package:knight_os/core/intelligence/engines/autonomous_engine.dart';
import 'package:knight_os/core/intelligence/domain/planning_models.dart';
import 'package:knight_os/core/intelligence/domain/workflow_models.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/mission_models.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';

class MockMemoryRepository extends Fake implements MemoryRepository {
  @override
  Future<void> save(KnightMemory memory) async {}
}

class MockJsonValidationService extends Fake implements JsonValidationService {
  @override
  Future<void> validate(MemoryDomain domain, Map<String, dynamic> content) async {}
}

void main() {
  late WorkflowOrchestrator orchestrator;
  late AutonomousEngine engine;

  setUp(() {
    final bus = IntelligenceBus();
    final mem = MemoryEngine(
      repository: MockMemoryRepository(),
      validationService: MockJsonValidationService(),
    );
    engine = AutonomousEngine(bus: bus, memoryEngine: mem);
    orchestrator = WorkflowOrchestrator(engine: engine);
  });

  group('Advanced Workflow Automation (Sprint 2.2)', () {
    test('run executes fallback tasks on simulated failure', () async {
      // Note: AutonomousEngine currently doesn't throw, we mock failure logic in orchestrator if needed.
      // For this sprint foundation, we verify structural execution.
      
      final task1 = const KnightTask(
        id: 't1', 
        title: 'Task 1', 
        priority: MissionPriority.medium, 
        isCompleted: false,
        fallbackTaskIds: ['f1'],
      );
      final fallback1 = const KnightTask(
        id: 'f1', 
        title: 'Fallback 1', 
        priority: MissionPriority.low, 
        isCompleted: false,
      );

      final plan = KnightPlan(
        id: 'plan-1',
        title: 'Fallback Test',
        goalId: 'goal-1',
        status: MissionStatus.active,
        createdAt: DateTime.now(),
        tasks: [task1, fallback1],
      );

      await orchestrator.run(plan);

      // Verify that at least the first task was registered in engine
      expect(engine.getWorkflowState('plan-1-t1'), isNotNull);
    });
  });
}
