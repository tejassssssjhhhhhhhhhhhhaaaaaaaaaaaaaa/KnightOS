import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import '../../domain/connectors/i_connector.dart';
import '../../domain/connectors/connector_manifest.dart';
import '../../domain/connectors/connector_health.dart';
import '../../domain/models/calendar_sync_state.dart';
import '../../intelligence/normalization_pipeline.dart';
import '../../intelligence/normalizers/google_calendar_normalizer.dart';
import '../../services/google_auth_service.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import '../../storage/privacy_vault.dart';

class GoogleCalendarConnector implements IConnector {
  GoogleCalendarConnector({
    required this.pipeline,
    required this.syncMetadataDao,
    GoogleAuthService? authService,
    GoogleCalendarNormalizer? normalizer,
  })  : _authService = authService ?? GoogleAuthService.instance,
        _normalizer = normalizer ?? GoogleCalendarNormalizer();

  final NormalizationPipeline pipeline;
  final SyncMetadataDao syncMetadataDao;
  final GoogleAuthService _authService;
  final GoogleCalendarNormalizer _normalizer;

  final StreamController<ConnectorStatus> _statusController = StreamController<ConnectorStatus>.broadcast();
  ConnectorStatus _status = ConnectorStatus.registered;

  static const String _providerId = 'google_calendar';
  static const String _syncStateKey = 'sync_state';

  @override
  ConnectorManifest get manifest => const ConnectorManifest(
        id: _providerId,
        name: 'Google Calendar',
        version: '1.0.0',
        vendor: 'Google',
        supportedPlatforms: ['android', 'ios'],
        authMethod: AuthMethod.oAuth2,
        supportedCapabilities: ['calendar'],
        syncModes: [SyncMode.manual, SyncMode.scheduled],
        privacyClassification: PrivacyClassification.personal,
      );

  @override
  ConnectorStatus get status => _status;

  @override
  Stream<ConnectorStatus> get onStatusChanged => _statusController.stream;

  void _updateStatus(ConnectorStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }

  @override
  Future<ConnectorHealth> getHealth() async {
    final state = await _getSyncState();
    return ConnectorHealth(
      apiStatus: state.healthStatus.name,
      version: manifest.version,
      lastSyncAt: state.lastSyncAt,
      nextSyncAt: state.nextSyncAt,
      failureCount: state.failedCount,
    );
  }

  @override
  Future<ConnectorResult<void>> authorize() async {
    try {
      final success = await _authService.requestScopes([
        'https://www.googleapis.com/auth/calendar.readonly',
        'https://www.googleapis.com/auth/calendar.events',
      ]);
      
      if (success) {
        _updateStatus(ConnectorStatus.authorized);
        return const ConnectorResult(status: ConnectorStatus.completed);
      } else {
        return const ConnectorResult(
          status: ConnectorStatus.failed,
          error: 'User denied calendar scopes',
          errorCategory: ErrorCategory.authentication,
        );
      }
    } catch (e) {
      return ConnectorResult(
        status: ConnectorStatus.failed,
        error: e.toString(),
        errorCategory: ErrorCategory.internal,
      );
    }
  }

  @override
  Future<ConnectorResult<void>> connect() async {
    if (await _authService.hasScopes(['https://www.googleapis.com/auth/calendar.readonly'])) {
      _updateStatus(ConnectorStatus.connected);
      return const ConnectorResult(status: ConnectorStatus.completed);
    }
    return const ConnectorResult(
      status: ConnectorStatus.failed,
      error: 'Missing required scopes',
      errorCategory: ErrorCategory.authentication,
    );
  }

