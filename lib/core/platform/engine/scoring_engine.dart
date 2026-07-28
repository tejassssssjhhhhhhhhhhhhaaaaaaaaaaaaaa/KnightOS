/// Production-ready scoring engine shell for KnightOS.
///
/// This engine integrates with the Knight Engine architecture by exposing typed
/// scoring contracts, registration, aggregation, and read-only snapshots.
/// It intentionally contains no real scoring logic and leaves calculation
/// behavior as TODO placeholders for future implementations.
library;

import 'engine_interfaces.dart';
import 'engine_types.dart';
import 'scoring_interfaces.dart';
import 'scoring_models.dart';

/// Main platform orchestrator for the scoring domain within Knight Engine.
///
/// The platform scoring engine is intentionally dependency injection friendly and keeps
/// the scoring contracts isolated from feature modules.
class PlatformScoringEngine implements KnightModule {
  /// Creates a platform scoring engine with optional injected collaborators.
  PlatformScoringEngine({
    this._serviceProvider,
    this._eventBus,
    this._aggregator,
  });

  final KnightServiceProvider? _serviceProvider;
  final KnightEventBus? _eventBus;
  final KnightScoreAggregator? _aggregator;
  final List<KnightScoreProvider> _providers = <KnightScoreProvider>[];
  final List<KnightScoreSnapshot> _snapshots = <KnightScoreSnapshot>[];
  KnightModuleLifecycleState _lifecycleState =
      KnightModuleLifecycleState.bootstrapping;

  /// Returns the registered service provider if one exists.
  KnightServiceProvider? get serviceProvider => _serviceProvider;

  /// Returns the registered event bus if one exists.
  KnightEventBus? get eventBus => _eventBus;

  /// Returns the registered aggregator if one exists.
  KnightScoreAggregator? get aggregator => _aggregator;

  /// Returns the current lifecycle state.
  @override
  KnightModuleLifecycleState get lifecycleState => _lifecycleState;

  /// Returns the currently registered providers.
  List<KnightScoreProvider> get providers =>
      List<KnightScoreProvider>.unmodifiable(_providers);

  /// Returns the current snapshots as read-only data.
  List<KnightScoreSnapshot> get snapshots =>
      List<KnightScoreSnapshot>.unmodifiable(_snapshots);

  /// Registers a score provider with the engine.
  void registerProvider(KnightScoreProvider provider) {
    // TODO: validate uniqueness and register the provider.
    _providers.add(provider);
  }

  /// Unregisters a score provider.
  void unregisterProvider(String providerId) {
    // TODO: remove the provider by identifier.
    _providers.removeWhere((provider) => provider.id == providerId);
  }

  /// Requests scores from all registered providers and updates snapshots.
  Future<void> refreshScores() async {
    // TODO: request scores from providers, aggregate them, and update snapshots.
    _lifecycleState = KnightModuleLifecycleState.running;
  }

  /// Returns a snapshot for the supplied category.
  KnightScoreSnapshot? snapshotFor(KnightScoreCategory category) {
    // TODO: resolve the matching snapshot for the supplied category.
    return _snapshots
        .where((snapshot) => snapshot.category == category)
        .cast<KnightScoreSnapshot?>()
        .firstOrNull;
  }

  @override
  String get id => 'scoring_engine';

  @override
  String get name => 'Scoring Engine';

  @override
  Future<void> initialize() async {
    // TODO: initialize dependencies and prepare the scoring engine.
    _lifecycleState = KnightModuleLifecycleState.ready;
  }

  @override
  Future<void> start() async {
    // TODO: start processing and refresh scoring state.
    _lifecycleState = KnightModuleLifecycleState.running;
  }

  @override
  Future<void> pause() async {
    // TODO: pause processing and preserve current snapshots.
    _lifecycleState = KnightModuleLifecycleState.paused;
  }

  @override
  Future<void> dispose() async {
    // TODO: clear current state and release references.
    _snapshots.clear();
    _lifecycleState = KnightModuleLifecycleState.disposed;
  }
}

extension on Iterable<KnightScoreSnapshot?> {
  KnightScoreSnapshot? get firstOrNull => isEmpty ? null : first;
}
