import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../internal/utils/knight_logger.dart';
import '../internal/storage/drift/knight_database.dart';
import '../providers/database_provider.dart';
import 'domain/activity_feed_models.dart';
import 'domain/health_models.dart';
import 'domain/cognitive_models.dart';
import 'domain/mission_models.dart';
import 'domain/planning_models.dart';
import 'domain/reasoning_models.dart';
import 'knight_context_models.dart';
import 'knight_context_service.dart';
import 'providers/intelligence_providers.dart';
import 'services/context_engine.dart';
import 'services/device_intelligence_service.dart';
import 'engines/health/health_engine.dart';

final knightContextServiceProvider = Provider<KnightContextService>((ref) {
  return KnightContextService();
});

/// Reactive notifier that provides the hydrated situational context of the user.
final currentContextNotifierProvider =
    AsyncNotifierProvider<CurrentContextNotifier, KnightContext>(
  CurrentContextNotifier.new,
);

class CurrentContextNotifier extends AsyncNotifier<KnightContext> {
  @override
  Future<KnightContext> build() async {
    final stopwatch = Stopwatch()..start();
    KnightLogger.info('[STARTUP 12] CurrentContextNotifier.build() entry', category: KnightLogCategory.startup);
    try {
      final service = ref.watch(knightContextServiceProvider);
      
      // 1. Fetch memories (Centralized once to avoid redundant N+1 DB calls)
      KnightLogger.info('[STARTUP 13] Fetching memories...', category: KnightLogCategory.startup);
      final memories = await ref.watch(memoryEngineProvider).search('').timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          KnightLogger.warn('[STARTUP] Fetching memories timed out', category: KnightLogCategory.startup);
          return [];
        },
      );
      KnightLogger.info('[STARTUP 14] Memories fetched: ${memories.length} in ${stopwatch.elapsedMilliseconds}ms', category: KnightLogCategory.startup);
      
      // 2. Fetch world state
      final world = ref.watch(worldServiceProvider).currentState;
      KnightLogger.info('[STARTUP] World state fetched at ${stopwatch.elapsedMilliseconds}ms', category: KnightLogCategory.startup);

