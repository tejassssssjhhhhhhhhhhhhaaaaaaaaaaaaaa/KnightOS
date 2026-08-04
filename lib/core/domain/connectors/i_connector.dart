import 'connector_manifest.dart';
import 'connector_health.dart';
import 'dart:async';

enum ConnectorStatus {
  registered,
  installed,
  configured,
  authorized,
  connected,
  syncing,
  normalizing,
  completed,
  disabled,
  revoked,
  failed,
  reconnecting,
}

/// A standardized result from a connector operation.
class ConnectorResult<T> {
  const ConnectorResult({
    required this.status,
    this.data,
    this.error,
    this.errorCategory = ErrorCategory.none,
  });

  final ConnectorStatus status;
  final T? data;
  final String? error;
  final ErrorCategory errorCategory;

  bool get isSuccess => status == ConnectorStatus.completed || status == ConnectorStatus.connected;
}

/// Interface for all KnightOS external data connectors.
abstract class IConnector {
  /// Unique manifest defining the connector's metadata.
  ConnectorManifest get manifest;

  /// Current operational status.
  ConnectorStatus get status;

  /// Stream of status changes.
  Stream<ConnectorStatus> get onStatusChanged;

  /// Returns the current health metrics.
  Future<ConnectorHealth> getHealth();

  /// Starts the authentication flow.
  Future<ConnectorResult<void>> authorize();

  /// Connects to the provider using stored credentials.
  Future<ConnectorResult<void>> connect();

  /// Triggers a synchronization cycle.
  Future<ConnectorResult<int>> sync({bool fullSync = false});

  /// Disconnects and cleans up resources.
  Future<void> disconnect();

  /// Revokes authorization and deletes local credentials.
  Future<void> revoke();
}
