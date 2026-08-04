import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/notification_engine.dart';
import 'package:knight_os/core/intelligence/domain/notification_models.dart';
import 'package:knight_os/core/intelligence/domain/reasoning_models.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/platform/engine/recommendation_models.dart';

void main() {
  late NotificationEngine engine;

  setUp(() {
    engine = NotificationEngine(bus: IntelligenceBus());
  });

  group('Intelligent Notification Engine (Sprint 1.8)', () {
    final mockReasoning = ReasoningResult(
      summary: '', insights: [], 
      recommendations: [
        KnightRecommendation(
          id: 'rec-1',
          title: 'High Priority',
          description: 'Desc',
          category: KnightRecommendationCategory.health,
          priority: KnightRecommendationPriority.high,
          confidence: const KnightRecommendationConfidence(value: 1.0),
          reason: KnightRecommendationReason(summary: ''),
          source: const KnightRecommendationSource(name: ''),
          action: const KnightRecommendationAction(label: ''),
          timestamp: DateTime.now(),
        ),
      ],
      warnings: [], opportunities: [],
      trace: const ReasoningTrace(intent: KnightIntent.analysis, memoriesUsed: [], rulesApplied: [], goalsConsidered: [], thoughtChain: [], confidence: 1.0),
    );

    final mockContext = _getMockContext();

    test('generates notification for high priority recommendations', () {
      final notifs = engine.evaluateReasoning(mockReasoning, mockContext);
      
      expect(notifs, hasLength(1));
      expect(notifs.first.priority, NotificationPriority.high);
    });

    test('mutes non-critical notifications during working activity', () {
      final workContext = mockContext.copyWith(
        workSummary: const KnightWorkSummary(
          currentShiftPlaceholder: 'Working',
          questions: 0,
          calls: 0,
          chats: 0,
          dailyTarget: 0,
          productivityPlaceholder: 'Focus Mode Active',
        ),
      );
      
      final notifs = engine.evaluateReasoning(mockReasoning, workContext);
      
      expect(notifs, isEmpty); // High is muted, only Critical would pass
    });
  });
}

KnightContext _getMockContext() {
  return KnightContext(
      registeredModules: [],
      currentScores: [],
      analyticsSummary: const KnightAnalyticsSummary(analyticsProviderCount: 0, snapshotsPlaceholder: '', weeklySummaryPlaceholder: '', monthlySummaryPlaceholder: ''),
      recommendationSummary: const KnightRecommendationSummary(recommendationProviderCount: 0, recommendationCount: 0, topRecommendationPlaceholder: ''),
      recentActivity: [],
      searchSummary: const KnightSearchSummary(searchProviderCount: 0, indexedModules: 0, lastSearchPlaceholder: ''),
      moduleHealth: [],
      lastSyncTime: DateTime.now(),
      healthStatus: 'Optimal',
      dataFreshness: 'Live',
      applicationVersion: '1.0.0',
      fitnessSummary: const KnightFitnessSummary(gymProfileExists: false, equipmentCount: 0, capabilityPlaceholder: '', workoutPlaceholder: ''),
      travelSummary: const KnightTravelSummary(visited: 0, wishlist: 0, planned: 0, favoritePlaces: 0, upcomingTripsPlaceholder: ''),
      workSummary: const KnightWorkSummary(currentShiftPlaceholder: '', questions: 0, calls: 0, chats: 0, dailyTarget: 0, productivityPlaceholder: ''),
      timestamp: DateTime.now(),
      greeting: 'Morning',
      sleepStatus: 'Optimal',
      upcomingEvents: [],
      currentGoals: [],
      healthSummary: '',
      weather: '',
    );
}
