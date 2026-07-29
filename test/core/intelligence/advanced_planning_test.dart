import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/ai_provider.dart';
import 'package:knight_os/core/intelligence/engines/planning_engine.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';

class MockAiProvider extends Fake implements KnightAiProvider {
  @override
  Future<String> chat({required List<KnightMemory> context, required String prompt}) async {
    return 'Plan generated successfully';
  }
}

void main() {
  late PlanningEngine engine;

  setUp(() {
    engine = PlanningEngine(aiProvider: MockAiProvider());
  });

  group('Advanced Planning Engine', () {
    final mockContext = KnightContext(
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
      healthStatus: 'Optimal',
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
      greeting: 'Morning',
      sleepStatus: 'Optimal recovery',
      upcomingEvents: [],
      currentGoals: [],
      healthSummary: 'Vital signs nominal',
      weather: 'Clear skies',
      focusScore: 0.87,
    );

    test('decomposeGoalWithAI produces a hierarchical plan with dependencies', () async {
      final plan = await engine.decomposeGoalWithAI(
        objective: 'Run a Marathon',
        context: mockContext,
      );

      expect(plan.title, 'Run a Marathon');
      expect(plan.tasks, isNotEmpty);
      expect(plan.milestones, isNotEmpty);
      
      // Verify dependency linkage
      final taskWithDependency = plan.tasks.firstWhere((t) => t.dependencyIds.isNotEmpty);
      expect(taskWithDependency.dependencyIds.first, plan.tasks.first.id);
    });
  });
}
