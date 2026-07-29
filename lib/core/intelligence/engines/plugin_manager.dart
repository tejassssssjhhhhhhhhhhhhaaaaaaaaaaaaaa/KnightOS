import '../domain/plugin_models.dart';

/// Manages the registry and lifecycle of KnightOS plugins.
class PluginManager {
  final Map<String, KnightPlugin> _plugins = {};
  final Map<String, PluginStatus> _statuses = {};

  /// Registers and activates a plugin if permissions allow.
  Future<void> register(KnightPlugin plugin) async {
    _plugins[plugin.manifest.id] = plugin;
    _statuses[plugin.manifest.id] = PluginStatus.installed;
    
    await _activate(plugin.manifest.id);
  }

  Future<void> _activate(String id) async {
    final plugin = _plugins[id];
    if (plugin == null) return;

    try {
      await plugin.onActivate();
      _statuses[id] = PluginStatus.active;
    } catch (e) {
      _statuses[id] = PluginStatus.error;
    }
  }

  /// Checks if a plugin has a specific permission.
  bool hasPermission(String pluginId, PluginPermission permission) {
    final plugin = _plugins[pluginId];
    if (plugin == null) return false;
    return plugin.manifest.permissions.contains(permission);
  }

  List<KnightPlugin> get activePlugins => 
      _plugins.values.where((p) => _statuses[p.manifest.id] == PluginStatus.active).toList();
}
