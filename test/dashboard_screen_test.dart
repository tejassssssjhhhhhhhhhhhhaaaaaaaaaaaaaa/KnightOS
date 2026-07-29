import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/app/home_screen.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/intelligence/knight_context_provider.dart';
import 'package:knight_os/core/intelligence/domain/planning_models.dart';
import 'package:knight_os/core/intelligence/domain/mission_models.dart';
import 'package:knight_os/core/intelligence/domain/reasoning_models.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';

class MockContextNotifier extends CurrentContextNotifier {
  @override
  Future<KnightContext> build() async {
    return KnightContext(
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
      currentGoals: ['Test Goal'],
      healthSummary: 'Vital signs nominal',
      weather: 'Clear skies',
      focusScore: 0.87,
      totalBalance: 245000,
      steps: 8000,
      calories: 1200,
      waterIntake: 1.8,
      planning: PlanningResult(
        dailyPlan: KnightPlan(
          id: 'plan-1',
          title: 'Daily Routine',
          goalId: 'goal-1',
          status: MissionStatus.active,
          createdAt: DateTime.now(),
          tasks: [
            const KnightTask(
              id: 't1',
              title: 'Test Goal',
              priority: MissionPriority.medium,
              isCompleted: false,
            ),
          ],
        ),
        activePlans: [],
        suggestedTasks: [],
        timestamp: DateTime.now(),
        reasoningUsed: const ReasoningResult(
          summary: '',
          insights: [],
          recommendations: [],
          warnings: [],
          opportunities: [],
          trace: ReasoningTrace(
            intent: KnightIntent.analysis,
            memoriesUsed: [],
            rulesApplied: [],
            goalsConsidered: [],
            thoughtChain: [],
            confidence: 1.0,
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('HomeScreen renders successfully with live data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentContextNotifierProvider.overrideWith(MockContextNotifier.new),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // Initial loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    await tester.pumpAndSettle();

    // Verify UI components after data hydration
    expect(find.text('OPERATIONAL COMMAND'), findsOneWidget);
    expect(find.text('FOCUS SCORE'), findsOneWidget);
    expect(find.text('87%'), findsOneWidget);
    expect(find.text('Test Goal'), findsOneWidget);
  });
}
