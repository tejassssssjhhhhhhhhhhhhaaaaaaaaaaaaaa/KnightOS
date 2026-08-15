import 'dart:async';
import 'package:flutter/services.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import '../domain/data_provider.dart';
import '../engines/email_extraction_engine.dart';
import '../../internal/utils/knight_logger.dart';
import '../../services/google_auth_service.dart';
import 'gmail_sync_orchestrator.dart';
import 'base_data_provider.dart';

class GmailDataProvider extends BaseDataProvider {
  GmailDataProvider({
    required this.extractionEngine,
    required this.authService,
    required super.db,
    super.onChanged,
  });

  final EmailExtractionEngine extractionEngine;
  final GoogleAuthService authService;

  @override
  String get id => 'gmail_api';

  @override
  String get name => 'Gmail Intelligence';

  @override
  Future<void> connect() async {
    updateInternalState(status: ProviderStatus.syncing, error: '');
    
    try {
      if (authService.currentUser == null) {
        final account = await authService.signIn();
        if (account == null) {
          updateInternalState(status: ProviderStatus.requiresAuthorization, error: 'Authentication required');
          return;
        }
      }

      final requiredScopes = [
        gmail.GmailApi.gmailReadonlyScope,
        'https://www.googleapis.com/auth/gmail.metadata',
      ];

      final success = await authService.requestScopes(requiredScopes);
      
      if (success) {
        if (await authService.hasScopes(requiredScopes)) {
          updateInternalState(status: ProviderStatus.connected, error: '');
          KnightLogger.info('[GMAIL] Provider successfully connected');
        } else {
          updateInternalState(status: ProviderStatus.requiresAuthorization, error: 'Gmail permissions not granted');
        }
      } else {
        updateInternalState(status: ProviderStatus.requiresAuthorization, error: 'Permissions denied by user');
      }
    } on PlatformException catch (e) {
      updateInternalState(status: ProviderStatus.error, error: _mapPlatformError(e));
      KnightLogger.error('[GMAIL] Platform error during connect', error: e);
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: 'Connection failed: $e');
      KnightLogger.error('[GMAIL] Unknown error during connect', error: e);
    }
  }

  String _mapPlatformError(PlatformException e) {
    if (e.code == 'sign_in_failed') return 'Google services unavailable';
    if (e.code == 'network_error') return 'Network connection lost';
    if (e.code == 'access_denied') return 'Permission denied';
    return e.message ?? e.code;
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
    updateInternalState(status: ProviderStatus.disconnected, error: '');
  }

  @override
  Future<void> syncIncremental() async {
    if (status != ProviderStatus.connected) return;

    updateInternalState(status: ProviderStatus.syncing, attempted: DateTime.now());
    try {
      final orchestrator = GmailSyncOrchestrator(db: db, authService: authService);
      await orchestrator.runSync();

      updateInternalState(
        status: ProviderStatus.connected, 
        successful: DateTime.now(), 
        error: '', 
        stats: orchestrator.stats
      );
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: _mapApiError(e));
      KnightLogger.error('Gmail sync failed', error: e);
    }
  }
}
