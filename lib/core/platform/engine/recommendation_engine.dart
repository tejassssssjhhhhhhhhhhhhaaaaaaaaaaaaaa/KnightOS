import 'dart:async';
import 'analytics_models.dart';
import 'engine_interfaces.dart';
import 'engine_types.dart';
import 'recommendation_interfaces.dart';
import 'recommendation_models.dart';
import 'scoring_models.dart';
import '../../internal/utils/knight_logger.dart';
import '../../intelligence/services/knowledge_graph_service.dart';

/// Production-ready recommendation engine for KnightOS.
class PlatformRecommendationEngine
    implements KnightModule, KnightRecommendationHistoryStore {
  PlatformRecommendationEngine({
    this._eventBus,
    KnightRecommendationPrioritizer? prioritizer,
    KnightRecommendationFilter? filter,
    this._historyStore,
    this._graphService,
  }) : _prioritizer = prioritizer ?? DefaultRecommendationPrioritizer(),
       _filter = filter ?? DefaultRecommendationFilter();

  final KnightEventBus? _eventBus;
  final KnightRecommendationPrioritizer _prioritizer;
  final KnightRecommendationFilter _filter;
  final KnightRecommendationHistoryStore? _historyStore;
  final KnowledgeGraphService? _graphService;

  final List<KnightRecommendationProvider> _providers = <KnightRecommendationProvider>[];
  final List<KnightRecommendation> _history = <KnightRecommendation>[];

  KnightModuleLifecycleState _lifecycleState = KnightModuleLifecycleState.ready;

  @override
  String get id => 'recommendation_engine';

  @override
  String get name => 'Knight Recommendation Engine';

  @override
  KnightModuleLifecycleState get lifecycleState => _lifecycleState;

  List<KnightRecommendationProvider> get providers => List.unmodifiable(_providers);

  void registerProvider(KnightRecommendationProvider provider) {
    if (_providers.any((p) => p.id == provider.id)) return;
    _providers.add(provider);
    _eventBus?.emit(KnightModuleRegisteredEvent(provider.id));
  }

  void unregisterProvider(String providerId) {
    _providers.removeWhere((p) => p.id == providerId);
  }

  Future<List<KnightRecommendation>> requestRecommendations({
    required List<KnightScoreValue> scores,
    required List<KnightAnalyticsSnapshot> analytics,
  }) async {
    KnightLogger.info('[RECOMMENDATION] Requesting recommendations from ${_providers.length} providers', category: KnightLogCategory.intelligence);

    final List<KnightRecommendation> all = <KnightRecommendation>[];
    for (final provider in _providers) {
      try {
        final recs = await provider.requestRecommendations(
          scores: scores,
          analytics: analytics,
        );
        all.addAll(recs);
      } catch (e, stack) {
        KnightLogger.error('[RECOMMENDATION] Provider ${provider.id} failed: $e', stackTrace: stack, category: KnightLogCategory.intelligence);
      }
    }

    // 1. Filter (policy-based)
    final filtered = _filter.filter(all);

    // 2. Prioritize (impact & urgency)
    final prioritized = _prioritizer.prioritize(filtered);

    // 3. Deduplicate (semantic similarity)
    final deduped = _deduplicate(prioritized);

    // 4. Trace in Knowledge Graph
    if (_graphService != null) {
      for (final rec in deduped.take(5)) {
        await _recordInGraph(rec);
      }
    }

    _history.addAll(deduped);
    if (_history.length > 50) _history.removeRange(0, _history.length - 50);

    return deduped;
  }

  List<KnightRecommendation> _deduplicate(List<KnightRecommendation> items) {
    final Map<String, KnightRecommendation> unique = {};
    for (final item in items) {
      final key = '${item.category.name}:${item.title.toLowerCase()}';
      if (!unique.containsKey(key)) {
        unique[key] = item;
      } else {
        // Keep the one with higher confidence
        if (item.confidence.value > unique[key]!.confidence.value) {
          unique[key] = item;
        }
      }
    }
    return unique.values.toList();
  }

  Future<void> _recordInGraph(KnightRecommendation rec) async {
    final graph = _graphService;
    if (graph == null) return;

    try {
      final nodeId = await graph.ensureNode(
        type: 'recommendation',
        label: rec.title,
        metadata: {
          'category': rec.category.name,
          'priority': rec.priority.name,
          'confidence': rec.confidence.value,
        },
      );

      // Link to the module source
      final sourceId = await graph.ensureNode(
        type: 'intelligence_module',
        label: rec.source.name,
      );

      await graph.link(
        fromId: sourceId,
        toId: nodeId,
        relationship: 'generated',
        weight: rec.confidence.value,
      );
    } catch (e) {
      KnightLogger.warn('[RECOMMENDATION] Failed to record in graph: $e', category: KnightLogCategory.intelligence);
    }
  }

  @override
  Future<List<KnightRecommendation>> getHistory() async {
    final store = _historyStore;
    if (store != null) return store.getHistory();
    return List.unmodifiable(_history);
  }

  @override
  Future<void> dismiss(String recommendationId) async {
    final store = _historyStore;
    if (store != null) await store.dismiss(recommendationId);
    _eventBus?.emit(KnightModuleRegisteredEvent('dismiss:$recommendationId'));
  }

  @override
  Future<void> complete(String recommendationId) async {
    final store = _historyStore;
    if (store != null) await store.complete(recommendationId);
    _eventBus?.emit(KnightModuleRegisteredEvent('complete:$recommendationId'));
  }

  @override
  Future<void> dispose() async {
    _providers.clear();
    _history.clear();
  }

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
}

/// Default implementation for recommendation prioritization.
class DefaultRecommendationPrioritizer implements KnightRecommendationPrioritizer {
  @override
  List<KnightRecommendation> prioritize(List<KnightRecommendation> items) {
    final sorted = List<KnightRecommendation>.from(items);

    sorted.sort((a, b) {
      // 1. Primary sort by Priority Level
      final priorityCompare = b.priority.index.compareTo(a.priority.index);
      if (priorityCompare != 0) return priorityCompare;

      // 2. Secondary sort by Confidence
      return b.confidence.value.compareTo(a.confidence.value);
    });

    return sorted;
  }
}

/// Default implementation for recommendation filtering.
class DefaultRecommendationFilter implements KnightRecommendationFilter {
  @override
  List<KnightRecommendation> filter(List<KnightRecommendation> items) {
    // For now, only filter out extremely low confidence recommendations (< 0.3)
    return items.where((item) => item.confidence.value >= 0.3).toList();
  }
}
