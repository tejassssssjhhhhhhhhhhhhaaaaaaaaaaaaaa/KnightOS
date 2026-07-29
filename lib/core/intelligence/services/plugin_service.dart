import '../domain/plugin_models.dart';
import '../engines/plugin_manager.dart';

/// Public API for managing KnightOS extensions.
class PluginService {
  const PluginService({required this.manager});

  final PluginManager manager;

  Future<void> installPlugin(KnightPlugin plugin) => manager.register(plugin);

  List<KnightPlugin> listActivePlugins() => manager.activePlugins;

  bool verifyAccess(String pluginId, PluginPermission permission) =>
      manager.hasPermission(pluginId, permission);
}
