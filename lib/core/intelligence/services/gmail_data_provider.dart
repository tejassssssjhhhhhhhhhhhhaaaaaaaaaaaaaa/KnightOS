import 'package:flutter/services.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import '../domain/data_provider.dart';
import '../engines/email_extraction_engine.dart';
import '../../internal/utils/knight_logger.dart';
import '../../services/google_auth_service.dart';
import '../../internal/storage/drift/knight_database.dart';
import 'gmail_sync_orchestrator.dart';

class GmailDataProvider implements DataProvider {
  GmailDataProvider({
    required this.extractionEngine,
    required this.authService,
    required this.db,
    this.onChanged,
  });

  final EmailExtractionEngine extractionEngine;
  final GoogleAuthService authService;
  final KnightDatabase db;
  
  @override
  final VoidCallback? onChanged;

  ProviderStatus _status = ProviderStatus.disconnected;
  DateTime? _lastSyncTime;
  String? _lastError;

  @override
  String get id => 'gmail_api';

  @override
  String get name => 'Gmail Intelligence';

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
    // P0: Auto-clear stale errors
    if (_status == ProviderStatus.error) {
       _lastError = null;
    }
    
    _status = ProviderStatus.syncing;
    onChanged?.call();
    
    try {
      if (authService.currentUser == null) {
        KnightLogger.info('[GMAIL] Triggering base sign-in...');
        final account = await authService.signIn();
        if (account == null) {
          _status = ProviderStatus.disconnected;
          _lastError = 'Authentication cancelled';
          onChanged?.call();
          return;
        }
      }

      final requiredScopes = [
        gmail.GmailApi.gmailReadonlyScope,
        'https://www.googleapis.com/auth/gmail.metadata',
      ];

      KnightLogger.info('[GMAIL] Requesting incremental scopes: $requiredScopes');
      final success = await authService.requestScopes(requiredScopes);
      
      if (success) {
        if (await authService.hasScopes(requiredScopes)) {
          _status = ProviderStatus.connected;
          _lastError = null; // Clear error on success
          KnightLogger.info('[GMAIL] Provider successfully connected');
        } else {
          _status = ProviderStatus.error;
          _lastError = 'Permissions not granted';
        }
      } else {
        _status = ProviderStatus.error;
        _lastError = 'Scope request denied';
      }
    } on PlatformException catch (e) {
      _status = ProviderStatus.error;
      _lastError = _mapPlatformError(e);
      KnightLogger.error('[GMAIL] Platform error during connect', error: e);
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = 'Connection failed: $e';
      KnightLogger.error('[GMAIL] Unknown error during connect', error: e);
    }
    
    onChanged?.call();
  }

  String _mapPlatformError(PlatformException e) {
    if (e.code == 'sign_in_failed') return 'Google services unavailable';
    if (e.code == 'network_error') return 'Network connection lost';
    if (e.code == 'access_denied') return 'Permission denied';
    return e.message ?? 'Platform error (${e.code})';
  }

  String _mapApiError(Object e) {
    final dynamic err = e;
    try {
      if (err.status == 403) return 'API not enabled in Cloud Console';
      if (err.status == 401) return 'Session expired. Re-authenticate.';
      if (err.status == 429) return 'Quota exceeded. Wait 60s.';
      return 'Google API Error: ${err.message}';
    } catch (_) {
      return e.toString();
    }
  }

  @override
  Future<void> disconnect() async {
    _status = ProviderStatus.disconnected;
    _lastError = null;
    onChanged?.call();
  }

  @override
  Future<void> syncIncremental() async {
    if (_status != ProviderStatus.connected) return;

    _status = ProviderStatus.syncing;
    onChanged?.call();
    try {
      final orchestrator = GmailSyncOrchestrator(db: db, authService: authService);
      await orchestrator.runSync();

      _lastSyncTime = DateTime.now();
      _status = ProviderStatus.connected;
      _lastError = null; // Sync worked, clear any previous 403s etc.
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = _mapApiError(e);
      KnightLogger.error('Gmail sync failed', error: e);
    }
    onChanged?.call();
  }
}
