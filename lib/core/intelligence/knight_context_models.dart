import 'domain/activity_feed_models.dart';
import '../internal/storage/drift/knight_database.dart';
import '../platform/engine/feature_interfaces.dart';
import '../platform/engine/scoring_models.dart';
import 'domain/knight_memory.dart';
import 'domain/reasoning_models.dart';
import 'domain/planning_models.dart';
import 'domain/world_models.dart';
import 'domain/health_models.dart';

/// Immutable context summary for an individual feature module.
class KnightModuleContext {
  const KnightModuleContext({
    required this.moduleId,
    required this.name,
    required this.metadata,
    required this.capabilities,
    required this.configuration,
    required this.state,
    required this.searchProviderCount,
    required this.analyticsProviderCount,
    required this.scoreProviderCount,
    required this.recommendationProviderCount,
    required this.loaded,
    required this.available,
    required this.healthy,
    required this.version,
    required this.lastRefresh,
  });

  final String moduleId;
  final String name;
  final KnightModuleMetadata metadata;
  final List<KnightModuleCapability> capabilities;
  final KnightModuleConfiguration configuration;
  final KnightModuleState state;
  final int searchProviderCount;
  final int analyticsProviderCount;
  final int scoreProviderCount;
  final int recommendationProviderCount;
  final bool loaded;
  final bool available;
  final bool healthy;
  final String version;
  final DateTime lastRefresh;
}

/// Fitness-specific summary exposed by Knight Context.
class KnightFitnessSummary {
  const KnightFitnessSummary({
    required this.gymProfileExists,
    required this.equipmentCount,
    required this.capabilityPlaceholder,
    required this.workoutPlaceholder,
  });

  final bool gymProfileExists;
  final int equipmentCount;
  final String capabilityPlaceholder;
  final String workoutPlaceholder;
}

/// Travel-specific summary exposed by Knight Context.
class KnightTravelSummary {
  const KnightTravelSummary({
    required this.visited,
    required this.wishlist,
    required this.planned,
    required this.favoritePlaces,
    required this.upcomingTripsPlaceholder,
  });

  final int visited;
  final int wishlist;
  final int planned;
  final int favoritePlaces;
  final String upcomingTripsPlaceholder;
}

/// Work-specific summary exposed by Knight Context.
class KnightWorkSummary {
  const KnightWorkSummary({
    required this.currentShiftPlaceholder,
    required this.questions,
    required this.calls,
    required this.chats,
    required this.dailyTarget,
    required this.productivityPlaceholder,
  });

  final String currentShiftPlaceholder;
  final int questions;
  final int calls;
  final int chats;
  final int dailyTarget;
  final String productivityPlaceholder;
}

/// Summary of the search system state in Knight Context.
class KnightSearchSummary {
  const KnightSearchSummary({
    required this.searchProviderCount,
    required this.indexedModules,
    required this.lastSearchPlaceholder,
  });

  final int searchProviderCount;
  final int indexedModules;
  final String lastSearchPlaceholder;
}

/// Summary of analytics state in Knight Context.
class KnightAnalyticsSummary {
  const KnightAnalyticsSummary({
    required this.analyticsProviderCount,
    required this.snapshotsPlaceholder,
    required this.weeklySummaryPlaceholder,
    required this.monthlySummaryPlaceholder,
  });

  final int analyticsProviderCount;
  final String snapshotsPlaceholder;
  final String weeklySummaryPlaceholder;
  final String monthlySummaryPlaceholder;
}

/// Summary of recommendation state in Knight Context.
class KnightRecommendationSummary {
  const KnightRecommendationSummary({
    required this.recommendationProviderCount,
    required this.recommendationCount,
    required this.topRecommendationPlaceholder,
  });

  final int recommendationProviderCount;
  final int recommendationCount;
  final String topRecommendationPlaceholder;
}

/// Health state for a registered module within Knight Context.
class KnightModuleHealth {
  const KnightModuleHealth({
    required this.moduleId,
    required this.loaded,
    required this.available,
    required this.healthy,
    required this.version,
    required this.lastRefresh,
  });

  final String moduleId;
  final bool loaded;
  final bool available;
  final bool healthy;
  final String version;
  final DateTime lastRefresh;
}

