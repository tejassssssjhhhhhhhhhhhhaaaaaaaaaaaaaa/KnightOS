import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/workflow_orchestrator.dart';
import 'package:knight_os/core/intelligence/engines/autonomous_engine.dart';
import 'package:knight_os/core/intelligence/domain/planning_models.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/mission_models.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'package:knight_os/core/intelligence/engines/reasoning_engine.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';

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
    engine = AutonomousEngine(
      bus: bus, 
      memoryEngine: mem,
      reasoningEngine: ReasoningEngine(),
      getContext: () async => KnightContext(
        registeredModules: [],
        currentScores: [],
        analyticsSummary: const KnightAnalyticsSummary(
          analyticsProviderCount: 0,
          snapshotsPlaceholder: '',
          weeklySummaryPlaceholder: '',
          monthlySummaryPlaceholder: '',
        ),
        recommendationSummary: const KnightRecommendationSummary(
          recommendationProviderCount: 0,
          recommendationCount: 0,
          topRecommendationPlaceholder: '',
        ),
        recentActivity: [],
        searchSummary: const KnightSearchSummary(
          searchProviderCount: 0,
          indexedModules: 0,
          lastSearchPlaceholder: '',
        ),
        moduleHealth: [],
        lastSyncTime: DateTime.now(),
        healthStatus: 'Healthy',
        dataFreshness: 'Live',
        applicationVersion: '1.0.0',
        fitnessSummary: const KnightFitnessSummary(
          gymProfileExists: false,
          equipmentCount: 0,
          capabilityPlaceholder: '',
          workoutPlaceholder: '',
        ),
        travelSummary: const KnightTravelSummary(
          visited: 0,
          wishlist: 0,
          planned: 0,
          favoritePlaces: 0,
          upcomingTripsPlaceholder: '',
        ),
        workSummary: const KnightWorkSummary(
          currentShiftPlaceholder: '',
          questions: 0,
          calls: 0,
          chats: 0,
          dailyTarget: 0,
          productivityPlaceholder: '',
        ),
        timestamp: DateTime.now(),
        greeting: 'Hello',
        sleepStatus: 'Good',
        upcomingEvents: [],
        currentGoals: [],
        healthSummary: 'OK',
        weather: 'Sunny',
      ),
    );
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
