import 'dart:async';
import 'engine_interfaces.dart';
import 'engine_types.dart';
import 'search_models.dart';
import '../../intelligence/intelligence_bus.dart';
import '../../intelligence/domain/intelligence_events.dart';

/// Implementation of KnightEventBus that bridges with the IntelligenceBus.
class PlatformEventBus implements KnightEventBus {
  PlatformEventBus({this.intelligenceBus}) {
    _initBridge();
  }

  final IntelligenceBus? intelligenceBus;
  final StreamController<KnightEngineEvent> _controller =
      StreamController<KnightEngineEvent>.broadcast();

  void _initBridge() {
    intelligenceBus?.events.listen((event) {
      if (event is DataChangedEvent) {
        emit(const KnightDataRefreshEvent());
      }
    });
  }

  @override
  Future<void> emit(KnightEngineEvent event) async {
    _controller.add(event);
  }

  @override
  void listen<T extends KnightEngineEvent>(
    Future<void> Function(T event) listener,
  ) {
    _controller.stream.where((e) => e is T).cast<T>().listen(listener);
  }

  @override
  void removeListener<T extends KnightEngineEvent>(
    Future<void> Function(T event) listener,
  ) {
    // Simplified implementation for platform activation
  }

  void dispose() {
    _controller.close();
  }
}

/// Central orchestrator for the KnightOS engine layer.
class KnightEngine
    implements
        KnightEngineCoordinator,
        KnightModuleRegistry,
        KnightFeatureModuleRegistry,
        KnightSearchCoordinator {
  KnightEngine({this._serviceProvider, this._stateStore, this._eventBus});

  final KnightServiceProvider? _serviceProvider;
  final KnightEngineStateStore? _stateStore;
  final KnightEventBus? _eventBus;
  final List<KnightModule> _modules = <KnightModule>[];
  final List<KnightFeatureModule> _featureModules = <KnightFeatureModule>[];
  KnightEngineLifecycleState _lifecycleState =
      KnightEngineLifecycleState.bootstrapping;

  /// Returns the registered service provider if one has been supplied.
  KnightServiceProvider? get serviceProvider => _serviceProvider;

  /// Returns the registered state store if one has been supplied.
  KnightEngineStateStore? get stateStore => _stateStore;

  /// Returns the registered event bus if one has been supplied.
  KnightEventBus? get eventBus => _eventBus;

  /// Returns the currently registered modules.
  @override
  List<KnightModule> get modules => List<KnightModule>.unmodifiable(_modules);

  /// Returns the currently registered feature modules.
  @override
  List<KnightFeatureModule> get featureModules =>
      List<KnightFeatureModule>.unmodifiable(_featureModules);

  /// Returns the current engine lifecycle state.
  @override
  KnightEngineLifecycleState get lifecycleState => _lifecycleState;

  @override
  Future<void> start() async {
    _lifecycleState = KnightEngineLifecycleState.ready;
    for (final module in _modules) {
      await module.initialize();
      await module.start();
    }
    for (final module in _featureModules) {
      await module.initialize();
      await module.start();
    }
    _lifecycleState = KnightEngineLifecycleState.running;
    _eventBus?.emit(const KnightEngineStartedEvent());
  }

  @override
  Future<void> stop() async {
    for (final module in _modules) {
      await module.pause();
      await module.dispose();
    }
    for (final module in _featureModules) {
      await module.pause();
      await module.dispose();
    }
    _lifecycleState = KnightEngineLifecycleState.disposed;
    _eventBus?.emit(const KnightEngineStoppedEvent());
  }

  @override
  Future<void> registerModule(KnightModule module) async {
    if (_modules.any((m) => m.id == module.id)) return;
    _modules.add(module);
    if (_lifecycleState == KnightEngineLifecycleState.running) {
      await module.initialize();
      await module.start();
    }
    _eventBus?.emit(KnightModuleRegisteredEvent(module.id));
  }

  @override
  Future<void> unregisterModule(String moduleId) async {
    final module = _modules.where((m) => m.id == moduleId).firstOrNull;
    if (module != null) {
      await module.pause();
      await module.dispose();
      _modules.remove(module);
    }
  }

  @override
  Future<void> registerFeatureModule(KnightFeatureModule module) async {
    if (_featureModules.any((m) => m.id == module.id)) return;
    _featureModules.add(module);
    if (_lifecycleState == KnightEngineLifecycleState.running) {
      await module.initialize();
      await module.start();
    }
    _eventBus?.emit(KnightModuleRegisteredEvent(module.id));
  }

  @override
  Future<void> unregisterFeatureModule(String moduleId) async {
    final module = _featureModules.where((m) => m.id == moduleId).firstOrNull;
    if (module != null) {
      await module.pause();
      await module.dispose();
      _featureModules.remove(module);
    }
  }

  @override
  Future<List<KnightSearchResult>> searchModules(
    KnightSearchQuery query,
    List<KnightFeatureModule> modules,
  ) async {
    final List<KnightSearchResult> results = [];
    for (final module in modules) {
      if (module.searchProvider != null) {
        final page = await module.searchProvider!.search(query);
        results.addAll(page.items);
      }
    }
    return results;
  }
}
