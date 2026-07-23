import '../engine/feature_interfaces.dart';
import '../engine/scoring_models.dart';

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
  const KnightContext({
    required this.registeredModules,
    required this.currentScores,
    required this.analyticsSummary,
    required this.recommendationSummary,
    required this.recentActivity,
    required this.searchSummary,
    required this.moduleHealth,
    required this.lastSyncTime,
    required this.healthStatus,
    required this.dataFreshness,
    required this.applicationVersion,
    required this.fitnessSummary,
    required this.travelSummary,
    required this.workSummary,
  });

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
}
