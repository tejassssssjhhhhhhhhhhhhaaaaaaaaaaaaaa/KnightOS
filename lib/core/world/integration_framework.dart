import 'domain/integration_interfaces.dart';

/// Registry and lifecycle manager for external integrations.
class IntegrationFramework {
  IntegrationFramework();

  final Map<String, ExternalIntegration> _integrations = {};

  /// Registers a new integration adapter.
  void register(ExternalIntegration integration) {
    _integrations[integration.id] = integration;
  }

  /// Retrieves a registered integration.
  ExternalIntegration? get(String id) => _integrations[id];

  /// Returns all registered integrations.
  List<ExternalIntegration> get all => _integrations.values.toList();

  /// Triggers a global sync across all connected integrations.
  Future<void> syncAll() async {
    for (final integration in _integrations.values) {
      final status = await integration.getStatus();
      if (status == IntegrationStatus.connected) {
        await integration.sync();
      }
    }
  }
}
