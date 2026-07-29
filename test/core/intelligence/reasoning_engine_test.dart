import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/reasoning_engine.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/platform/engine/recommendation_models.dart';

void main() {
  late ReasoningEngine engine;

  setUp(() {
    engine = const ReasoningEngine();
  });

  group('ReasoningEngine', () {
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

    test('generates situational summary correctly', () {
      final result = engine.reason(context: mockContext, memories: []);
      expect(result.summary, contains('Morning'));
      expect(result.summary, contains('nominal'));
    });

    test('triggers sleep recovery recommendation on sleep debt', () {
      final debtContext = mockContext.copyWith(sleepStatus: 'Sleep debt detected');
      final result = engine.reason(context: debtContext, memories: []);
      
      expect(result.warnings, anyElement(contains('fatigue')));
      expect(result.recommendations.any((r) => r.category == KnightRecommendationCategory.sleep), isTrue);
    });

    test('detects mission focus insight when active missions exist', () {
      final missionMemory = KnightMemory.create(
        memoryId: 'mission-1',
        category: BookCategory.ambitions,
        domain: MemoryDomain.ambitions,
        source: MemorySource.manual,
        content: {'missionDataType': 'mission'},
        summary: 'Build KnightOS',
      );

      final result = engine.reason(context: mockContext, memories: [missionMemory]);
      
      expect(result.insights.any((i) => i.id == 'insight-mission-focus'), isTrue);
      expect(result.insights.first.description, contains('Build KnightOS'));
    });

    test('identifies outdoor opportunity on clear weather', () {
      final clearContext = mockContext.copyWith(weather: 'Sunny and clear');
      final result = engine.reason(context: clearContext, memories: []);
      
      expect(result.opportunities, anyElement(contains('outdoor')));
    });
  });
}

extension on KnightContext {
  KnightContext copyWith({
    String? sleepStatus,
    String? weather,
  }) {
    return KnightContext(
      registeredModules: registeredModules,
      currentScores: currentScores,
      analyticsSummary: analyticsSummary,
      recommendationSummary: recommendationSummary,
      recentActivity: recentActivity,
      searchSummary: searchSummary,
      moduleHealth: moduleHealth,
      lastSyncTime: lastSyncTime,
      healthStatus: healthStatus,
      dataFreshness: dataFreshness,
      applicationVersion: applicationVersion,
      fitnessSummary: fitnessSummary,
      travelSummary: travelSummary,
      workSummary: workSummary,
      timestamp: timestamp,
      greeting: greeting,
      sleepStatus: sleepStatus ?? this.sleepStatus,
      upcomingEvents: upcomingEvents,
      currentGoals: currentGoals,
      healthSummary: healthSummary,
      weather: weather ?? this.weather,
    );
  }
}
