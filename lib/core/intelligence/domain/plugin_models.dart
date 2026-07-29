import 'package:flutter/foundation.dart';

/// Permissions requested by a plugin to access KnightOS systems.
enum PluginPermission {
  memoryRead,
  memoryWrite,
  contextRead,
  worldAccess,
  planningAccess,
}

/// Static metadata for a KnightOS plugin.
@immutable
class PluginManifest {
  const PluginManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.author,
    this.description = '',
    this.permissions = const [],
  });

  final String id;
  final String name;
  final String version;
  final String author;
  final String description;
  final List<PluginPermission> permissions;
}

/// Lifecycle states for an installed plugin.
enum PluginStatus { installed, active, error, disabled }

/// Interface for all KnightOS extensions.
abstract class KnightPlugin {
  PluginManifest get manifest;
  
  /// Called when the plugin is enabled.
  Future<void> onActivate();

  /// Called when the plugin is disabled or uninstalled.
  Future<void> onDeactivate();
}
