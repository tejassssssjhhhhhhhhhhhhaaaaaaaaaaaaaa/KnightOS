import 'dart:async';
import 'package:flutter/foundation.dart';

/// Status of a data provider's connection and synchronization.
enum ProviderStatus { connected, disconnected, error, syncing }

/// Statistics for the synchronization process.
class SyncStats {
  final int imported;
  final int updated;
  final int duplicatesPrevented;
  final int failures;

  const SyncStats({
    this.imported = 0,
    this.updated = 0,
    this.duplicatesPrevented = 0,
    this.failures = 0,
  });
}

/// Generic interface for all data sources (Local, Cloud, API).
abstract class DataProvider {
  /// Unique ID for this provider (e.g., 'onedrive_local', 'gmail_api').
  String get id;

  /// Display name for the UI.
  String get name;

  /// Current health/connection status.
  ProviderStatus get status;

  /// Last successful synchronization timestamp.
  DateTime? get lastSyncTime;

  /// Human-readable error message if status is 'error'.
  String? get lastError;

  /// Current sync statistics.
  SyncStats get stats;

  /// Optional callback to notify the registry of state changes.
  VoidCallback? get onChanged;

  /// Establishes connection/permission to the source.
  Future<void> connect();

  /// Terminates connection and cleans up local resources.
  Future<void> disconnect();

  /// Performs an incremental synchronization.
  /// Only new or modified data since [lastSyncTime] should be processed.
  Future<void> syncIncremental();
}
