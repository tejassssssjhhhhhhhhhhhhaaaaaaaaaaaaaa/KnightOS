import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../domain/data_provider.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';

abstract class BaseDataProvider implements DataProvider {
  BaseDataProvider({
    required this.db,
    this.onChanged,
  });

  final KnightDatabase db;
  @override
  final VoidCallback? onChanged;

  ProviderStatus _status = ProviderStatus.disconnected;
  bool _isEnabled = false;
  DateTime? _lastAttemptedSync;
  DateTime? _lastSuccessfulSync;
  String? _lastError;
  SyncStats _stats = const SyncStats();

  @override
  bool get isHealthy => isEnabled && status == ProviderStatus.connected && lastError == null;

  @override
  bool get isEnabled => _isEnabled;

  @override
  ProviderStatus get status => _status;

  @override
  DateTime? get lastAttemptedSync => _lastAttemptedSync;

  @override
  DateTime? get lastSuccessfulSync => _lastSuccessfulSync;

  @override
  String? get lastError => _lastError;

  @override
  SyncStats get stats => _stats;

  @override
  Future<void> loadState() async {
    try {
      final s = await db.syncMetadataDao.getValue(id, 'status');
      if (s != null) {
        _status = ProviderStatus.values.firstWhere((e) => e.name == s, orElse: () => ProviderStatus.disconnected);
      }
      
      final en = await db.syncMetadataDao.getValue(id, 'is_enabled');
      _isEnabled = en == 'true';

      final la = await db.syncMetadataDao.getValue(id, 'last_attempted_sync');
      if (la != null) _lastAttemptedSync = DateTime.tryParse(la);

      final ls = await db.syncMetadataDao.getValue(id, 'last_successful_sync');
      if (ls != null) _lastSuccessfulSync = DateTime.tryParse(ls);
      
      final error = await db.syncMetadataDao.getValue(id, 'last_error');
      _lastError = (error == null || error.isEmpty) ? null : error;
      
      _stats = await db.syncHistoryDao.getAggregatedStats(id);
    } catch (e) {
      KnightLogger.warn('[PROVIDER] Failed to load state for $id: $e');
    }
    onChanged?.call();
  }

  Future<void> persistState() async {
    try {
      await db.syncMetadataDao.upsertMetadata(ProviderSyncMetadataTableCompanion.insert(
        id: '$id-status', 
        providerId: id, 
        stateKey: 'status', 
        stateValue: _status.name, 
        lastUpdated: Value(DateTime.now()),
      ));
      await db.syncMetadataDao.upsertMetadata(ProviderSyncMetadataTableCompanion.insert(
        id: '$id-is_enabled', 
        providerId: id, 
        stateKey: 'is_enabled', 
        stateValue: _isEnabled.toString(), 
        lastUpdated: Value(DateTime.now()),
      ));
      if (_lastAttemptedSync != null) {
        await db.syncMetadataDao.upsertMetadata(ProviderSyncMetadataTableCompanion.insert(
          id: '$id-last_attempted_sync', 
          providerId: id, 
          stateKey: 'last_attempted_sync', 
          stateValue: _lastAttemptedSync!.toIso8601String(), 
          lastUpdated: Value(DateTime.now()),
        ));
      }
      if (_lastSuccessfulSync != null) {
        await db.syncMetadataDao.upsertMetadata(ProviderSyncMetadataTableCompanion.insert(
          id: '$id-last_successful_sync', 
          providerId: id, 
          stateKey: 'last_successful_sync', 
          stateValue: _lastSuccessfulSync!.toIso8601String(), 
          lastUpdated: Value(DateTime.now()),
        ));
      }
      await db.syncMetadataDao.upsertMetadata(ProviderSyncMetadataTableCompanion.insert(
        id: '$id-last_error', 
        providerId: id, 
        stateKey: 'last_error', 
        stateValue: _lastError ?? '', 
        lastUpdated: Value(DateTime.now()),
      ));
    } catch (e) {
       KnightLogger.warn('[PROVIDER] Failed to persist state for $id: $e');
    }
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    await persistState();
    onChanged?.call();
    if (enabled && (_status == ProviderStatus.disconnected || _status == ProviderStatus.notConfigured)) {
      await connect();
    } else if (!enabled && _status != ProviderStatus.disconnected) {
      await disconnect();
    }
  }

  void updateInternalState({ProviderStatus? status, String? error, SyncStats? stats, DateTime? successful, DateTime? attempted}) {
    if (status != null) _status = status;
    if (error != null) _lastError = error == '' ? null : error;
    if (stats != null) _stats = stats;
    if (successful != null) _lastSuccessfulSync = successful;
    if (attempted != null) _lastAttemptedSync = attempted;
    onChanged?.call();
    persistState();
  }
}
