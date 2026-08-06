import 'dart:async';
import 'package:flutter/foundation.dart';
import '../domain/data_provider.dart';
import 'tasks_sync_orchestrator.dart';
import '../../services/google_auth_service.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';

class GoogleTasksProvider implements DataProvider {
  GoogleTasksProvider({
    required this.authService,
    required this.db,
    this.onChanged,
  });

  final GoogleAuthService authService;
  final KnightDatabase db;
  
  @override
  final VoidCallback? onChanged;

  ProviderStatus _status = ProviderStatus.disconnected;
  DateTime? _lastSyncTime;
  String? _lastError;

  @override
  String get id => 'google_tasks_api';

  @override
  String get name => 'Google Tasks';

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
      if (authService.currentUser == null) {
        await authService.signIn();
      }

      final requiredScopes = [
        'https://www.googleapis.com/auth/tasks.readonly',
      ];

      final success = await authService.requestScopes(requiredScopes);
      if (success && await authService.hasScopes(requiredScopes)) {
        _status = ProviderStatus.connected;
        _lastError = null;
        KnightLogger.info('Tasks connected');
      } else {
        _status = ProviderStatus.error;
        _lastError = 'Permissions not granted';
      }
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
    try {
      final orchestrator = TasksSyncOrchestrator(db: db, authService: authService);
      await orchestrator.executeSync();

      _lastSyncTime = DateTime.now();
      _status = ProviderStatus.connected;
      _lastError = null;
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = e.toString();
      KnightLogger.error('Tasks sync failed', error: e);
    }
    onChanged?.call();
  }
}
