/// Generic feature-module contracts and immutable models for KnightOS.
///
/// These definitions provide a stable, typed foundation for future modules that
/// will participate in scoring, analytics, recommendations, search, history,
/// and settings without requiring engine changes.
library;

import 'analytics_interfaces.dart';
import 'recommendation_interfaces.dart';
import 'scoring_interfaces.dart';
import 'search_interfaces.dart';

/// Immutable metadata describing a feature module.
class KnightModuleMetadata {
  /// Creates typed metadata for a feature module.
  const KnightModuleMetadata({
    required this.id,
    required this.name,
    required this.description,
    required this.version,
    required this.category,
    this.tags = const <String>[],
  });

  /// Stable identifier for the feature module.
  final String id;

  /// Human-readable module name.
  final String name;

  /// Short description of the module.
  final String description;

  /// Semantic version of the module.
  final String version;

  /// High-level module category.
  final String category;

  /// Optional tags used for discovery and filtering.
  final List<String> tags;
}

/// Immutable declaration of a capability exposed by a module.
class KnightModuleCapability {
  /// Creates a typed capability declaration.
  const KnightModuleCapability({
    required this.id,
    required this.name,
    required this.description,
    this.enabled = true,
  });

  /// Stable identifier for the capability.
  final String id;

  /// Human-readable capability name.
  final String name;

  /// Description of the capability.
  final String description;

  /// Whether the capability is active for the module.
  final bool enabled;
}

/// Immutable module-level configuration.
class KnightModuleConfiguration {
  /// Creates typed module configuration.
  const KnightModuleConfiguration({
    required this.moduleId,
    this.enabled = true,
    this.offlineEnabled = false,
    this.aiAssistedEnabled = false,
    this.searchEnabled = true,
  });

  /// Identifier of the owning module.
  final String moduleId;

  /// Whether the module is enabled.
  final bool enabled;

  /// Whether the module can operate offline.
  final bool offlineEnabled;

  /// Whether the module can use AI-assisted behaviour.
  final bool aiAssistedEnabled;

  /// Whether the module exposes search.
  final bool searchEnabled;
}

/// Immutable runtime state for a feature module.
class KnightModuleState {
  /// Creates typed module runtime state.
  const KnightModuleState({
    required this.moduleId,
    this.isEnabled = true,
    this.isAvailable = true,
    this.isOnline = true,
    this.isOfflineCapable = false,
    this.isAiCapable = false,
  });

  /// Identifier of the owning module.
  final String moduleId;

  /// Whether the module is active.
  final bool isEnabled;

  /// Whether the module is available to the engine.
  final bool isAvailable;

  /// Whether the module is currently online.
  final bool isOnline;

  /// Whether the module can operate offline.
  final bool isOfflineCapable;

  /// Whether the module can use AI-assisted behaviour.
  final bool isAiCapable;
}

/// Immutable registration metadata for a feature module.
class KnightModuleRegistration {
  /// Creates typed registration metadata.
  const KnightModuleRegistration({
    required this.moduleId,
    required this.registrationId,
    required this.registeredAt,
    this.isActive = true,
  });

  /// Identifier of the module being registered.
  final String moduleId;

  /// Stable registration identifier.
  final String registrationId;

  /// Registration timestamp.
  final DateTime registeredAt;

  /// Whether the registration is active.
  final bool isActive;
}

/// Contract for a module that can expose history data.
abstract class KnightHistoryProvider {
  /// Stable identifier for the provider.
  String get id;

  /// Human-readable name used for diagnostics.
  String get name;

  /// Module identifier associated with the provider.
  String get moduleId;

  /// Returns a typed history stream for the owning module.
  Future<List<String>> getHistory();

  /// Records a new history entry.
  Future<void> record(String entryId);
}

/// Contract for a module that can expose and update settings.
abstract class KnightSettingsProvider {
  /// Stable identifier for the provider.
  String get id;

  /// Human-readable name used for diagnostics.
  String get name;

  /// Module identifier associated with the provider.
  String get moduleId;

  /// Returns the current module configuration.
  Future<KnightModuleConfiguration> getConfiguration();

  /// Updates the current module configuration.
  Future<void> updateConfiguration(KnightModuleConfiguration configuration);
}

/// Contract for a module that can contribute score inputs.
abstract class KnightFeatureScoreProvider implements KnightScoreProvider {}

/// Contract for a module that can contribute analytics.
abstract class KnightFeatureAnalyticsProvider
    implements KnightAnalyticsProvider {}

/// Contract for a module that can contribute recommendations.
abstract class KnightFeatureRecommendationProvider
    implements KnightRecommendationProvider {}

/// Contract for a module that can contribute search results.
abstract class KnightFeatureSearchProvider implements KnightSearchProvider {}
