import 'dart:async';
import '../domain/connectors/i_connector.dart';
import '../domain/connectors/connector_manifest.dart';
import '../domain/connectors/connector_health.dart';
import '../domain/events/integration_events.dart';
import 'event_bus.dart';
import '../internal/utils/knight_logger.dart';

/// Central orchestrator for all KnightOS connectors.
class IntegrationHub {
  IntegrationHub._({EventBus? eventBus})
      : _eventBus = eventBus ?? EventBus.instance;

  static final IntegrationHub instance = IntegrationHub._();

  final EventBus _eventBus;
  final Map<String, IConnector> _connectors = {};
  final Map<String, ConnectorHealth> _healthTracker = {};

  /// Registers a new connector plugin.
  void register(IConnector connector) {
    if (_connectors.containsKey(connector.manifest.id)) {
      KnightLogger.warn('[HUB] Connector ${connector.manifest.id} already registered.');
      return;
    }
    _connectors[connector.manifest.id] = connector;
    _healthTracker[connector.manifest.id] = ConnectorHealth(
      apiStatus: 'unknown',
      version: connector.manifest.version,
    );
    
    KnightLogger.info('[HUB] Registered: ${connector.manifest.name} (${connector.manifest.id})');
    
    // Listen for status changes to update health or publish events
    connector.onStatusChanged.listen((status) => _handleStatusChange(connector, status));
  }

  /// Discovers and returns all registered connector manifests.
  List<ConnectorManifest> getDiscoverableConnectors() {
    return _connectors.values.map((c) => c.manifest).toList();
  }

  /// Starts a sync cycle for a specific connector.
  Future<void> sync(String connectorId, {bool fullSync = false}) async {
    final connector = _connectors[connectorId];
    if (connector == null) throw Exception('Connector $connectorId not found');

    _eventBus.publish(SyncStarted(connectorId: connectorId, timestamp: DateTime.now()));

    try {
      final result = await connector.sync(fullSync: fullSync);
      
      if (result.isSuccess) {
        _eventBus.publish(SyncCompleted(
          connectorId: connectorId,
          timestamp: DateTime.now(),
          itemsProcessed: result.data ?? 0,
        ));
      } else {
        _eventBus.publish(SyncFailed(
          connectorId: connectorId,
          timestamp: DateTime.now(),
          error: result.error ?? 'Unknown error',
          category: result.errorCategory.name,
        ));
      }
    } catch (e) {
      _eventBus.publish(SyncFailed(
        connectorId: connectorId,
        timestamp: DateTime.now(),
        error: e.toString(),
        category: ErrorCategory.internal.name,
      ));
    }
  }

  void _handleStatusChange(IConnector connector, ConnectorStatus status) {
    KnightLogger.info('[HUB] Connector ${connector.manifest.id} status changed: $status');
    
    if (status == ConnectorStatus.connected) {
      _eventBus.publish(ConnectorConnected(connectorId: connector.manifest.id, timestamp: DateTime.now()));
    } else if (status == ConnectorStatus.failed || status == ConnectorStatus.revoked) {
      _eventBus.publish(ConnectorDisconnected(connectorId: connector.manifest.id, timestamp: DateTime.now()));
    }
  }

  /// Returns the health metrics for a connector.
  Future<ConnectorHealth> getHealth(String connectorId) async {
    final connector = _connectors[connectorId];
    if (connector == null) return const ConnectorHealth(apiStatus: 'not_found', version: '0.0.0');
    return await connector.getHealth();
  }
}
