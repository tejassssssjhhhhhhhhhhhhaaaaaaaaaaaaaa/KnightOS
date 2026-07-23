import '../../../core/engine/analytics_models.dart';
import '../../../core/engine/engine_interfaces.dart';
import '../../../core/engine/engine_types.dart';
import '../../../core/engine/feature_interfaces.dart';
import '../../../core/engine/recommendation_models.dart';
import '../../../core/engine/scoring_models.dart';
import '../../../core/engine/search_models.dart';
import '../domain/equipment_catalog.dart';
import 'fitness_module_state.dart';

/// Search provider for fitness equipment.
class FitnessSearchProvider implements KnightFeatureSearchProvider {
  FitnessSearchProvider({required this.catalog, required this.state});

  final List<FitnessEquipment> catalog;
  final FitnessModuleState state;

  @override
  String get id => 'fitness.search';

  @override
  String get name => 'Fitness Search';

  @override
  String get moduleId => 'fitness';

  @override
  Future<KnightSearchPage> search(KnightSearchQuery query) async {
    final normalized = query.text.trim().toLowerCase();
    final filtered = catalog.where((equipment) {
      final textMatches = normalized.isEmpty ||
          equipment.name.toLowerCase().contains(normalized) ||
          equipment.description.toLowerCase().contains(normalized) ||
          equipment.category.label.toLowerCase().contains(normalized) ||
          equipment.tags.any((tag) => tag.toLowerCase().contains(normalized));
      final filterMatches = query.filters.every((filter) {
        final field = filter.field.toLowerCase();
        final value = filter.value.toLowerCase();
        switch (filter.operator) {
          case KnightSearchFilterOperator.equals:
            return field == 'category' && equipment.category.label.toLowerCase() == value;
          case KnightSearchFilterOperator.notEquals:
            return field != 'category' || equipment.category.label.toLowerCase() != value;
          case KnightSearchFilterOperator.contains:
            return field == 'name' && equipment.name.toLowerCase().contains(value);
          case KnightSearchFilterOperator.greaterThan:
            return false;
          case KnightSearchFilterOperator.lessThan:
            return false;
        }
      });
      return textMatches && filterMatches;
    }).toList();

    final sorted = List<FitnessEquipment>.from(filtered)
      ..sort((left, right) => left.name.compareTo(right.name));

    final items = sorted
        .map(
          (equipment) => KnightSearchResult(
            id: equipment.id,
            moduleId: moduleId,
            title: equipment.name,
            summary: equipment.description,
            metadata: <String, String>{
              'category': equipment.category.label,
              'available': state.availableEquipmentIds.contains(equipment.id) ? 'true' : 'false',
            },
          ),
        )
        .toList();

    return KnightSearchPage(items: items, page: query.page, pageSize: query.pageSize, hasMore: false);
  }

  @override
  Future<List<String>> suggest(KnightSearchQuery query) async {
    final normalized = query.text.trim().toLowerCase();
    if (normalized.isEmpty) {
      return <String>[];
    }
    return catalog
        .where((equipment) => equipment.name.toLowerCase().contains(normalized) || equipment.category.label.toLowerCase().contains(normalized))
        .map((equipment) => equipment.name)
        .take(6)
        .toList();
  }
}

/// Score provider for fitness module.
class FitnessScoreProvider implements KnightFeatureScoreProvider {
  @override
  String get id => 'fitness.score';

  @override
  String get name => 'Fitness Score';

  @override
  KnightScoreCategory get category => KnightScoreCategory.fitness;

  @override
  Future<KnightScoreValue> requestScore() async {
    return KnightScoreValue(
      value: 0.0,
      category: KnightScoreCategory.fitness,
      grade: const KnightScoreGrade(label: 'Pending', rank: 0),
      confidence: const KnightScoreConfidence(value: 0.0),
      timestamp: DateTime.now(),
      source: const KnightScoreSource(name: 'fitness'),
    );
  }
}

/// Analytics provider for fitness module.
class FitnessAnalyticsProvider implements KnightFeatureAnalyticsProvider {
  FitnessAnalyticsProvider({required this.state});

  final FitnessModuleState state;

  @override
  String get id => 'fitness.analytics';

  @override
  String get name => 'Fitness Analytics';

  @override
  String get moduleId => 'fitness';

  @override
  Future<List<KnightHistoricalDataPoint>> requestHistoricalData() async {
    return <KnightHistoricalDataPoint>[];
  }

  @override
  Future<List<KnightMetric>> requestMetrics() async {
    final availableCount = state.availableEquipmentIds.length.toDouble();
    return <KnightMetric>[
      KnightMetric(name: 'Equipment Count', value: availableCount, timestamp: DateTime.now()),
      KnightMetric(name: 'Category Distribution', value: availableCount, timestamp: DateTime.now()),
      KnightMetric(name: 'Workout Capability Score', value: 0.0, timestamp: DateTime.now()),
    ];
  }

  @override
  Future<List<KnightScoreValue>> requestScoreHistory() async {
    return <KnightScoreValue>[];
  }
}

/// Recommendation provider for fitness module.
class FitnessRecommendationProvider implements KnightFeatureRecommendationProvider {
  @override
  String get id => 'fitness.recommendation';

  @override
  String get name => 'Fitness Recommendations';

  @override
  String get moduleId => 'fitness';

  @override
  Future<List<KnightRecommendation>> requestRecommendations({
    required List<KnightScoreValue> scores,
    required List<KnightAnalyticsSnapshot> analytics,
  }) async {
    return <KnightRecommendation>[];
  }
}

/// Engine-facing feature module implementation for fitness.
class FitnessFeatureModule implements KnightFeatureModule {
  FitnessFeatureModule({required this._fitnessState, required this._catalog})
      : metadata = const KnightModuleMetadata(
          id: 'fitness',
          name: 'Fitness',
          description: 'Equipment-focused fitness module for the KnightOS engine platform.',
          version: '0.1.0',
          category: 'fitness',
          tags: <String>['fitness', 'equipment', 'gym'],
        ),
        capabilities = const <KnightModuleCapability>[
          KnightModuleCapability(id: 'search', name: 'Search', description: 'Search fitness equipment by text and category.'),
          KnightModuleCapability(id: 'scoring', name: 'Scoring', description: 'Expose fitness scoring placeholders.'),
          KnightModuleCapability(id: 'analytics', name: 'Analytics', description: 'Expose fitness analytics placeholders.'),
          KnightModuleCapability(id: 'recommendations', name: 'Recommendations', description: 'Expose fitness recommendation placeholders.'),
        ],
        configuration = const KnightModuleConfiguration(
          moduleId: 'fitness',
          enabled: true,
          offlineEnabled: true,
          aiAssistedEnabled: false,
          searchEnabled: true,
        ),
        state = const KnightModuleState(
          moduleId: 'fitness',
          isEnabled: true,
          isAvailable: true,
          isOnline: true,
          isOfflineCapable: true,
          isAiCapable: false,
        ) {
    searchProvider = FitnessSearchProvider(catalog: _catalog, state: _fitnessState);
    scoreProvider = FitnessScoreProvider();
    analyticsProvider = FitnessAnalyticsProvider(state: _fitnessState);
    recommendationProvider = FitnessRecommendationProvider();
  }

  final FitnessModuleState _fitnessState;
  final List<FitnessEquipment> _catalog;

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

  KnightModuleLifecycleState _lifecycleState = KnightModuleLifecycleState.bootstrapping;

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
