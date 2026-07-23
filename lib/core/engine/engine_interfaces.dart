/// Architectural contracts for the Knight Engine core platform.
///
/// These interfaces define the dependency-inversion boundaries described in
/// DESIGN.md for the future application, domain, and infrastructure layers.
/// They intentionally contain no feature-specific business logic and are meant
/// to be implemented later by concrete services, repositories, or orchestrators.
library;

import 'engine_types.dart';
import 'feature_interfaces.dart';
import 'search_models.dart';

/// Contract for a module that can participate in the engine lifecycle.
abstract class KnightModule {
  /// Stable identifier for the module.
  String get id;

  /// Human-readable name used for diagnostics and registration.
  String get name;

  /// Current lifecycle state of the module.
  KnightModuleLifecycleState get lifecycleState;

  /// Initializes the module during bootstrapping.
  Future<void> initialize();

  /// Starts the module when the engine enters the running state.
  Future<void> start();

  /// Pauses the module when the engine pauses.
  Future<void> pause();

  /// Disposes the module when the engine is shut down.
  Future<void> dispose();
}

/// Contract for the engine lifecycle orchestration boundary.
abstract class KnightEngineCoordinator {
  /// Starts the engine and transitions it into the running state.
  Future<void> start();

  /// Stops the engine and transitions it into the disposed state.
  Future<void> stop();

  /// Returns the current engine lifecycle state.
  KnightEngineLifecycleState get lifecycleState;
}

/// Contract for module registration and discovery.
abstract class KnightModuleRegistry {
  /// Registers a module with the engine.
  Future<void> registerModule(KnightModule module);

  /// Removes a module from the engine.
  Future<void> unregisterModule(String moduleId);

  /// Returns the currently registered modules.
  List<KnightModule> get modules;
}

/// Contract for reading engine runtime state.
abstract class KnightEngineStateStore {
  /// Returns the current engine state snapshot.
  Future<KnightEngineState> getState();

  /// Updates the engine state snapshot.
  Future<void> updateState(KnightEngineState state);
}

/// Contract for typed cross-feature event dispatching.
abstract class KnightEventBus {
  /// Emits a typed engine event.
  Future<void> emit(KnightEngineEvent event);

  /// Registers a listener for a specific event type.
  void listen<T extends KnightEngineEvent>(
    Future<void> Function(T event) listener,
  );

  /// Removes a listener for a specific event type.
  void removeListener<T extends KnightEngineEvent>(
    Future<void> Function(T event) listener,
  );
}

/// Contract for dependency injection readiness in the engine layer.
abstract class KnightServiceProvider {
  /// Resolves a dependency by type or identifier.
  T resolve<T>({String? key});

  /// Registers a dependency implementation.
  void register<T>(T implementation, {String? key});
}

/// Contract for a feature module that can expose typed capabilities.
abstract class KnightFeatureModule implements KnightModule {
  /// Metadata describing the module.
  KnightModuleMetadata get metadata;

  /// Capabilities exposed by the module.
  List<KnightModuleCapability> get capabilities;

  /// Current runtime state of the module.
  KnightModuleState get state;

  /// Configuration of the module.
  KnightModuleConfiguration get configuration;

  /// Score provider exposed by the module, if any.
  KnightFeatureScoreProvider? get scoreProvider;

  /// Analytics provider exposed by the module, if any.
  KnightFeatureAnalyticsProvider? get analyticsProvider;

  /// Recommendation provider exposed by the module, if any.
  KnightFeatureRecommendationProvider? get recommendationProvider;

  /// Search provider exposed by the module, if any.
  KnightFeatureSearchProvider? get searchProvider;

  /// History provider exposed by the module, if any.
  KnightHistoryProvider? get historyProvider;

  /// Settings provider exposed by the module, if any.
  KnightSettingsProvider? get settingsProvider;
}

/// Contract for a registry that can host future feature modules.
abstract class KnightFeatureModuleRegistry {
  /// Registers a feature module with the engine.
  Future<void> registerFeatureModule(KnightFeatureModule module);

  /// Removes a feature module from the engine.
  Future<void> unregisterFeatureModule(String moduleId);

  /// Returns the currently registered feature modules.
  List<KnightFeatureModule> get featureModules;
}

/// Contract for engine-level search orchestration.
abstract class KnightSearchCoordinator {
  /// Executes a search through the supplied feature modules.
  Future<List<KnightSearchResult>> searchModules(
    KnightSearchQuery query,
    List<KnightFeatureModule> modules,
  );
}
