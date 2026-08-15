import 'dart:async';
import 'dart:math' as math;
import 'engine_interfaces.dart';
import 'engine_types.dart';
import 'scoring_interfaces.dart';
import 'scoring_models.dart';
import '../../internal/utils/knight_logger.dart';

/// Production-ready scoring engine for KnightOS.
class PlatformScoringEngine implements KnightModule, KnightScoreStore {
  PlatformScoringEngine({
    this._eventBus,
    KnightScoreAggregator? aggregator,
  }) : _aggregator = aggregator ?? DefaultScoreAggregator();

  final KnightEventBus? _eventBus;
  final KnightScoreAggregator _aggregator;
  final List<KnightScoreProvider> _providers = <KnightScoreProvider>[];
  final List<KnightScoreSnapshot> _snapshots = <KnightScoreSnapshot>[];

  KnightModuleLifecycleState _lifecycleState = KnightModuleLifecycleState.ready;

  final Map<String, double> _sourceWeights = {};

  @override
  String get id => 'scoring_engine';

  @override
  String get name => 'Knight Scoring Engine';

  @override
  KnightModuleLifecycleState get lifecycleState => _lifecycleState;

  List<KnightScoreProvider> get providers => List.unmodifiable(_providers);

  /// Sets weight for a specific source.
  void setSourceWeight(String sourceName, double weight) {
    _sourceWeights[sourceName] = weight;
    KnightLogger.info('[SCORING] Set weight for $sourceName: $weight', category: KnightLogCategory.intelligence);
  }

  void registerProvider(KnightScoreProvider provider) {
    if (_providers.any((p) => p.id == provider.id)) return;
    _providers.add(provider);
    _eventBus?.emit(KnightModuleRegisteredEvent(provider.id));
  }

  void unregisterProvider(String providerId) {
    _providers.removeWhere((p) => p.id == providerId);
  }

  @override
  Future<List<KnightScoreSnapshot>> getSnapshots() async {
    return List.unmodifiable(_snapshots);
  }

  Future<void> refreshScores() async {
    KnightLogger.info('[SCORING] Refreshing all scores...', category: KnightLogCategory.intelligence);

    final Map<KnightScoreCategory, List<KnightScoreValue>> groupedValues = {};

    for (final provider in _providers) {
      try {
        final score = await provider.requestScore();
        groupedValues.putIfAbsent(score.category, () => []).add(score);
      } catch (e, stack) {
        KnightLogger.error('[SCORING] Failed to get score from ${provider.id}: $e', stackTrace: stack, category: KnightLogCategory.intelligence);
      }
    }

    final List<KnightScoreSnapshot> newSnapshots = [];
    for (final entry in groupedValues.entries) {
      final snapshot = await _aggregator.aggregateScores(entry.value);
      newSnapshots.add(snapshot);
    }

    _snapshots.clear();
    _snapshots.addAll(newSnapshots);

    KnightLogger.info('[SCORING] Refresh complete. ${newSnapshots.length} categories aggregated.', category: KnightLogCategory.intelligence);
  }

  @override
  Future<void> initialize() async {
    _lifecycleState = KnightModuleLifecycleState.ready;
  }

  @override
  Future<void> start() async {
    _lifecycleState = KnightModuleLifecycleState.running;
    await refreshScores();
  }

  @override
  Future<void> pause() async {
    _lifecycleState = KnightModuleLifecycleState.paused;
  }

  @override
  Future<void> dispose() async {
    _providers.clear();
    _snapshots.clear();
  }
}

/// Default implementation of score aggregation with weighted logic.
class DefaultScoreAggregator implements KnightScoreAggregator {
  final Map<String, double> _sourceWeights;

  DefaultScoreAggregator({Map<String, double>? sourceWeights})
    : _sourceWeights = sourceWeights ?? {
        'Galaxy Watch': 0.9,
        'Samsung Health': 0.8,
        'Health Connect': 0.7,
        'Manual Input': 1.0,
        'AI Inference': 0.6,
      };

  @override
  Future<KnightScoreSnapshot> aggregateScores(List<KnightScoreValue> values) async {
    if (values.isEmpty) {
      throw ArgumentError('Cannot aggregate empty score list');
    }

    final category = values.first.category;
    double totalWeightedValue = 0;
    double totalWeight = 0;
    double totalConfidence = 0;

    for (final v in values) {
      final weight = _sourceWeights[v.source.name] ?? 0.5;

      // Freshness decay: 10% reduction per day, up to 50%
      final age = DateTime.now().difference(v.timestamp).inDays;
      final freshnessFactor = math.max(0.5, 1.0 - (age * 0.1));

      final combinedWeight = weight * freshnessFactor * v.confidence.value;
      totalWeightedValue += v.value * combinedWeight;
      totalWeight += combinedWeight;
      totalConfidence += v.confidence.value;
    }

    final aggregatedValue = totalWeight > 0 ? totalWeightedValue / totalWeight : 0.0;
    final averageConfidence = values.isEmpty ? 0.0 : totalConfidence / values.length;

    return KnightScoreSnapshot(
      category: category,
      value: aggregatedValue,
      grade: _calculateGrade(aggregatedValue),
      confidence: KnightScoreConfidence(value: averageConfidence),
      timestamp: DateTime.now(),
      sources: values,
    );
  }

  KnightScoreGrade _calculateGrade(double value) {
    if (value >= 90) return const KnightScoreGrade(label: 'Optimal', rank: 5);
    if (value >= 80) return const KnightScoreGrade(label: 'Nominal', rank: 4);
    if (value >= 70) return const KnightScoreGrade(label: 'Good', rank: 3);
    if (value >= 60) return const KnightScoreGrade(label: 'Fair', rank: 2);
    return const KnightScoreGrade(label: 'Poor', rank: 1);
  }
}