/// The unified Knight Context that aggregates feature module state.
class KnightContext {
  KnightContext({
    this.registeredModules = const [],
    this.currentScores = const [],
    this.analyticsSummary = const KnightAnalyticsSummary(
      analyticsProviderCount: 0,
      snapshotsPlaceholder: '',
      weeklySummaryPlaceholder: '',
      monthlySummaryPlaceholder: '',
    ),
    this.recommendationSummary = const KnightRecommendationSummary(
      recommendationProviderCount: 0,
      recommendationCount: 0,
      topRecommendationPlaceholder: '',
    ),
    this.recentActivity = const [],
    this.searchSummary = const KnightSearchSummary(
      searchProviderCount: 0,
      indexedModules: 0,
      lastSearchPlaceholder: '',
    ),
    this.moduleHealth = const [],
    DateTime? lastSyncTime,
    this.healthStatus = 'Active',
    this.dataFreshness = 'Live',
    this.applicationVersion = '4.0.0',
    this.fitnessSummary = const KnightFitnessSummary(
      gymProfileExists: false,
      equipmentCount: 0,
      capabilityPlaceholder: '',
      workoutPlaceholder: '',
    ),
    this.travelSummary = const KnightTravelSummary(
      visited: 0,
      wishlist: 0,
      planned: 0,
      favoritePlaces: 0,
      upcomingTripsPlaceholder: '',
    ),
    this.workSummary = const KnightWorkSummary(
      currentShiftPlaceholder: '',
      questions: 0,
      calls: 0,
      chats: 0,
      dailyTarget: 0,
      productivityPlaceholder: '',
    ),
    DateTime? timestamp,
    this.greeting = 'System Active',
    this.sleepStatus = 'Unknown',
    this.upcomingEvents = const [],
    this.currentGoals = const [],
    this.healthSummary = 'Nominal',
    this.weather = 'Unknown',
    this.worldState = const WorldState(
      weather: 'Unknown',
      calendarEvents: [],
      marketStatus: 'Closed',
    ),
    this.reasoning,
    this.planning,
    this.focusScore = 0.0,
    this.energyLevel = 'Stable',
    this.mood = 'Neutral',
    this.steps = 0,
    this.waterIntake = 0.0,
    this.calories = 0,
    this.totalBalance = 0.0,
    this.recentMemoriesCount = 0,
    this.activeMinutes = 0,
    this.relatedMemories = const [],
    this.recentTimelineEvents = const [],
    this.recentTransactions = const [],
    this.activityFeed = const [],
    this.deviceHealth = const {},
    this.pendingReminders = 0,
    this.contextHealthScore = 1.0,
    this.activeTrips = const [],
    this.healthScores,
    this.activeActivity = 'stationary',
  }) : lastSyncTime = lastSyncTime ?? DateTime.fromMillisecondsSinceEpoch(0),
       timestamp = timestamp ?? DateTime.now();