      // 3. Perform Reasoning Cycle (Optimized: Using pre-fetched memories)
      final reasoning = await ref.watch(reasoningServiceProvider).performReasoningCycle(
        featureModules: [], 
        preFetchedMemories: memories,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          KnightLogger.warn('[STARTUP] Reasoning Cycle timed out', category: KnightLogCategory.startup);
          return _emptyReasoning();
        },
      );
      KnightLogger.info('[STARTUP 16] Reasoning Cycle complete at ${stopwatch.elapsedMilliseconds}ms', category: KnightLogCategory.startup);

      // 4. Perform Planning Cycle (Optimized: Using pre-fetched data)
      final planning = await ref.watch(planningServiceProvider).generateDailyPlan(
        featureModules: [],
        preCalculatedReasoning: reasoning,
        preFetchedMemories: memories,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          KnightLogger.warn('[STARTUP] Planning Cycle timed out', category: KnightLogCategory.startup);
          return _emptyPlanning(reasoning);
        },
      );
      KnightLogger.info('[STARTUP 18] Planning Cycle complete at ${stopwatch.elapsedMilliseconds}ms', category: KnightLogCategory.startup);

      // 5. Fetch Real Metrics for V4 Dashboard
      final db = ref.watch(knightDatabaseProvider);
      
      final dbStart = stopwatch.elapsedMilliseconds;
      final results = await Future.wait([
        db.financialDao.getTotalBalance(),
        db.healthDao.getLatestMetrics('STEPS', limit: 1),
        db.healthDao.getLatestMetrics('WATER', limit: 1),
        db.healthDao.getLatestMetrics('CALORIES', limit: 1),
        db.healthDao.getLatestMetrics('ACTIVE_MINS', limit: 1),
        db.timelineDao.getRecentEvents(limit: 5),
        db.financialDao.getTransactions(limit: 10),
        ref.read(activityFeedRepositoryProvider).getGlobalFeed(),
        db.deviceDao.getAllDevices(),
        db.reminderDao.getPendingReminders(),
        db.travelDao.getAllTrips(),
        ref.read(healthEngineProvider).calculateCurrentScores(),
      ]);
      KnightLogger.info('[STARTUP] DB/Parallel tasks complete in ${stopwatch.elapsedMilliseconds - dbStart}ms', category: KnightLogCategory.startup);

      final totalBalance = results[0] as double;
      final latestSteps = results[1] as List<HealthMetricData>;
      final latestWater = results[2] as List<HealthMetricData>;
      final latestCalories = results[3] as List<HealthMetricData>;
      final latestActiveMins = results[4] as List<HealthMetricData>;
      final timelineEvents = results[5] as List<TimelineEventData>;
      final transactions = results[6] as List<TransactionData>;
      final feed = results[7] as List<ActivityItem>;
      final devices = results[8] as List<DeviceRegistryData>;
      final reminders = results[9] as List<ReminderData>;
      final activeTrips = results[10] as List<TripData>;
      final healthScores = results[11] as HealthScores;

      int steps = 0;
      if (latestSteps.isNotEmpty) {
        steps = (await db.healthDao.getDailyTotal('STEPS', latestSteps.first.startTime)).toInt();
      }

      double water = 0.0;
      if (latestWater.isNotEmpty) {
        water = await db.healthDao.getDailyTotal('WATER', latestWater.first.startTime);
      }

      int calories = 0;
      if (latestCalories.isNotEmpty) {
        calories = (await db.healthDao.getDailyTotal('CALORIES', latestCalories.first.startTime)).toInt();
      }

      int activeMins = 0;
      if (latestActiveMins.isNotEmpty) {
        activeMins = (await db.healthDao.getDailyTotal('ACTIVE_MINS', latestActiveMins.first.startTime)).toInt();
      }
      
      final deviceHealthMap = <String, DeviceHealthData>{};
      for (final device in devices) {
        final latestHealth = await ref.read(deviceIntelligenceServiceProvider).getDeviceHistory(device.id, limit: 1);
        if (latestHealth.isNotEmpty) {
          deviceHealthMap[device.id] = latestHealth.first;
        }
      }

      final greeting = ref.read(greetingServiceProvider).getGreeting();
      
      final activeActivity = ref.watch(perceptionEngineProvider);

      final context = service.buildContext(
        featureModules: [],
        recentMemories: memories,
        worldState: world,
        reasoning: reasoning,
        planning: planning,
        totalBalance: totalBalance,
        steps: steps,
        waterIntake: water,
        calories: calories,
        activeMinutes: activeMins,
        greeting: greeting,
        recentTimelineEvents: timelineEvents,
        recentTransactions: transactions,
        activityFeed: feed,
        deviceHealth: deviceHealthMap,
        pendingReminders: reminders.length,
        activeTrips: activeTrips,
        healthScores: healthScores,
        activeActivity: activeActivity,
      );

      // 8. Record History via ContextEngine
      await ref.read(universalContextEngineProvider).recordHistory(context);

      KnightLogger.info('[STARTUP 19] KnightContext built successfully in ${stopwatch.elapsedMilliseconds}ms', category: KnightLogCategory.startup);
      return context;
    } catch (e, s) {
      KnightLogger.error('[STARTUP ERR] CurrentContextNotifier.build failed', error: e, stackTrace: s, category: KnightLogCategory.startup);
      rethrow;
    }
  }

  /// Manually triggers a context refresh.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  ReasoningResult _emptyReasoning() {
    return ReasoningResult(
      summary: 'System nominal.',
      insights: [],
      recommendations: [],
      warnings: [],
      opportunities: [],
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: [],
        thoughtChain: ['Timeout fallback'],
        confidence: 0,
      ),
    );
  }

  PlanningResult _emptyPlanning(ReasoningResult reasoning) {
    return PlanningResult(
      dailyPlan: KnightPlan(
        id: 'daily',
        title: 'Daily Plan',
        goalId: 'none',
        tasks: [],
        status: MissionStatus.draft,
        createdAt: DateTime.now(),
      ),
      activePlans: [],
      suggestedTasks: [],
      timestamp: DateTime.now(),
      reasoningUsed: reasoning,
    );
  }
}
