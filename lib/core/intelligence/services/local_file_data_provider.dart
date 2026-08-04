import 'dart:async';
import 'package:flutter/foundation.dart';
import '../domain/data_provider.dart';
import 'data_ingestion_service.dart';
import 'import_preference_service.dart';

class LocalFileDataProvider implements DataProvider {
  LocalFileDataProvider({
    required this.ingestionService,
    required this.prefsService,
    this.onChanged,
  });

  final DataIngestionService ingestionService;
  final ImportPreferenceService prefsService;
  
  @override
  final VoidCallback? onChanged;

  ProviderStatus _status = ProviderStatus.disconnected;
  DateTime? _lastSyncTime;
  String? _lastError;

  @override
  String get id => 'local_file_provider';

  @override
  String get name => 'Local Files & OneDrive';

  @override
  ProviderStatus get status => _status;

  @override
  DateTime? get lastSyncTime => _lastSyncTime;

  @override
  String? get lastError => _lastError;

  @override
  SyncStats get stats => const SyncStats();

  @override
  Future<void> connect() async {
    _status = ProviderStatus.connected;
    onChanged?.call();
  }

  @override
  Future<void> disconnect() async {
    _status = ProviderStatus.disconnected;
    onChanged?.call();
  }

  @override
  Future<void> syncIncremental() async {
    if (_status != ProviderStatus.connected) {
      _lastError = 'Provider not connected';
      return;
    }

    _status = ProviderStatus.syncing;
    onChanged?.call();
    try {
      await ingestionService.runFullIngestion();
      _lastSyncTime = DateTime.now();
      _status = ProviderStatus.connected;
      _lastError = null;
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = e.toString();
    }
    onChanged?.call();
  }
}