  @override
  Future<ConnectorResult<int>> sync({bool fullSync = false}) async {
    _updateStatus(ConnectorStatus.syncing);
    final state = await _getSyncState();
    int totalProcessed = 0;
    
    try {
      final client = await _authService.getAuthenticatedClient();
      
      // 1. Fetch Calendars
      final calendarIds = await _fetchEnabledCalendars(client);
      
      var newState = state.copyWith(
        healthStatus: CalendarHealthStatus.healthy,
        lastError: null,
      );

      for (final calendarId in calendarIds) {
        final result = await _syncCalendar(client, calendarId, fullSync: fullSync);
        totalProcessed += result.count;
        
        newState = newState.copyWith(
          importedCount: newState.importedCount + result.imported,
          updatedCount: newState.updatedCount + result.updated,
          deletedCount: newState.deletedCount + result.deleted,
        );
      }

      newState = newState.copyWith(
        lastSyncAt: DateTime.now(),
        nextSyncAt: DateTime.now().add(const Duration(hours: 1)),
      );

      await _saveSyncState(newState);
      _updateStatus(ConnectorStatus.completed);
      
      return ConnectorResult(status: ConnectorStatus.completed, data: totalProcessed);
    } catch (e) {
      KnightLogger.error('[GCAL] Sync failed', error: e);
      final failedState = state.copyWith(
        healthStatus: CalendarHealthStatus.failing,
        failedCount: state.failedCount + 1,
        lastError: e.toString(),
      );
      await _saveSyncState(failedState);
      _updateStatus(ConnectorStatus.failed);
      return ConnectorResult(
        status: ConnectorStatus.failed,
        error: e.toString(),
        errorCategory: ErrorCategory.network,
      );
    }
  }

  Future<List<String>> _fetchEnabledCalendars(http.Client client) async {
    final response = await client.get(Uri.parse('https://www.googleapis.com/calendar/v3/users/me/calendarList'));
    if (response.statusCode != 200) throw Exception('Failed to fetch calendar list');
    
    final data = json.decode(response.body);
    final items = data['items'] as List;
    
    return items
        .where((c) => c['selected'] == true || c['primary'] == true)
        .map((c) => c['id'] as String)
        .toList();
  }

  Future<_SyncBatchResult> _syncCalendar(http.Client client, String calendarId, {bool fullSync = false}) async {
    final syncTokenKey = 'sync_token_$calendarId';
    String? syncToken = fullSync ? null : await syncMetadataDao.getValue(_providerId, syncTokenKey);
    
    String url = 'https://www.googleapis.com/calendar/v3/calendars/$calendarId/events?maxResults=250';
    if (syncToken != null) {
      url += '&syncToken=$syncToken';
    }

    int imported = 0;
    int updated = 0;
    int deleted = 0;

    final response = await client.get(Uri.parse(url));
    
    if (response.statusCode == 410) {
      return await _syncCalendar(client, calendarId, fullSync: true);
    }
    
    if (response.statusCode != 200) throw Exception('Failed to sync events for $calendarId');
    
    final data = json.decode(response.body);
    final items = data['items'] as List;
    
    for (final item in items) {
      if (item['status'] == 'cancelled') {
        deleted++;
        continue;
      }

      final normalized = _normalizer.normalize(item, calendarId);
      final caid = _normalizer.generateCaid(normalized);
      
      await pipeline.process(
        connectorId: _providerId,
        type: 'calendar#event',
        rawData: normalized,
        caid: caid,
        immediateProjection: false, 
      );
      
      if (item['sequence'] == 0) {
        imported++;
      } else {
        updated++;
      }
    }

    final nextSyncToken = data['nextSyncToken'];
    if (nextSyncToken != null) {
      await syncMetadataDao.upsertMetadata(ProviderSyncMetadataTableCompanion(
        providerId: const Value(_providerId),
        stateKey: Value(syncTokenKey),
        stateValue: Value(nextSyncToken),
      ));
    }

    return _SyncBatchResult(
      count: items.length,
      imported: imported,
      updated: updated,
      deleted: deleted,
    );
  }

  @override
  Future<void> disconnect() async {
    _updateStatus(ConnectorStatus.disabled);
  }

  @override
  Future<void> revoke() async {
    await _authService.signOut();
    _updateStatus(ConnectorStatus.revoked);
  }

  Future<CalendarSyncState> _getSyncState() async {
    final value = await syncMetadataDao.getValue(_providerId, _syncStateKey);
    if (value == null) return CalendarSyncState(providerId: _providerId);
    return CalendarSyncState.fromJson(_providerId, json.decode(value));
  }

  Future<void> _saveSyncState(CalendarSyncState state) async {
    await syncMetadataDao.upsertMetadata(ProviderSyncMetadataTableCompanion(
      providerId: const Value(_providerId),
      stateKey: const Value(_syncStateKey),
      stateValue: Value(json.encode(state.toJson())),
    ));
  }
}

class _SyncBatchResult {
  _SyncBatchResult({
    required this.count,
    required this.imported,
    required this.updated,
    required this.deleted,
  });
  final int count;
  final int imported;
  final int updated;
  final int deleted;
}
