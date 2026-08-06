import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:http/http.dart' as http;
import 'sync_orchestrator.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import '../../services/google_auth_service.dart';

class CalendarSyncOrchestrator extends SyncOrchestrator {
  CalendarSyncOrchestrator({
    required super.db,
    required this.authService,
  }) : super(providerId: 'google_calendar_api');

  final GoogleAuthService authService;

  @override
  Future<void> executeSync() async {
    final stopwatch = Stopwatch()..start();
    await updateCursor('sync_status', 'in_progress');

    try {
      final headers = await authService.getAuthHeaders();
      final client = _AuthenticatedClient(headers, http.Client());
      final calendarApi = cal.CalendarApi(client);

      final lastSyncTimeStr = await getCursor('last_sync_time');
      final lastSyncTime = lastSyncTimeStr != null ? DateTime.parse(lastSyncTimeStr) : null;

      // Historical vs Incremental
      if (lastSyncTime == null) {
        await _runHistoricalSync(calendarApi);
      } else {
        await _runIncrementalSync(calendarApi, lastSyncTime);
      }

      await updateCursor('last_sync_time', DateTime.now().toIso8601String());
      await updateCursor('sync_status', 'idle');
      KnightLogger.info('[CALENDAR] Sync completed in ${stopwatch.elapsed.inSeconds}s');
    } catch (e) {
      await updateCursor('sync_status', 'failed');
      await updateCursor('last_sync_error', e.toString());
      rethrow;
    }
  }

  Future<void> _runHistoricalSync(cal.CalendarApi api) async {
    KnightLogger.info('[CALENDAR] Starting historical sync (last 5 years)');
    final timeMin = DateTime.now().subtract(const Duration(days: 365 * 5)).toUtc();
    await _fetchAndProcessEvents(api, timeMin: timeMin);
  }

  Future<void> _runIncrementalSync(cal.CalendarApi api, DateTime lastSync) async {
    KnightLogger.info('[CALENDAR] Starting incremental sync since $lastSync');
    await _fetchAndProcessEvents(api, timeMin: lastSync.toUtc());
  }

  Future<void> _fetchAndProcessEvents(cal.CalendarApi api, {required DateTime timeMin}) async {
    String? pageToken;
    int processed = 0;

    do {
      final events = await api.events.list(
        'primary',
        timeMin: timeMin,
        singleEvents: true,
        orderBy: 'startTime',
        pageToken: pageToken,
        maxResults: 250,
      );

      if (events.items != null && events.items!.isNotEmpty) {
        for (final event in events.items!) {
          await _processEvent(event);
          processed++;
        }
      }

      pageToken = events.nextPageToken;
    } while (pageToken != null);

    KnightLogger.info('[CALENDAR] Processed $processed events');
  }

  Future<void> _processEvent(cal.Event event) async {
    final start = event.start?.dateTime ?? event.start?.date;
    if (start == null) return;

    final accountEmail = authService.currentUser?.email ?? 'unknown';

    await db.googleResourceDao.upsertResource(GoogleResourceTableCompanion.insert(
      id: event.id!,
      resourceType: 'calendar',
      title: event.summary ?? 'No Title',
      resourceDate: start,
      metadata: Value(jsonEncode({
        'description': event.description,
        'location': event.location,
        'status': event.status,
        'htmlLink': event.htmlLink,
      })),
      originAccount: accountEmail,
      rawMetadata: Value(jsonEncode(event.toJson())),
      syncStatus: const Value('synced'),
    ));

    // Also update Timeline
    await db.timelineDao.insertEvents([
      TimelineEventTableCompanion.insert(
        id: 'cal-${event.id}',
        title: event.summary ?? 'No Title',
        startTime: start,
        endTime: event.end?.dateTime ?? event.end?.date ?? start,
        type: 'meeting',
        metadata: Value(event.description ?? ''),
        originProviderId: const Value('google_calendar_api'),
        originResourceId: Value(event.id),
      )
    ]);
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
