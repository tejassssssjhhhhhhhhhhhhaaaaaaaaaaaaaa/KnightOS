/// Shared type definitions for the Knight Engine core platform.
///
/// These types are intentionally structural and contain no feature-specific
/// business logic. They provide the strongly typed vocabulary required for
/// lifecycle coordination, engine state, and platform events.
library;

/// Lifecycle state for a module participating in the Knight Engine.
enum KnightModuleLifecycleState {
  /// The module is being initialized and prepared for service.
  bootstrapping,

  /// The module is ready to be started.
  ready,

  /// The module is actively running.
  running,

  /// The module has been temporarily paused.
  paused,

  /// The module has been disposed and should no longer run.
  disposed,
}

/// Lifecycle state for the engine itself.
enum KnightEngineLifecycleState {
  /// The engine is bootstrapping its core services.
  bootstrapping,

  /// The engine is ready to accept module registration and startup.
  ready,

  /// The engine is actively running.
  running,

  /// The engine has been paused.
  paused,

  /// The engine has been disposed.
  disposed,
}

/// Immutable snapshot of the engine runtime state.
class KnightEngineState {
  /// Creates a typed engine-state snapshot.
  const KnightEngineState({
    required this.lifecycle,
    this.registeredModuleIds = const <String>[],
  });

  /// Current lifecycle state of the engine.
  final KnightEngineLifecycleState lifecycle;

  /// Identifiers of the modules currently registered with the engine.
  final List<String> registeredModuleIds;
}

/// Base type for typed engine events.
abstract class KnightEngineEvent {
  /// Creates a typed engine event.
  const KnightEngineEvent();
}

/// Raised when the engine has completed startup.
class KnightEngineStartedEvent extends KnightEngineEvent {
  /// Creates a startup event.
  const KnightEngineStartedEvent();
}

/// Raised when the engine is stopped.
class KnightEngineStoppedEvent extends KnightEngineEvent {
  /// Creates a shutdown event.
  const KnightEngineStoppedEvent();
}

/// Raised when a module is registered with the engine.
class KnightModuleRegisteredEvent extends KnightEngineEvent {
  /// Creates a registration event.
  const KnightModuleRegisteredEvent(this.moduleId);

  /// Identifier of the registered module.
  final String moduleId;
}

/// Raised when a module changes lifecycle state.
class KnightModuleLifecycleChangedEvent extends KnightEngineEvent {
  /// Creates a lifecycle-change event.
  const KnightModuleLifecycleChangedEvent({
    required this.moduleId,
    required this.previousState,
    required this.nextState,
  });

  /// Identifier of the affected module.
  final String moduleId;

  /// Previous lifecycle state.
  final KnightModuleLifecycleState previousState;

  /// New lifecycle state.
  final KnightModuleLifecycleState nextState;
}

/// Raised when the engine or a module reports an error.
class KnightEngineErrorEvent extends KnightEngineEvent {
  /// Creates an error event.
  const KnightEngineErrorEvent({required this.message, this.error});

  /// Human-readable description of the error.
  final String message;

  /// Optional underlying exception or failure.
  final Object? error;
}

/// Raised when the platform data should be refreshed.
class KnightDataRefreshEvent extends KnightEngineEvent {
  /// Creates a data-refresh event.
  const KnightDataRefreshEvent();
}
