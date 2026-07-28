import '../../../core/platform/engine/analytics_models.dart';
import '../../../core/platform/engine/engine_interfaces.dart';
import '../../../core/platform/engine/engine_types.dart';
import '../../../core/platform/engine/feature_interfaces.dart';
import '../../../core/platform/engine/recommendation_models.dart';
import '../../../core/platform/engine/scoring_models.dart';
import '../../../core/platform/engine/search_models.dart';
import '../data/travel_module_state.dart';
import '../domain/travel_place.dart';

class TravelSearchProvider implements KnightFeatureSearchProvider {
  TravelSearchProvider({required this.state});

  final TravelModuleState state;

  @override
  String get id => 'travel.search';

  @override
  String get name => 'Travel Search';

  @override
  String get moduleId => 'travel';

  @override
  Future<KnightSearchPage> search(KnightSearchQuery query) async {
    final normalized = query.text.trim().toLowerCase();
    final filtered = state.places.where((place) {
      final searchText = [
        place.name,
        place.country,
        place.state,
        place.city,
        place.description,
      ].join(' ').toLowerCase();
      final textMatches = normalized.isEmpty || searchText.contains(normalized);
      final filterMatches = query.filters.every((filter) {
        if (filter.operator == KnightSearchFilterOperator.contains) {
          return searchText.contains(filter.value.toLowerCase());
        }
        return true;
      });
      return textMatches && filterMatches;
    }).toList();

    final items = filtered
        .map(
          (place) => KnightSearchResult(
            id: place.id,
            moduleId: moduleId,
            title: place.name,
            summary:
                '${place.city.isNotEmpty ? place.city : place.state} · ${place.status.label}',
            metadata: <String, String>{
              'country': place.country,
              'state': place.state,
              'city': place.city,
              'status': place.status.label,
            },
          ),
        )
        .toList();

    return KnightSearchPage(
      items: items,
      page: query.page,
      pageSize: query.pageSize,
      hasMore: false,
    );
  }

  @override
  Future<List<String>> suggest(KnightSearchQuery query) async {
    final normalized = query.text.trim().toLowerCase();
    if (normalized.isEmpty) {
      return <String>[];
    }
    return state.places
        .where((place) => place.name.toLowerCase().contains(normalized))
        .map((place) => place.name)
        .take(6)
        .toList();
  }
}

class TravelScoreProvider implements KnightFeatureScoreProvider {
  @override
  String get id => 'travel.score';

  @override
  String get name => 'Travel Score';

  @override
  KnightScoreCategory get category => KnightScoreCategory.custom;

  @override
  Future<KnightScoreValue> requestScore() async {
    return KnightScoreValue(
      value: 0.0,
      category: KnightScoreCategory.custom,
      grade: const KnightScoreGrade(label: 'Pending', rank: 0),
      confidence: const KnightScoreConfidence(value: 0.0),
      timestamp: DateTime.now(),
      source: const KnightScoreSource(name: 'travel'),
    );
  }
}

class TravelAnalyticsProvider implements KnightFeatureAnalyticsProvider {
  TravelAnalyticsProvider({required this.state});

  final TravelModuleState state;

  @override
  String get id => 'travel.analytics';

  @override
  String get name => 'Travel Analytics';

  @override
  String get moduleId => 'travel';

  @override
  Future<List<KnightHistoricalDataPoint>> requestHistoricalData() async {
    return <KnightHistoricalDataPoint>[];
  }

