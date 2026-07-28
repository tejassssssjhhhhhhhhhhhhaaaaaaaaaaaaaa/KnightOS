import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/platform/engine/analytics_engine.dart';
import '../../core/platform/engine/analytics_interfaces.dart';
import '../../core/platform/engine/analytics_models.dart';
import '../../core/platform/engine/feature_module.dart';
import '../../core/platform/engine/knight_engine.dart';
import '../../core/platform/engine/recommendation_engine.dart';
import '../../core/platform/engine/recommendation_models.dart';
import '../../core/platform/engine/scoring_engine.dart';
import '../../core/platform/engine/scoring_models.dart';
import '../../core/platform/engine/search_models.dart';
import '../../core/providers/storage_providers.dart';
import '../../features/fitness/data/fitness_engine_adapter.dart';
import '../../features/fitness/data/fitness_module_state.dart';
import '../../features/fitness/data/fitness_storage.dart';
import '../../features/fitness/domain/equipment_catalog.dart';
import '../../features/onboarding/domain/onboarding_profile.dart';
import '../../features/travel/data/travel_engine_adapter.dart';
import '../../features/travel/data/travel_storage.dart';
import '../../features/travel/domain/travel_place.dart';
import '../../features/work_tracker/data/work_engine_adapter.dart';
import '../../features/work_tracker/data/work_storage.dart';
import '../widgets/dashboard_section.dart';
import '../../core/intelligence/knight_context.dart';
import '../../core/router/app_routes.dart';
import '../../features/knowledge/knowledge_service.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/knight_page_scaffold.dart';
import '../widgets/quick_actions.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final FitnessStorage _fitnessStorage = FitnessStorage();
  final TravelStorage _travelStorage = TravelStorage();
  final TextEditingController _searchController = TextEditingController();

  late final KnightEngine _engine;

  late FitnessModuleState _fitnessState;
  late KnightContext _knightContext;
  UserProfile? _profile;

  bool _isLoading = true;
  bool _isRefreshing = false;
  String _searchQuery = '';
  List<KnightSearchResult> _searchResults = <KnightSearchResult>[];
  List<KnightRecommendation> _recommendations = <KnightRecommendation>[];
  List<KnightMetric> _analyticsMetrics = <KnightMetric>[];
  double _overallScore = 0.0;
  String _scoreLabel = 'Pending';
  DateTime _scoreUpdatedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeDashboard().catchError((_) {});
  }

  Future<void> _initializeDashboard({bool showLoading = true}) async {
    if (showLoading) {
      setState(() => _isLoading = true);
    } else {
      setState(() => _isRefreshing = true);
    }

    try {
      final storageEngine = ref.read(storageEngineProvider);
      final userRepository = ref.read(userRepositoryProvider);
      final profile = await userRepository.loadProfile();
      final fitnessState = await _fitnessStorage.loadFitnessModuleState();
      final travelState = await _travelStorage.loadTravelModuleState();
      final workState = await WorkStorage(
        engine: storageEngine,
      ).loadWorkModuleState();

      final fitnessModule = FitnessFeatureModule(
        fitnessState: fitnessState,
        catalog: FitnessEquipmentCatalog.items,
      );
      final travelModule = TravelFeatureModule(state: travelState);
      final workModule = WorkFeatureModule(state: workState);

      final engine = KnightEngine();
      await engine.registerFeatureModule(fitnessModule);
      await engine.registerFeatureModule(travelModule);
      await engine.registerFeatureModule(workModule);

      final scoringEngine = PlatformScoringEngine();
      scoringEngine.registerProvider(fitnessModule.scoreProvider!);
      scoringEngine.registerProvider(travelModule.scoreProvider!);
      scoringEngine.registerProvider(workModule.scoreProvider!);

      final analyticsEngine = AnalyticsEngine();
      analyticsEngine.registerProvider(fitnessModule.analyticsProvider!);
      analyticsEngine.registerProvider(travelModule.analyticsProvider!);
      analyticsEngine.registerProvider(workModule.analyticsProvider!);

      final recommendationEngine = PlatformRecommendationEngine();
      recommendationEngine.registerProvider(
        fitnessModule.recommendationProvider!,
      );
      recommendationEngine.registerProvider(
        travelModule.recommendationProvider!,
      );
      recommendationEngine.registerProvider(workModule.recommendationProvider!);

      final scores = await _requestScores(scoringEngine);
      final analyticsSnapshots = await _requestAnalyticsSnapshots(
        analyticsEngine,
      );
      final recommendations = await _requestRecommendations(
        recommendationEngine,
        scores,
        analyticsSnapshots,
      );
      final metrics = await _requestMetrics(analyticsEngine);

      final knightContextService = KnightContextService();
      final knightContext = knightContextService.buildContext(
        featureModules: <KnightFeatureModule>[
          fitnessModule,
          travelModule,
          workModule,
        ],
        currentScores: scores,
        currentRecommendations: recommendations,
        recentActivity: const <String>['Dashboard loaded'],
        lastSyncTime: DateTime.now(),
        applicationVersion: '0.1.0',
        fitnessSummary: KnightFitnessSummary(
          gymProfileExists: fitnessState.gymProfile.name.isNotEmpty,
          equipmentCount: fitnessState.availableEquipmentIds.length,
          capabilityPlaceholder:
              'Fitness readiness will update as you log more sessions',
          workoutPlaceholder: 'No workout data yet',
        ),
        travelSummary: KnightTravelSummary(
          visited: travelState.places
              .where((place) => place.status == TravelPlaceStatus.visited)
              .length,
          wishlist: travelState.places
              .where((place) => place.status == TravelPlaceStatus.wishlist)
              .length,
          planned: travelState.plannedTrips.length,
          favoritePlaces: travelState.places
              .where((place) => place.isFavorite)
              .length,
          upcomingTripsPlaceholder: 'No travel plans yet',
        ),
        workSummary: const KnightWorkSummary(
          currentShiftPlaceholder: 'No work session logged yet',
          questions: 0,
          calls: 0,
          chats: 0,
          dailyTarget: 0,
          productivityPlaceholder:
              'Work insights will appear after your first session',
        ),
      );

      if (!mounted) return;
      setState(() {
        _profile = profile;
        _fitnessState = fitnessState;
        _engine = engine;
        _recommendations = recommendations;
        _analyticsMetrics = metrics;
        _knightContext = knightContext;
        _overallScore = _buildOverallScore(scores);
        _scoreLabel = scores.isEmpty ? 'Pending' : scores.first.grade.label;
        _scoreUpdatedAt = scores.isEmpty
            ? DateTime.now()
            : _latestTimestamp(scores);
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<List<KnightScoreValue>> _requestScores(
    PlatformScoringEngine scoringEngine,
  ) async {
    if (scoringEngine.providers.isEmpty) {
      return <KnightScoreValue>[];
    }
    return Future.wait(
      scoringEngine.providers.map((provider) => provider.requestScore()),
    );
  }

  Future<List<KnightAnalyticsSnapshot>> _requestAnalyticsSnapshots(
    AnalyticsEngine analyticsEngine,
  ) async {
    if (analyticsEngine.providers.isEmpty) {
      return <KnightAnalyticsSnapshot>[];
    }
    return Future.wait(analyticsEngine.providers.map(_buildAnalyticsSnapshot));
  }

  Future<KnightAnalyticsSnapshot> _buildAnalyticsSnapshot(
    KnightAnalyticsProvider provider,
  ) async {
    final metrics = await provider.requestMetrics();
    return KnightAnalyticsSnapshot(
      moduleId: provider.moduleId,
      timeRange: KnightAnalyticsTimeRange.weekly,
      metrics: metrics,
      trend: const KnightTrend(
        direction: KnightAnalyticsTrendDirection.stable,
        slope: 0.0,
        confidence: 0.0,
        period: KnightAnalyticsTimeRange.weekly,
      ),
      average: metrics.isEmpty
          ? 0.0
          : metrics.map((metric) => metric.value).reduce((a, b) => a + b) /
                metrics.length,
      summary: 'Current module analytics snapshot',
      timestamp: DateTime.now(),
    );
  }

  Future<List<KnightRecommendation>> _requestRecommendations(
    PlatformRecommendationEngine recommendationEngine,
    List<KnightScoreValue> scores,
    List<KnightAnalyticsSnapshot> analyticsSnapshots,
  ) async {
    final results = <KnightRecommendation>[];
    for (final provider in recommendationEngine.providers) {
      results.addAll(
        await provider.requestRecommendations(
          scores: scores,
          analytics: analyticsSnapshots,
        ),
      );
    }
    return results;
  }

  Future<List<KnightMetric>> _requestMetrics(
    AnalyticsEngine analyticsEngine,
  ) async {
    final results = <KnightMetric>[];
    for (final provider in analyticsEngine.providers) {
      results.addAll(await provider.requestMetrics());
    }
    return results;
  }

  double _buildOverallScore(List<KnightScoreValue> scores) {
    if (scores.isEmpty) {
      return 0.0;
    }
    return scores.map((score) => score.value).reduce((a, b) => a + b) /
        scores.length;
  }

  DateTime _latestTimestamp(List<KnightScoreValue> scores) {
    return scores.fold<DateTime>(DateTime.fromMillisecondsSinceEpoch(0), (
      previous,
      current,
    ) {
      return previous.isAfter(current.timestamp) ? previous : current.timestamp;
    });
  }

  Future<void> _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _searchQuery = '';
        _searchResults = <KnightSearchResult>[];
      });
      return;
    }

    final searchPages = await Future.wait(
      _engine.featureModules
          .where((module) => module.searchProvider != null)
          .map(
            (module) => module.searchProvider!.search(
              KnightSearchQuery(
                moduleId: module.id,
                text: trimmed,
                pageSize: 20,
              ),
            ),
          ),
    );

    setState(() {
      _searchQuery = trimmed;
      _searchResults = searchPages.expand((page) => page.items).toList();
    });
  }

  Future<void> _refreshDashboard() async {
    if (_isRefreshing) return;
    await _initializeDashboard(showLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const KnightPageScaffold(
        title: 'Dashboard',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return KnightPageScaffold(
      title: 'Dashboard',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _buildSearchBar(context)),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _isRefreshing ? null : _refreshDashboard,
                  icon: _isRefreshing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh dashboard',
                ),
                const SizedBox(width: 8),
                FloatingActionButton.extended(
                  onPressed: () => context.push(AppRoutes.voiceCapture),
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text('Voice'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLearningMentorCard(context),
            const SizedBox(height: 24),
            _buildCompanionWorkspace(context),
            const SizedBox(height: 24),
            _buildHeroScoreCard(context),
            const SizedBox(height: 24),
            _buildSummaryCards(context),
            const SizedBox(height: 24),
            _buildRecommendationsSection(context),
            const SizedBox(height: 24),
            _buildAnalyticsSection(context),
            const SizedBox(height: 24),
            _buildQuickActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Global search',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search fitness, travel, and recommendations',
            prefixIcon: const Icon(Icons.search_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
          ),
          onChanged: _performSearch,
        ),
        if (_searchQuery.isNotEmpty) ...[
          const SizedBox(height: 12),
          DashboardSection(
            title: 'Search results',
            subtitle: 'Powered by Knight engine search providers.',
            child: _searchResults.isEmpty
                ? Text(
                    'No results found for "$_searchQuery".',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _searchResults
                        .map(
                          (result) => Chip(
                            label: Text(result.title),
                            avatar: CircleAvatar(
                              child: Text(
                                result.moduleId.substring(0, 1).toUpperCase(),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ],
    );
  }

  Widget _buildLearningMentorCard(BuildContext context) {
    final mentorPlan = const KnowledgeService().buildMentorPlan(
      _profile ?? UserProfile(completedSteps: const []),
    );

    return DashboardSection(
      title: 'Learning mentor',
      subtitle:
          'A lightweight coaching loop built from your profile and daily rhythm.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your mentor is preparing a focused plan from your current goals.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ...mentorPlan.map(
            (insight) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insight.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Next action: capture a voice note or add a reflection so Knight can tailor your next recommendation.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanionWorkspace(BuildContext context) {
    return DashboardSection(
      title: 'Trusted companion',
      subtitle:
          'Talk, reflect, or save a private note. Knight will ask before remembering anything.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Use this space for journaling, emotional reflection, or quick thoughts that should stay user-controlled.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.voiceCapture),
                icon: const Icon(Icons.mic_rounded),
                label: const Text('Voice note'),
              ),
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.learning),
                icon: const Icon(Icons.school_rounded),
                label: const Text('Learning'),
              ),
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.memory),
                icon: const Icon(Icons.memory_rounded),
                label: const Text('Memory'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroScoreCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Knight hub',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Central insights from fitness and travel engines.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_overallScore.round()}/100',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 16),
              Text(_scoreLabel, style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInfoChip(
                context,
                'Modules',
                '${_knightContext.registeredModules.length}',
              ),
              _buildInfoChip(
                context,
                'Recommendations',
                '${_knightContext.recommendationSummary.recommendationCount}',
              ),
              _buildInfoChip(
                context,
                'Updated',
                _formatDateTime(_scoreUpdatedAt),
              ),
              _buildInfoChip(context, 'Context', 'Knight Intelligence Hub'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return DashboardSection(
      title: 'Summary',
      subtitle: 'Current module state and travel planning overview.',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Gym profile',
              value: _knightContext.fitnessSummary.gymProfileExists
                  ? _fitnessState.gymProfile.name
                  : 'Not configured',
              icon: Icons.fitness_center_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Equipment selected',
              value: '${_knightContext.fitnessSummary.equipmentCount}',
              icon: Icons.sports_gymnastics_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Visited places',
              value: '${_knightContext.travelSummary.visited}',
              icon: Icons.travel_explore_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Wishlist count',
              value: '${_knightContext.travelSummary.wishlist}',
              icon: Icons.favorite_border,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Planned trips',
              value: '${_knightContext.travelSummary.planned}',
              icon: Icons.event_available_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(BuildContext context) {
    return DashboardSection(
      title: 'Recommendations',
      subtitle: 'Guidance surfaced by the engine platform.',
      child: _recommendations.isEmpty
          ? Text(
              'No recommendations are available right now.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _recommendations.take(4).map((recommendation) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        recommendation.category.name
                            .substring(0, 1)
                            .toUpperCase(),
                      ),
                    ),
                    title: Text(recommendation.title),
                    subtitle: Text(recommendation.description),
                    trailing: Text(recommendation.priority.name.toUpperCase()),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return DashboardSection(
      title: 'Analytics',
      subtitle: 'Metric snapshots from the fitness and travel modules.',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Metric count',
              value: '${_analyticsMetrics.length}',
              icon: Icons.show_chart_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Top metric',
              value: _analyticsMetrics.isNotEmpty
                  ? _analyticsMetrics.first.name
                  : 'None yet',
              icon: Icons.insights_outlined,
            ),
          ),
          SizedBox(
            width: 260,
            child: DashboardStatCard(
              label: 'Data sources',
              value: '${_engine.featureModules.length}',
              icon: Icons.layers_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return DashboardSection(
      title: 'Quick actions',
      subtitle: 'Jump to your next workflow.',
      child: const QuickActions(),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} • ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
