/// Phase 1 production-ready skeleton for the Knight Engine.
///
/// This file establishes the architecture boundary described in DESIGN.md:
/// a central orchestrator for future modules, features, and cross-feature flows.
///
/// No feature-specific business logic is implemented here. The class remains an
/// orchestrator-only shell with typed lifecycle and event contracts for future
/// implementations.
library;

import 'engine_interfaces.dart';
import 'engine_types.dart';
import 'search_models.dart';

/// Central orchestrator for the KnightOS engine layer.
///
/// The engine owns lifecycle coordination, module registration, and event flow.
/// It does not implement feature behavior itself.
class KnightEngine implements KnightEngineCoordinator, KnightModuleRegistry, KnightFeatureModuleRegistry, KnightSearchCoordinator {
  KnightEngine({
    this._serviceProvider,
    this._stateStore,
    this._eventBus,
  });

  final KnightServiceProvider? _serviceProvider;
  final KnightEngineStateStore? _stateStore;
  final KnightEventBus? _eventBus;
  final List<KnightModule> _modules = <KnightModule>[];
  final List<KnightFeatureModule> _featureModules = <KnightFeatureModule>[];
  KnightEngineLifecycleState _lifecycleState = KnightEngineLifecycleState.bootstrapping;

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
  List<KnightFeatureModule> get featureModules => List<KnightFeatureModule>.unmodifiable(_featureModules);

  /// Returns the current engine lifecycle state.
  @override
  KnightEngineLifecycleState get lifecycleState => _lifecycleState;

  @override
  Future<void> start() async {
    // TODO: transition to the ready state, initialize bootstrapping modules,
    // and then move to the running state.
    _lifecycleState = KnightEngineLifecycleState.running;
  }

  @override
  Future<void> stop() async {
    // TODO: pause running modules, dispose resources, and transition to the
    // disposed state.
    _lifecycleState = KnightEngineLifecycleState.disposed;
  }

  @override
  Future<void> registerModule(KnightModule module) async {
    // TODO: validate uniqueness, register the module, and emit a typed event.
    _modules.add(module);
  }

  @override
  Future<void> unregisterModule(String moduleId) async {
    // TODO: dispose the module if needed and remove it from the registry.
    _modules.removeWhere((module) => module.id == moduleId);
  }

  @override
  Future<void> registerFeatureModule(KnightFeatureModule module) async {
    // TODO: validate uniqueness and register the feature module.
    _featureModules.add(module);
  }

  @override
  Future<void> unregisterFeatureModule(String moduleId) async {
    // TODO: dispose the feature module if needed and remove it from the registry.
    _featureModules.removeWhere((module) => module.id == moduleId);
  }

  @override
  Future<List<KnightSearchResult>> searchModules(
    KnightSearchQuery query,
    List<KnightFeatureModule> modules,
  ) async {
    // TODO: dispatch search requests through registered feature modules.
    return <KnightSearchResult>[];
  }
}
