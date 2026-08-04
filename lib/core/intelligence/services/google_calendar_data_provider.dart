import 'dart:async';
import 'package:flutter/services.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:http/http.dart' as http;
import '../domain/data_provider.dart';
import '../importers/base_parser.dart';
import 'data_ingestion_service.dart';
import '../../internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';
import '../../internal/utils/knight_logger.dart';
import '../domain/knight_memory.dart';
import '../engines/workspace_extraction_engine.dart';
import '../../services/google_auth_service.dart';

class GoogleCalendarDataProvider implements DataProvider {
  GoogleCalendarDataProvider({
    required this.ingestionService,
    required this.authService,
    required this.db,
    required this.workspaceEngine,
    this.onChanged,
  });

  final DataIngestionService ingestionService;
  final GoogleAuthService authService;
  final KnightDatabase db;
  final WorkspaceExtractionEngine workspaceEngine;
  
  @override
  final VoidCallback? onChanged;

  ProviderStatus _status = ProviderStatus.disconnected;
  DateTime? _lastSyncTime;
  String? _lastError;

  @override
  String get id => 'google_calendar_provider';

  @override
  String get name => 'Google Calendar';

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
    _lastError = null;
    onChanged?.call();
    
    try {
      if (authService.currentUser == null) {
        await authService.signIn();
      }

      final requiredScopes = [
        cal.CalendarApi.calendarReadonlyScope,
      ];
      
      final success = await authService.requestScopes(requiredScopes);
      if (success && await authService.hasScopes(requiredScopes)) {
        _status = ProviderStatus.connected;
        _lastError = null;
        KnightLogger.info('Calendar connected');
      } else {
        _status = ProviderStatus.error;
        _lastError = 'Permissions not granted';
      }
    } on PlatformException catch (e) {
      _status = ProviderStatus.error;
      _lastError = e.message ?? e.code;
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = e.toString();
    }
    onChanged?.call();
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
    _status = ProviderStatus.disconnected;
    onChanged?.call();
  }

  @override
  Future<void> syncIncremental() async {
    if (_status != ProviderStatus.connected) return;

    _status = ProviderStatus.syncing;
    final startTime = DateTime.now();
    await _updateMeta('sync_status', 'in_progress');
    await _updateMeta('sync_start_time', startTime.toIso8601String());
    onChanged?.call();
    
    try {
      final headers = await authService.getAuthHeaders();
      final client = _AuthenticatedClient(headers, http.Client());
      final calendarApi = cal.CalendarApi(client);

      KnightLogger.info('Syncing Calendar events...');

      final eventsResponse = await calendarApi.events.list(
        'primary',
        timeMin: _lastSyncTime?.toUtc() ?? DateTime.now().subtract(const Duration(days: 7)).toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
      );

      final List<TimelineEventTableCompanion> timelineEvents = [];
      final List<KnightMemory> workspaceMemories = [];
      
      for (final event in eventsResponse.items ?? []) {
        final start = event.start?.dateTime ?? event.start?.date;
        final end = event.end?.dateTime ?? event.end?.date;
        
        if (start == null || end == null) continue;

        timelineEvents.add(TimelineEventTableCompanion.insert(
          id: event.id ?? 'cal-${DateTime.now().millisecondsSinceEpoch}',
          title: event.summary ?? 'No Title',
          startTime: start,
          endTime: end,
          type: 'meeting',
          metadata: Value(event.description ?? ''),
          sourceProvider: const Value('google_calendar'),
          sourceIdentifier: Value(event.id ?? ''),
        ));

        // Create Workspace Memory for Reasoning
        workspaceMemories.add(workspaceEngine.extractCalendarEvent({
          'id': event.id,
          'summary': event.summary,
          'description': event.description,
          'start': start,
          'end': end,
          'location': event.location,
          'status': event.status,
        }));
      }

      final parsedData = ParsedData(
        transactions: [],
        timelineEvents: timelineEvents,
        healthMetrics: [],
      );
      await ingestionService.ingestCloudData('google_calendar', parsedData);
      await ingestionService.ingestWorkspaceMemories(workspaceMemories);

      _lastSyncTime = DateTime.now();
      _status = ProviderStatus.connected;
      _lastError = null;
      
      await _updateMeta('total_events_indexed', timelineEvents.length.toString());
      await _updateMeta('last_successful_sync', _lastSyncTime!.toIso8601String());
      await _updateMeta('sync_status', 'idle');

    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = _mapApiError(e);
      await _updateMeta('sync_status', 'failed');
      await _updateMeta('last_sync_error', _lastError!);
      KnightLogger.error('Calendar sync failed', error: e);
    }
    onChanged?.call();
  }

  Future<void> _updateMeta(String key, String value) async {
    await db.syncMetadataDao.upsertMetadata(ProviderSyncMetadataTableCompanion.insert(
      id: '$id-$key',
      providerId: id,
      stateKey: key,
      stateValue: value,
      lastUpdated: Value(DateTime.now()),
    ));
  }
}

class _AuthenticatedClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner;

  _AuthenticatedClient(this._headers, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