  KnightContext copyWith({
    List<KnightModuleContext>? registeredModules,
    List<KnightScoreValue>? currentScores,
    KnightAnalyticsSummary? analyticsSummary,
    KnightRecommendationSummary? recommendationSummary,
    List<String>? recentActivity,
    KnightSearchSummary? searchSummary,
    List<KnightModuleHealth>? moduleHealth,
    DateTime? lastSyncTime,
    String? healthStatus,
    String? dataFreshness,
    String? applicationVersion,
    KnightFitnessSummary? fitnessSummary,
    KnightTravelSummary? travelSummary,
    KnightWorkSummary? workSummary,
    DateTime? timestamp,
    String? greeting,
    String? sleepStatus,
    List<String>? upcomingEvents,
    List<String>? currentGoals,
    String? healthSummary,
    String? weather,
    WorldState? worldState,
    ReasoningResult? reasoning,
    PlanningResult? planning,
    double? focusScore,
    String? energyLevel,
    String? mood,
    int? steps,
    double? waterIntake,
    int? calories,
    int? activeMinutes,
    double? totalBalance,
    int? recentMemoriesCount,
    List<KnightMemory>? relatedMemories,
    List<TimelineEventData>? recentTimelineEvents,
    List<TransactionData>? recentTransactions,
    List<ActivityItem>? activityFeed,
    Map<String, DeviceHealthData>? deviceHealth,
    int? pendingReminders,
    double? contextHealthScore,
    List<TripData>? activeTrips,
    HealthScores? healthScores,
    String? activeActivity,
  }) {
    return KnightContext(
      registeredModules: registeredModules ?? this.registeredModules,
      currentScores: currentScores ?? this.currentScores,
      analyticsSummary: analyticsSummary ?? this.analyticsSummary,
      recommendationSummary: recommendationSummary ?? this.recommendationSummary,
      recentActivity: recentActivity ?? this.recentActivity,
      searchSummary: searchSummary ?? this.searchSummary,
      moduleHealth: moduleHealth ?? this.moduleHealth,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      healthStatus: healthStatus ?? this.healthStatus,
      dataFreshness: dataFreshness ?? this.dataFreshness,
      applicationVersion: applicationVersion ?? this.applicationVersion,
      fitnessSummary: fitnessSummary ?? this.fitnessSummary,
      travelSummary: travelSummary ?? this.travelSummary,
      workSummary: workSummary ?? this.workSummary,
      timestamp: timestamp ?? this.timestamp,
      greeting: greeting ?? this.greeting,
      sleepStatus: sleepStatus ?? this.sleepStatus,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      currentGoals: currentGoals ?? this.currentGoals,
      healthSummary: healthSummary ?? this.healthSummary,
      weather: weather ?? this.weather,
      worldState: worldState ?? this.worldState,
      reasoning: reasoning ?? this.reasoning,
      planning: planning ?? this.planning,
      focusScore: focusScore ?? this.focusScore,
      energyLevel: energyLevel ?? this.energyLevel,
      mood: mood ?? this.mood,
      steps: steps ?? this.steps,
      waterIntake: waterIntake ?? this.waterIntake,
      calories: calories ?? this.calories,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      totalBalance: totalBalance ?? this.totalBalance,
      recentMemoriesCount: recentMemoriesCount ?? this.recentMemoriesCount,
      relatedMemories: relatedMemories ?? this.relatedMemories,
      recentTimelineEvents: recentTimelineEvents ?? this.recentTimelineEvents,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      activityFeed: activityFeed ?? this.activityFeed,
      deviceHealth: deviceHealth ?? this.deviceHealth,
      pendingReminders: pendingReminders ?? this.pendingReminders,
      contextHealthScore: contextHealthScore ?? this.contextHealthScore,
      activeTrips: activeTrips ?? this.activeTrips,
      healthScores: healthScores ?? this.healthScores,
      activeActivity: activeActivity ?? this.activeActivity,
    );
  }

  final List<KnightModuleContext> registeredModules;
  final List<KnightScoreValue> currentScores;
  final KnightAnalyticsSummary analyticsSummary;
  final KnightRecommendationSummary recommendationSummary;
  final List<String> recentActivity;
  final KnightSearchSummary searchSummary;
  final List<KnightModuleHealth> moduleHealth;
  final DateTime lastSyncTime;
  final String healthStatus;
  final String dataFreshness;
  final String applicationVersion;
  final KnightFitnessSummary fitnessSummary;
  final KnightTravelSummary travelSummary;
  final KnightWorkSummary workSummary;

  final DateTime timestamp;
  final String greeting;
  final String sleepStatus;
  final List<String> upcomingEvents;
  final List<String> currentGoals;
  final String healthSummary;
  final String weather;
  final WorldState worldState;

  final ReasoningResult? reasoning;
  final PlanningResult? planning;
  final double focusScore;
  final String energyLevel;
  final String mood;
  final int steps;
  final double waterIntake;
  final int calories;
  final int activeMinutes;
  final double totalBalance;
  final int recentMemoriesCount;
  final List<KnightMemory> relatedMemories;
  final List<TimelineEventData> recentTimelineEvents;
  final List<TransactionData> recentTransactions;
  final List<ActivityItem> activityFeed;
  final Map<String, DeviceHealthData> deviceHealth;
  final int pendingReminders;
  final double contextHealthScore;
  final List<TripData> activeTrips;
  final HealthScores? healthScores;
  final String activeActivity;
}
