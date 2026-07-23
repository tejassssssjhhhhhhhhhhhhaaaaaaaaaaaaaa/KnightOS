import '../../../core/engine/analytics_models.dart';
import '../../../core/engine/engine_interfaces.dart';
import '../../../core/engine/engine_types.dart';
import '../../../core/engine/feature_interfaces.dart';
import '../../../core/engine/recommendation_models.dart';
import '../../../core/engine/scoring_models.dart';
import '../../../core/engine/search_models.dart';
import 'work_module_state.dart';

class WorkSearchProvider implements KnightFeatureSearchProvider {
  WorkSearchProvider({required this.state});

  final WorkModuleState state;

  @override
  String get id => 'work.search';

  @override
  String get name => 'Work Search';

  @override
  String get moduleId => 'work';

  @override
  Future<KnightSearchPage> search(KnightSearchQuery query) async {
    final normalized = query.text.trim().toLowerCase();
    final filtered = state.sessions.where((session) {
      final content = <String>[
        session.workDate,
        session.shiftType,
        session.notes,
      ].join(' ').toLowerCase();
      final textMatches = normalized.isEmpty || content.contains(normalized);
      final filterMatches = query.filters.every((filter) {
        if (filter.operator == KnightSearchFilterOperator.contains) {
          return content.contains(filter.value.toLowerCase());
        }
        return true;
      });
      return textMatches && filterMatches;
    }).toList();

    final items = filtered
        .map(
          (session) => KnightSearchResult(
            id: session.id,
            moduleId: moduleId,
            title: '${session.workDate} · ${session.shiftType}',
            summary: '${session.questionsCompleted} questions · ${session.callsHandled} calls · ${session.chatsHandled} chats',
            metadata: <String, String>{
              'date': session.workDate,
              'shiftType': session.shiftType,
              'notes': session.notes,
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

    return state.sessions
        .where((session) => session.workDate.contains(normalized) || session.shiftType.toLowerCase().contains(normalized) || session.notes.toLowerCase().contains(normalized))
        .map((session) => session.workDate)
        .take(6)
        .toList();
  }
}

class WorkScoreProvider implements KnightFeatureScoreProvider {
  @override
  String get id => 'work.score';

  @override
  String get name => 'Work Score';

  @override
  KnightScoreCategory get category => KnightScoreCategory.work;

  @override
  Future<KnightScoreValue> requestScore() async {
    return KnightScoreValue(
      value: 0.0,
      category: KnightScoreCategory.work,
      grade: const KnightScoreGrade(label: 'Pending', rank: 0),
      confidence: const KnightScoreConfidence(value: 0.0),
      timestamp: DateTime.now(),
      source: const KnightScoreSource(name: 'work'),
    );
  }
}

class WorkAnalyticsProvider implements KnightFeatureAnalyticsProvider {
  WorkAnalyticsProvider({required this.state});

  final WorkModuleState state;

  @override
  String get id => 'work.analytics';

  @override
  String get name => 'Work Analytics';

  @override
  String get moduleId => 'work';

  @override
  Future<List<KnightHistoricalDataPoint>> requestHistoricalData() async {
    return <KnightHistoricalDataPoint>[];
  }

  @override
  Future<List<KnightMetric>> requestMetrics() async {
    return <KnightMetric>[
      KnightMetric(name: 'Weekly Summary', value: 0.0, timestamp: DateTime.now()),
      KnightMetric(name: 'Monthly Summary', value: 0.0, timestamp: DateTime.now()),
      KnightMetric(name: 'Work Streak', value: 0.0, timestamp: DateTime.now()),
      KnightMetric(name: 'Goal Progress', value: 0.0, timestamp: DateTime.now()),
      KnightMetric(name: 'Average Questions', value: 0.0, timestamp: DateTime.now()),
      KnightMetric(name: 'Average Calls', value: 0.0, timestamp: DateTime.now()),
      KnightMetric(name: 'Average Chats', value: 0.0, timestamp: DateTime.now()),
    ];
  }

  @override
  Future<List<KnightScoreValue>> requestScoreHistory() async {
    return <KnightScoreValue>[];
  }
}

class WorkRecommendationProvider implements KnightFeatureRecommendationProvider {
  @override
  String get id => 'work.recommendation';

  @override
  String get name => 'Work Recommendations';

  @override
  String get moduleId => 'work';

  @override
  Future<List<KnightRecommendation>> requestRecommendations({
    required List<KnightScoreValue> scores,
    required List<KnightAnalyticsSnapshot> analytics,
  }) async {
    return <KnightRecommendation>[
      KnightRecommendation(
        id: 'work-consistency',
        title: 'Improve consistency',
        description: 'Keep your shift logging consistent to maintain a reliable work streak.',
        category: KnightRecommendationCategory.work,
        priority: KnightRecommendationPriority.medium,
        confidence: const KnightRecommendationConfidence(value: 0.5),
        reason: const KnightRecommendationReason(summary: 'Work session history is sparse.'),
        source: const KnightRecommendationSource(name: 'work'),
        action: const KnightRecommendationAction(label: 'Log today\'s shift'),
        timestamp: DateTime.now(),
      ),
      KnightRecommendation(
        id: 'work-target',
        title: 'Reach daily target',
        description: 'Record work output and keep your daily goal in sight.',
        category: KnightRecommendationCategory.work,
        priority: KnightRecommendationPriority.medium,
        confidence: const KnightRecommendationConfidence(value: 0.5),
        reason: const KnightRecommendationReason(summary: 'Daily target placeholder is not met.'),
        source: const KnightRecommendationSource(name: 'work'),
        action: const KnightRecommendationAction(label: 'Review work log'),
        timestamp: DateTime.now(),
      ),
    ];
  }
}

class WorkFeatureModule implements KnightFeatureModule {
  WorkFeatureModule({required this._state})
      : metadata = const KnightModuleMetadata(
          id: 'work',
          name: 'Work Intelligence',
          description: 'Professional productivity center for KnightOS, exposing work tracking, analytics, search, and recommendations.',
          version: '0.1.0',
          category: 'work',
          tags: <String>['work', 'productivity', 'shift-tracking', 'professional'],
        ),
        capabilities = const <KnightModuleCapability>[
          KnightModuleCapability(id: 'search', name: 'Search', description: 'Search work sessions by date, shift, or notes.'),
          KnightModuleCapability(id: 'analytics', name: 'Analytics', description: 'Expose work analytics placeholders.'),
          KnightModuleCapability(id: 'scoring', name: 'Scoring', description: 'Expose a placeholder work score.'),
          KnightModuleCapability(id: 'recommendations', name: 'Recommendations', description: 'Provide work-related recommendations.'),
        ],
        configuration = const KnightModuleConfiguration(
          moduleId: 'work',
          enabled: true,
          offlineEnabled: true,
          aiAssistedEnabled: false,
          searchEnabled: true,
        ),
        state = const KnightModuleState(
          moduleId: 'work',
          isEnabled: true,
          isAvailable: true,
          isOnline: true,
          isOfflineCapable: true,
          isAiCapable: false,
        ) {
    searchProvider = WorkSearchProvider(state: _state);
    analyticsProvider = WorkAnalyticsProvider(state: _state);
    scoreProvider = WorkScoreProvider();
    recommendationProvider = WorkRecommendationProvider();
  }

  final WorkModuleState _state;

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
