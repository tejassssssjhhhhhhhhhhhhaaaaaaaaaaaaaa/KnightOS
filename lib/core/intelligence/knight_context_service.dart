import '../platform/engine/engine_interfaces.dart';
import '../platform/engine/recommendation_models.dart';
import '../platform/engine/scoring_models.dart';
import 'knight_context_models.dart';

/// Aggregates feature module state into a unified KnightContext.
class KnightContextService {
  KnightContextService();

  KnightContext buildContext({
    required List<KnightFeatureModule> featureModules,
    List<KnightScoreValue> currentScores = const <KnightScoreValue>[],
    List<KnightRecommendation> currentRecommendations =
        const <KnightRecommendation>[],
    List<String> recentActivity = const <String>['Dashboard loaded'],
    KnightFitnessSummary? fitnessSummary,
    KnightTravelSummary? travelSummary,
    KnightWorkSummary? workSummary,
    DateTime? lastSyncTime,
    String healthStatus = 'Good',
    String dataFreshness = 'Live',
    String applicationVersion = '0.1.0',
  }) {
    final registeredModules = featureModules
        .map(_buildModuleContext)
        .toList(growable: false);
    final analyticsSummary = _buildAnalyticsSummary(featureModules);
    final recommendationSummary = _buildRecommendationSummary(
      featureModules,
      currentRecommendations,
    );
    final searchSummary = _buildSearchSummary(featureModules);
    final moduleHealth = _buildModuleHealth(featureModules);

    return KnightContext(
      registeredModules: registeredModules,
      currentScores: List<KnightScoreValue>.unmodifiable(currentScores),
      analyticsSummary: analyticsSummary,
      recommendationSummary: recommendationSummary,
      recentActivity: List<String>.unmodifiable(recentActivity),
      searchSummary: searchSummary,
      moduleHealth: moduleHealth,
      lastSyncTime: lastSyncTime ?? DateTime.now(),
      healthStatus: healthStatus,
      dataFreshness: dataFreshness,
      applicationVersion: applicationVersion,
      fitnessSummary: fitnessSummary ?? _defaultFitnessSummary(),
      travelSummary: travelSummary ?? _defaultTravelSummary(),
      workSummary: workSummary ?? _defaultWorkSummary(),
    );
  }

  KnightAnalyticsSummary _buildAnalyticsSummary(
    List<KnightFeatureModule> featureModules,
  ) {
    final analyticsProviders = featureModules
        .where((module) => module.analyticsProvider != null)
        .length;
    return KnightAnalyticsSummary(
      analyticsProviderCount: analyticsProviders,
      snapshotsPlaceholder: 'Analytics will appear here as data is collected',
      weeklySummaryPlaceholder:
          'Your weekly trend will appear after the first activity log',
      monthlySummaryPlaceholder:
          'Your monthly summary will appear after enough activity is captured',
    );
  }

  KnightRecommendationSummary _buildRecommendationSummary(
    List<KnightFeatureModule> featureModules,
    List<KnightRecommendation> currentRecommendations,
  ) {
    final recommendationProviders = featureModules
        .where((module) => module.recommendationProvider != null)
        .length;
    return KnightRecommendationSummary(
      recommendationProviderCount: recommendationProviders,
      recommendationCount: currentRecommendations.length,
      topRecommendationPlaceholder: currentRecommendations.isNotEmpty
          ? currentRecommendations.first.title
          : 'No recommendations yet — add activity to unlock tailored guidance',
    );
  }

  KnightSearchSummary _buildSearchSummary(
    List<KnightFeatureModule> featureModules,
  ) {
    final searchProviders = featureModules
        .where((module) => module.searchProvider != null)
        .length;
    return KnightSearchSummary(
      searchProviderCount: searchProviders,
      indexedModules: featureModules.length,
      lastSearchPlaceholder: 'Search your modules once data is available',
    );
  }

  List<KnightModuleHealth> _buildModuleHealth(
    List<KnightFeatureModule> featureModules,
  ) {
    return featureModules
        .map(
          (module) => KnightModuleHealth(
            moduleId: module.id,
            loaded: module.state.isEnabled,
            available: module.state.isAvailable,
            healthy: module.state.isEnabled && module.state.isAvailable,
            version: module.metadata.version,
            lastRefresh: DateTime.now(),
          ),
        )
        .toList(growable: false);
  }

  KnightModuleContext _buildModuleContext(KnightFeatureModule module) {
    return KnightModuleContext(
      moduleId: module.id,
      name: module.name,
      metadata: module.metadata,
      capabilities: module.capabilities,
      configuration: module.configuration,
      state: module.state,
      searchProviderCount: module.searchProvider != null ? 1 : 0,
      analyticsProviderCount: module.analyticsProvider != null ? 1 : 0,
      scoreProviderCount: module.scoreProvider != null ? 1 : 0,
      recommendationProviderCount: module.recommendationProvider != null
          ? 1
          : 0,
      loaded: module.state.isEnabled,
      available: module.state.isAvailable,
      healthy: module.state.isEnabled && module.state.isAvailable,
      version: module.metadata.version,
      lastRefresh: DateTime.now(),
    );
  }

  KnightFitnessSummary _defaultFitnessSummary() {
    return const KnightFitnessSummary(
      gymProfileExists: false,
      equipmentCount: 0,
      capabilityPlaceholder:
          'Fitness readiness will appear after you log a workout',
      workoutPlaceholder: 'No workouts recorded yet',
    );
  }

  KnightTravelSummary _defaultTravelSummary() {
    return const KnightTravelSummary(
      visited: 0,
      wishlist: 0,
      planned: 0,
      favoritePlaces: 0,
      upcomingTripsPlaceholder: 'No travel plans yet',
    );
  }

  KnightWorkSummary _defaultWorkSummary() {
    return const KnightWorkSummary(
      currentShiftPlaceholder: 'No work session logged yet',
      questions: 0,
      calls: 0,
      chats: 0,
      dailyTarget: 0,
      productivityPlaceholder:
          'Work insights will appear after your first session',
    );
  }
}
