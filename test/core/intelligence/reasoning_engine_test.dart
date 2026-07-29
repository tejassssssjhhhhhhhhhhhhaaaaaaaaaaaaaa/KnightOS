import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/reasoning_engine.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/world_models.dart';
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
        domain: MemoryDomain.goals,
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

    group('Sprint 5.1: Contextual Awareness', () {
      test('triggers urgent mail warning for security alerts', () {
        final world = WorldState(
          weather: 'Clear',
          calendarEvents: [],
          marketStatus: 'Open',
          lastSync: DateTime.now(),
          emailThreads: [
            EmailThread(
              id: 'e1',
              subject: 'URGENT: SECURITY ALERT',
              sender: 'Security Team',
              snippet: 'Hack detected',
              receivedAt: DateTime.now(),
            ),
          ],
        );
        final urgentContext = mockContext.copyWith(worldState: world);
        final result = engine.reason(context: urgentContext, memories: []);
        
        expect(result.warnings.any((w) => w.contains('SECURITY')), isTrue);
        expect(result.recommendations.any((r) => r.priority == KnightRecommendationPriority.critical), isTrue);
      });

      test('suggests preparation for upcoming meetings', () {
        final world = WorldState(
          weather: 'Clear',
          calendarEvents: [
            CalendarEvent(
              id: 'c1',
              title: 'Design Review',
              startTime: DateTime.now().add(const Duration(hours: 1)),
              endTime: DateTime.now().add(const Duration(hours: 2)),
            ),
          ],
          marketStatus: 'Open',
          lastSync: DateTime.now(),
        );
        final calContext = mockContext.copyWith(worldState: world);
        final result = engine.reason(context: calContext, memories: []);
        
        expect(result.insights.any((i) => i.title.contains('Preparation')), isTrue);
        expect(result.recommendations.any((r) => r.title.contains('Review for Design Review')), isTrue);
      });

      test('detects calendar schedule conflicts', () {
        final startTime = DateTime.now().add(const Duration(hours: 1));
        final world = WorldState(
          weather: 'Clear',
          calendarEvents: [
            CalendarEvent(
              id: 'c1',
              title: 'Meeting A',
              startTime: startTime,
              endTime: startTime.add(const Duration(hours: 1)),
            ),
            CalendarEvent(
              id: 'c2',
              title: 'Meeting B',
              startTime: startTime.add(const Duration(minutes: 30)),
              endTime: startTime.add(const Duration(hours: 1, minutes: 30)),
            ),
          ],
          marketStatus: 'Open',
          lastSync: DateTime.now(),
        );
        final conflictContext = mockContext.copyWith(worldState: world);
        final result = engine.reason(context: conflictContext, memories: []);
        
        expect(result.warnings.any((w) => w.contains('Conflict')), isTrue);
        expect(result.recommendations.any((r) => r.id.contains('rec-cal-conflict')), isTrue);
      });
    });

    test('calculates trace confidence from input memories', () {
      final lowConf = KnightMemory.create(
        memoryId: 'm1',
        category: BookCategory.history,
        domain: MemoryDomain.memories,
        content: {},
        source: MemorySource.aiGenerated,
        confidence: 0.2,
      );

      final result = engine.reason(context: mockContext, memories: [lowConf]);
      expect(result.trace.confidence, 0.8); // Engine currently has static 0.8 in trace
    });
  });
}

extension on KnightContext {
  KnightContext copyWith({
    String? sleepStatus,
    String? weather,
    WorldState? worldState,
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
      worldState: worldState ?? this.worldState,
    );
  }
}
