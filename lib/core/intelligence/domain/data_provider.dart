import 'dart:async';
import 'package:flutter/foundation.dart';

/// Status of a data provider's connection and synchronization.
enum ProviderStatus {
  /// The source is connected and functional.
  connected,

  /// The source is explicitly disconnected by the user or system.
  disconnected,

  /// A technical error occurred during connection or sync.
  error,

  /// A synchronization process is currently active.
  syncing,

  /// The source requires user interaction for OAuth or permissions.
  requiresAuthorization,

  /// The source has not been set up or configured yet.
  notConfigured,
}

/// Statistics for the synchronization process.
class SyncStats {
  final int fetched;
  final int created;
  final int updated;
  final int skipped;
  final int failed;

  const SyncStats({
    this.fetched = 0,
    this.created = 0,
    this.updated = 0,
    this.skipped = 0,
    this.failed = 0,
  });
}

/// Generic interface for all data sources (Local, Cloud, API).
abstract class DataProvider {
  /// Unique ID for this provider (e.g., 'onedrive_local', 'gmail_api').
  String get id;

  /// Display name for the UI.
  String get name;

  /// Whether the source is enabled by the user.
  /// Even if enabled, it might be in an 'error' or 'disconnected' state.
  bool get isEnabled;

  /// Current health/connection status.
  ProviderStatus get status;

  /// Convenience getter for high-level health.
  bool get isHealthy => isEnabled && status == ProviderStatus.connected && lastError == null;

  /// Last attempted synchronization timestamp.
  DateTime? get lastAttemptedSync;

  /// Last successful synchronization timestamp.
  DateTime? get lastSuccessfulSync;

  /// Human-readable error message if status is 'error'.
  String? get lastError;

  /// Current sync statistics.
  SyncStats get stats;

  /// Optional callback to notify the registry of state changes.
  VoidCallback? get onChanged;

  /// Loads persisted state from storage.
  Future<void> loadState();

  /// Establishes connection/permission to the source.
  Future<void> connect();

  /// Terminates connection and cleans up local resources.
  Future<void> disconnect();

  /// Sets the enabled state of the provider.
  Future<void> setEnabled(bool enabled);

  /// Performs an incremental synchronization.
  /// Only new or modified data since [lastSyncTime] should be processed.
  Future<void> syncIncremental();
}
