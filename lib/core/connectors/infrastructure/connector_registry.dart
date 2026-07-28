import '../domain/knight_connector.dart';
import '../implementations/timeline_connector.dart';
import '../implementations/finance_connector.dart';
import '../implementations/health_connector.dart';

/// Central registry for all data connectors in KnightOS.
class ConnectorRegistry {
  ConnectorRegistry._();

  static final Map<String, KnightConnector> _connectors = {
    'google_timeline': TimelineConnector(),
    'standard_finance': FinanceConnector(),
    'standard_health': HealthConnector(),
  };

  /// Registers a connector with the platform.
  static void register(KnightConnector connector) {
    _connectors[connector.metadata.id] = connector;
  }

  /// Returns all registered connectors.
  static List<KnightConnector> get connectors => _connectors.values.toList();

  /// Finds a connector by ID.
  static KnightConnector? get(String id) => _connectors[id];

  /// Auto-discovery for local files.
  static List<KnightConnector> findCapable(dynamic file) {
    // Logic to match file to connectors
    return [];
  }
}
