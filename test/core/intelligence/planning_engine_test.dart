import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/planning_models.dart';
import 'package:knight_os/core/intelligence/domain/reasoning_models.dart';
import 'package:knight_os/core/intelligence/engines/planning_engine.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/platform/engine/recommendation_models.dart';
import 'package:knight_os/core/intelligence/domain/mission_models.dart';

void main() {
  late PlanningEngine engine;

  setUp(() {
    engine = const PlanningEngine();
  });

  group('PlanningEngine', () {
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
    );

    final mockReasoning = ReasoningResult(
      summary: 'Situational report',
      insights: [],
      recommendations: [
        KnightRecommendation(
          id: 'rec-1',
          title: 'Morning Run',
          description: 'High energy window open.',
          category: KnightRecommendationCategory.fitness,
          priority: KnightRecommendationPriority.medium,
          confidence: const KnightRecommendationConfidence(value: 0.8),
          reason: KnightRecommendationReason(summary: 'Rule-based'),
          source: const KnightRecommendationSource(name: 'Engine'),
          action: const KnightRecommendationAction(label: 'Start'),
          timestamp: DateTime.now(),
        ),
      ],
      warnings: [],
      opportunities: [],
      trace: const ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: [],
        thoughtChain: [],
        confidence: 0.8,
      ),
    );

    test('converts recommendations into suggested tasks', () {
      final result = engine.plan(
        context: mockContext,
        memories: [],
        reasoning: mockReasoning,
      );

      expect(result.suggestedTasks, isNotEmpty);
      expect(result.suggestedTasks.first.title, 'Morning Run');
      expect(result.dailyPlan.tasks, contains(result.suggestedTasks.first));
    });

    test('inserts recovery task when sleep warning is present', () {
      final warningReasoning = ReasoningResult(
        summary: 'Report',
        insights: [],
        recommendations: [],
        warnings: ['High sleep debt detected.'],
        opportunities: [],
        trace: mockReasoning.trace,
      );

      final result = engine.plan(
        context: mockContext,
        memories: [],
        reasoning: warningReasoning,
      );

      expect(result.suggestedTasks.any((t) => t.id == 'task-mitigation-sleep'), isTrue);
      expect(result.dailyPlan.tasks.first.id, 'task-mitigation-sleep');
    });

    test('prioritizes work tasks in the morning', () {
      final workRec = KnightRecommendation(
        id: 'rec-work',
        title: 'Deep Work',
        description: 'Focus on project.',
        category: KnightRecommendationCategory.work,
        priority: KnightRecommendationPriority.medium,
        confidence: const KnightRecommendationConfidence(value: 0.8),
        reason: KnightRecommendationReason(summary: 'Rule'),
        source: const KnightRecommendationSource(name: 'Engine'),
        action: const KnightRecommendationAction(label: 'Focus'),
        timestamp: DateTime.now(),
      );

      final mixedReasoning = ReasoningResult(
        summary: 'Report',
        insights: [],
        recommendations: [mockReasoning.recommendations.first, workRec],
        warnings: [],
        opportunities: [],
        trace: mockReasoning.trace,
      );

      final result = engine.plan(
        context: mockContext, // Morning
        memories: [],
        reasoning: mixedReasoning,
      );

      expect(result.dailyPlan.tasks.first.title, 'Deep Work');
    });
  });
}
