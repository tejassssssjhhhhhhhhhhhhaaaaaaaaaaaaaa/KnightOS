import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/plugin_manager.dart';
import 'package:knight_os/core/intelligence/domain/plugin_models.dart';

class MockPlugin implements KnightPlugin {
  bool activated = false;
  @override
  PluginManifest get manifest => const PluginManifest(
    id: 'mock-plugin',
    name: 'Mock',
    version: '1.0.0',
    author: 'AI',
    permissions: [PluginPermission.memoryRead],
  );

  @override
  Future<void> onActivate() async {
    activated = true;
  }

  @override
  Future<void> onDeactivate() async {
    activated = false;
  }
}

void main() {
  late PluginManager manager;

  setUp(() {
    manager = PluginManager();
  });

  group('Plugin Framework (Sprint 1.6)', () {
    test('register activates the plugin', () async {
      final plugin = MockPlugin();
      await manager.register(plugin);

      expect(plugin.activated, isTrue);
      expect(manager.activePlugins, contains(plugin));
    });

    test('hasPermission correctly identifies requested capabilities', () async {
      final plugin = MockPlugin();
      await manager.register(plugin);

      expect(manager.hasPermission('mock-plugin', PluginPermission.memoryRead), isTrue);
      expect(manager.hasPermission('mock-plugin', PluginPermission.memoryWrite), isFalse);
    });
  });
}