  @override
  Future<List<KnightMetric>> requestMetrics() async {
    return <KnightMetric>[
      KnightMetric(
        name: 'Countries visited',
        value: 0.0,
        timestamp: DateTime.now(),
      ),
      KnightMetric(
        name: 'States visited',
        value: 0.0,
        timestamp: DateTime.now(),
      ),
      KnightMetric(
        name: 'Cities visited',
        value: 0.0,
        timestamp: DateTime.now(),
      ),
      KnightMetric(
        name: 'Total trips',
        value: state.plannedTrips.length.toDouble(),
        timestamp: DateTime.now(),
      ),
      KnightMetric(
        name: 'Wishlist count',
        value: state.places
            .where((place) => place.status == TravelPlaceStatus.wishlist)
            .length
            .toDouble(),
        timestamp: DateTime.now(),
      ),
      KnightMetric(
        name: 'Planned trips',
        value: state.places
            .where((place) => place.status == TravelPlaceStatus.planned)
            .length
            .toDouble(),
        timestamp: DateTime.now(),
      ),
      KnightMetric(
        name: 'Travel frequency',
        value: 0.0,
        timestamp: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<KnightScoreValue>> requestScoreHistory() async {
    return <KnightScoreValue>[];
  }
}

class TravelRecommendationProvider
    implements KnightFeatureRecommendationProvider {
  @override
  String get id => 'travel.recommendation';

  @override
  String get name => 'Travel Recommendations';

  @override
  String get moduleId => 'travel';

  @override
  Future<List<KnightRecommendation>> requestRecommendations({
    required List<KnightScoreValue> scores,
    required List<KnightAnalyticsSnapshot> analytics,
  }) async {
    return <KnightRecommendation>[
      KnightRecommendation(
        id: 'travel-next-step',
        title: 'Plan a next getaway',
        description:
            'Use the travel workspace to capture wishlist places and future trips.',
        category: KnightRecommendationCategory.travel,
        priority: KnightRecommendationPriority.medium,
        confidence: const KnightRecommendationConfidence(value: 0.6),
        reason: const KnightRecommendationReason(
          summary: 'A place is waiting to be visited.',
        ),
        source: const KnightRecommendationSource(name: 'travel'),
        action: const KnightRecommendationAction(
          label: 'Review upcoming places',
        ),
        timestamp: DateTime.now(),
      ),
    ];
  }
}

class TravelFeatureModule implements KnightFeatureModule {
  TravelFeatureModule({required this._state})
    : metadata = const KnightModuleMetadata(
        id: 'travel',
        name: 'Travel',
        description:
            'Travel planning and place tracking for the KnightOS engine platform.',
        version: '0.1.0',
        category: 'travel',
        tags: <String>['travel', 'places', 'trip-planning'],
      ),
      capabilities = const <KnightModuleCapability>[
        KnightModuleCapability(
          id: 'search',
          name: 'Search',
          description: 'Search places by country, state, city or landmark.',
        ),
        KnightModuleCapability(
          id: 'analytics',
          name: 'Analytics',
          description: 'Expose travel statistics placeholders.',
        ),
        KnightModuleCapability(
          id: 'scoring',
          name: 'Scoring',
          description: 'Expose travel scoring placeholders.',
        ),
        KnightModuleCapability(
          id: 'recommendations',
          name: 'Recommendations',
          description: 'Expose travel recommendation placeholders.',
        ),
      ],
      configuration = const KnightModuleConfiguration(
        moduleId: 'travel',
        enabled: true,
        offlineEnabled: true,
        aiAssistedEnabled: false,
        searchEnabled: true,
      ),
      state = const KnightModuleState(
        moduleId: 'travel',
        isEnabled: true,
        isAvailable: true,
        isOnline: true,
        isOfflineCapable: true,
        isAiCapable: false,
      ) {
    searchProvider = TravelSearchProvider(state: _state);
    analyticsProvider = TravelAnalyticsProvider(state: _state);
    scoreProvider = TravelScoreProvider();
    recommendationProvider = TravelRecommendationProvider();
  }

  final TravelModuleState _state;

  @override
  final KnightModuleMetadata metadata;

  @override
  final List<KnightModuleCapability> capabilities;

  @override
  final KnightModuleConfiguration configuration;

  @override
  final KnightModuleState state;

  @override
  late final KnightFeatureScoreProvider? scoreProvider;

  @override
  late final KnightFeatureAnalyticsProvider? analyticsProvider;

  @override
  late final KnightFeatureRecommendationProvider? recommendationProvider;

  @override
  late final KnightFeatureSearchProvider? searchProvider;

  @override
  KnightHistoryProvider? get historyProvider => null;

  @override
  KnightSettingsProvider? get settingsProvider => null;

  @override
  String get id => metadata.id;

  @override
  String get name => metadata.name;

  KnightModuleLifecycleState _lifecycleState =
      KnightModuleLifecycleState.bootstrapping;

  @override
  KnightModuleLifecycleState get lifecycleState => _lifecycleState;

  @override
  Future<void> initialize() async {
    _lifecycleState = KnightModuleLifecycleState.ready;
  }

  @override
  Future<void> start() async {
    _lifecycleState = KnightModuleLifecycleState.running;
  }

  @override
  Future<void> pause() async {
    _lifecycleState = KnightModuleLifecycleState.paused;
  }

  @override
  Future<void> dispose() async {
    _lifecycleState = KnightModuleLifecycleState.disposed;
  }
}
