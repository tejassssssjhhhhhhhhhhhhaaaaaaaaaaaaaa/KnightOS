import 'dart:async';
import 'package:flutter/services.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import '../domain/data_provider.dart';
import 'data_ingestion_service.dart';
import '../../internal/utils/knight_logger.dart';
import '../engines/workspace_extraction_engine.dart';
import '../../services/google_auth_service.dart';
import 'calendar_sync_orchestrator.dart';
import 'base_data_provider.dart';
import 'import_preference_service.dart';

class GoogleCalendarDataProvider extends BaseDataProvider {
  GoogleCalendarDataProvider({
    required this.ingestionService,
    required this.authService,
    required super.db,
    required this.workspaceEngine,
    required this.prefs,
    super.onChanged,
  });

  final DataIngestionService ingestionService;
  final GoogleAuthService authService;
  final WorkspaceExtractionEngine workspaceEngine;
  final ImportPreferenceService prefs;

  @override
  String get id => 'google_calendar_api';

  @override
  String get name => 'Google Calendar';

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
        cal.CalendarApi.calendarReadonlyScope,
      ];
      
      final success = await authService.requestScopes(requiredScopes);
      if (success && await authService.hasScopes(requiredScopes)) {
        updateInternalState(status: ProviderStatus.connected, error: '');
        KnightLogger.info('Calendar connected');
      } else {
        updateInternalState(status: ProviderStatus.requiresAuthorization, error: 'Calendar permissions not granted');
      }
    } on PlatformException catch (e) {
      updateInternalState(status: ProviderStatus.error, error: e.message ?? e.code);
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: e.toString());
    }
  }

  String _mapApiError(Object e) {
    final dynamic err = e;
    try {
      if (err.status == 403) return 'Calendar API not enabled';
      if (err.status == 401) return 'Session expired. Re-authenticate.';
      return 'Google Calendar Error: ${err.message}';
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
      final orchestrator = CalendarSyncOrchestrator(db: db, authService: authService, prefs: prefs);
      await orchestrator.runSync();

      updateInternalState(
        status: ProviderStatus.connected, 
        successful: DateTime.now(), 
        error: '', 
        stats: orchestrator.stats
      );

    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: _mapApiError(e));
      KnightLogger.error('Calendar sync failed', error: e);
    }
  }
}
