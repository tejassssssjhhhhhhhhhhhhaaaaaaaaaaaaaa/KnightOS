import 'dart:async';
import 'package:flutter/foundation.dart';
import '../domain/data_provider.dart';
import '../../internal/storage/drift/knight_database.dart';
import 'device_intelligence_service.dart';
import '../../internal/utils/knight_logger.dart';

class GalaxyWatchProvider implements DataProvider {
  GalaxyWatchProvider({
    required this.db,
    required this.deviceIntelligenceService,
    this.onChanged,
  });

  final KnightDatabase db;
  final DeviceIntelligenceService deviceIntelligenceService;
  
  @override
  final VoidCallback? onChanged;

  ProviderStatus _status = ProviderStatus.disconnected;
  DateTime? _lastSyncTime;
  String? _lastError;

  @override
  String get id => 'galaxy_watch_provider';

  @override
  String get name => 'Galaxy Watch';

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
    _status = ProviderStatus.syncing;
    onChanged?.call();
    try {
      // Simulation for foundation
      await Future.delayed(const Duration(seconds: 1));
      _status = ProviderStatus.connected;
      KnightLogger.info('Galaxy Watch connected');
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = e.toString();
    }
    onChanged?.call();
  }

  @override
  Future<void> disconnect() async {
    _status = ProviderStatus.disconnected;
    onChanged?.call();
  }

  @override
  Future<void> syncIncremental() async {
    if (_status != ProviderStatus.connected) return;
    _status = ProviderStatus.syncing;
    onChanged?.call();
    
    // Simulate battery/watch health update in Device Mesh
    await deviceIntelligenceService.recordDeviceHealth(
       deviceId: 'galaxy-watch-7',
       batteryLevel: 88,
       isCharging: false,
       networkType: 'bluetooth',
    );

    _lastSyncTime = DateTime.now();
    _status = ProviderStatus.connected;
    onChanged?.call();
  }
}
