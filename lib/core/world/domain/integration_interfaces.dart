import 'package:flutter/foundation.dart';

/// Contract for every external service connected to KnightOS.
abstract class ExternalIntegration {
  /// Unique identifier for the integration (e.g. "google-calendar").
  String get id;

  /// Human-readable name.
  String get name;

  /// Current connection status.
  Future<IntegrationStatus> getStatus();

  /// Synchronizes data from the external source into the Memory Engine.
  Future<void> sync();

  /// Revokes access and cleans up local metadata.
  Future<void> disconnect();
}

/// Represents the health of an external connection.
enum IntegrationStatus { connected, disconnected, error, expired, syncing }

/// Metadata for configuring an integration.
@immutable
class IntegrationConfig {
  const IntegrationConfig({
    required this.id,
    required this.enabled,
    required this.permissions,
    this.lastSync,
  });

  final String id;
  final bool enabled;
  final List<String> permissions;
  final DateTime? lastSync;
}
