import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../internal/utils/knight_logger.dart';
import '../internal/storage/drift/knight_database.dart';
import '../providers/database_provider.dart';
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
    KnightLogger.info('[STARTUP 12] CurrentContextNotifier.build() entry', category: KnightLogCategory.startup);
    try {
      final service = ref.watch(knightContextServiceProvider);
      
      // 1. Fetch memories
      KnightLogger.info('[STARTUP 13] Fetching memories...', category: KnightLogCategory.startup);
      final memories = await ref.watch(memoryEngineProvider).search('').timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          KnightLogger.warn('[STARTUP] Fetching memories timed out', category: KnightLogCategory.startup);
          return [];
        },
      );
      KnightLogger.info('[STARTUP 14] Memories fetched: ${memories.length}', category: KnightLogCategory.startup);
      
      // 2. Fetch world state
      KnightLogger.info('[STARTUP] Fetching world state...', category: KnightLogCategory.startup);
      final world = ref.watch(worldServiceProvider).currentState;
      KnightLogger.info('[STARTUP] World state fetched', category: KnightLogCategory.startup);

      // 3. Perform Reasoning Cycle
      KnightLogger.info('[STARTUP 15] Performing Reasoning Cycle...', category: KnightLogCategory.startup);
      final reasoning = await ref.watch(reasoningServiceProvider).performReasoningCycle(
        featureModules: [], // Future: Dynamic registration
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          KnightLogger.warn('[STARTUP] Reasoning Cycle timed out', category: KnightLogCategory.startup);
          return _emptyReasoning();
        },
      );
      KnightLogger.info('[STARTUP 16] Reasoning Cycle complete', category: KnightLogCategory.startup);

      // 4. Perform Planning Cycle
      KnightLogger.info('[STARTUP 17] Performing Planning Cycle...', category: KnightLogCategory.startup);
      final planning = await ref.watch(planningServiceProvider).generateDailyPlan(
        featureModules: [],
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          KnightLogger.warn('[STARTUP] Planning Cycle timed out', category: KnightLogCategory.startup);
          return _emptyPlanning(reasoning);
        },
      );
      KnightLogger.info('[STARTUP 18] Planning Cycle complete', category: KnightLogCategory.startup);

      // 5. Fetch Real Metrics for V4 Dashboard
      final db = ref.watch(knightDatabaseProvider);
      final totalBalance = await db.financialDao.getTotalBalance();
      
      final latestSteps = await db.healthDao.getLatestMetrics('STEPS', limit: 1);
      int steps = 0;
      if (latestSteps.isNotEmpty) {
        steps = (await db.healthDao.getDailyTotal('STEPS', latestSteps.first.startTime)).toInt();
      }
      KnightLogger.info('[CONTEXT] Steps fetched: $steps');

      final latestWater = await db.healthDao.getLatestMetrics('WATER', limit: 1);
      double water = 0.0;
      if (latestWater.isNotEmpty) {
        water = await db.healthDao.getDailyTotal('WATER', latestWater.first.startTime);
      }

      final latestCalories = await db.healthDao.getLatestMetrics('CALORIES', limit: 1);
      int calories = 0;
      if (latestCalories.isNotEmpty) {
        calories = (await db.healthDao.getDailyTotal('CALORIES', latestCalories.first.startTime)).toInt();
      }

      final latestActiveMins = await db.healthDao.getLatestMetrics('ACTIVE_MINS', limit: 1);
      int activeMins = 0;
      if (latestActiveMins.isNotEmpty) {
        activeMins = (await db.healthDao.getDailyTotal('ACTIVE_MINS', latestActiveMins.first.startTime)).toInt();
      }
      
      final timelineEvents = await db.timelineDao.getRecentEvents(limit: 5);
      final transactions = await db.financialDao.getTransactions(limit: 10);
      final feed = await ref.read(activityFeedRepositoryProvider).getGlobalFeed();
      
      // 6. Fetch Foundation Data for Milestone 4.5
      final devices = await db.deviceDao.getAllDevices();
      final deviceHealthMap = <String, DeviceHealthData>{};
      for (final device in devices) {
        final latestHealth = await ref.read(deviceIntelligenceServiceProvider).getDeviceHistory(device.id, limit: 1);
        if (latestHealth.isNotEmpty) {
          deviceHealthMap[device.id] = latestHealth.first;
        }
      }

      final pendingReminders = (await db.reminderDao.getPendingReminders()).length;
      final activeTrips = await db.travelDao.getAllTrips(); // Simplified: All trips for now

      // 7. Calculate Health Scores with Explainability
      final healthScores = await ref.read(healthEngineProvider).calculateCurrentScores();

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
        pendingReminders: pendingReminders,
        activeTrips: activeTrips,
        healthScores: healthScores,
        activeActivity: activeActivity,
      );

      // 8. Record History via ContextEngine
      await ref.read(universalContextEngineProvider).recordHistory(context);

      KnightLogger.info('[STARTUP 19] KnightContext built successfully', category: KnightLogCategory.startup);
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
