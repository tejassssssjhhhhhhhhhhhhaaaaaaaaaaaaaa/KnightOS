import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/autonomous_engine.dart';
import 'package:knight_os/core/intelligence/domain/planning_models.dart';
import 'package:knight_os/core/intelligence/domain/workflow_models.dart';
import 'package:knight_os/core/intelligence/domain/approval_models.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/mission_models.dart';
import 'package:knight_os/core/intelligence/domain/intelligence_events.dart';
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
      reasoningEngine: const ReasoningEngine(),
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
      final simplePlan = KnightPlan(
        id: 'simple-plan',
        title: 'Simple Test',
        goalId: 'goal-1',
        status: MissionStatus.active,
        createdAt: DateTime.now(),
        tasks: [
          const KnightTask(id: 't1', title: 'Step 1', priority: MissionPriority.medium, isCompleted: false),
        ],
      );

      final execution = engine.executePlan(simplePlan);

      // Verify running state
      await Future.delayed(const Duration(milliseconds: 100));
      expect(engine.getWorkflowState('simple-plan')?.status, WorkflowStatus.running);
      
      await execution;

      expect(engine.getWorkflowState('simple-plan')?.status, WorkflowStatus.succeeded);
      expect(engine.getWorkflowState('simple-plan')?.progress, 1.0);
    });

    test('executePlan respects sensitive markers', () async {
      final execution = engine.executePlan(mockPlan);
      
      // Step 1 is not sensitive, but Step 2 is.
      // Wait for it to reach Step 2
      await Future.delayed(const Duration(milliseconds: 500));

      final state = engine.getWorkflowState('plan-1');
      expect(state?.status, WorkflowStatus.awaitingApproval);
      expect(engine.pendingApprovals.isNotEmpty, true);

      // Resolve it to finish
      engine.resolveApproval(engine.pendingApprovals.first.id, ApprovalStatus.approved);
      await execution;
    });

    test('failure capture triggers reasoning', () async {
      final failingPlan = KnightPlan(
        id: 'fail-plan',
        title: 'Failing Test',
        goalId: 'goal-1',
        status: MissionStatus.active,
        createdAt: DateTime.now(),
        tasks: [
          const KnightTask(id: 't-error', title: 'FAIL', priority: MissionPriority.medium, isCompleted: false),
        ],
      );

      await engine.executePlan(failingPlan);
      
      final state = engine.getWorkflowState('fail-plan');
      expect(state?.status, WorkflowStatus.failed);
      
      final reasoning = engine.getFailureReasoning('fail-plan');
      expect(reasoning, isNotNull);
      expect(reasoning?.summary, contains('Heuristic Repair'));
    });

    test('executePlan pauses for sensitive tasks and resumes on approval', () async {
      final sensitivePlan = KnightPlan(
        id: 'sensitive-plan',
        title: 'Sensitive Test',
        goalId: 'goal-1',
        status: MissionStatus.active,
        createdAt: DateTime.now(),
        tasks: [
          const KnightTask(id: 't-secure', title: 'Payment', priority: MissionPriority.critical, isCompleted: false, isSensitive: true),
        ],
      );

      final execution = engine.executePlan(sensitivePlan);

      // Wait a bit for it to reach the sensitive task
      await Future.delayed(const Duration(milliseconds: 100));

      expect(engine.getWorkflowState('sensitive-plan')?.status, WorkflowStatus.awaitingApproval);
      expect(engine.pendingApprovals.length, 1);

      final requestId = engine.pendingApprovals.first.id;
      engine.resolveApproval(requestId, ApprovalStatus.approved);

      await execution;

      expect(engine.getWorkflowState('sensitive-plan')?.status, WorkflowStatus.succeeded);
    });

    test('executePlan delegates tasks to remote devices', () async {
      final remotePlan = KnightPlan(
        id: 'remote-plan',
        title: 'Remote Test',
        goalId: 'goal-1',
        status: MissionStatus.active,
        createdAt: DateTime.now(),
        tasks: [
          const KnightTask(id: 't-remote', title: 'Compute', priority: MissionPriority.medium, isCompleted: false, targetDeviceId: 'desktop-1'),
        ],
      );

      final execution = engine.executePlan(remotePlan);

      // Should be waiting for remote completion
      await Future.delayed(const Duration(milliseconds: 100));
      expect(engine.getWorkflowState('remote-plan')?.status, WorkflowStatus.running);
      
      // Simulate remote completion
      final bus = engine.bus;
      bus.emit(RemoteTaskCompletedEvent(taskId: 't-remote', planId: 'remote-plan'));

      await execution;

      expect(engine.getWorkflowState('remote-plan')?.status, WorkflowStatus.succeeded);
    });

    test('executePlan heals via fallback task', () async {
      final fallbackPlan = KnightPlan(
        id: 'healing-plan',
        title: 'Healing Test',
        goalId: 'goal-1',
        status: MissionStatus.active,
        createdAt: DateTime.now(),
        tasks: [
          const KnightTask(
            id: 't-fail', 
            title: 'FAIL', 
            priority: MissionPriority.medium, 
            isCompleted: false, 
            fallbackTaskIds: ['t-fix'],
          ),
          const KnightTask(
            id: 't-fix', 
            title: 'SUCCESS FALLBACK', 
            priority: MissionPriority.low, 
            isCompleted: false,
          ),
        ],
      );

      await engine.executePlan(fallbackPlan);
      
      // Should succeed because fallback fixed it
      expect(engine.getWorkflowState('healing-plan')?.status, WorkflowStatus.succeeded);
    });
  });
}
