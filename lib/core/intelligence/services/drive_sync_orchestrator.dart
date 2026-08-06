import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'sync_orchestrator.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import '../../services/google_auth_service.dart';

class DriveSyncOrchestrator extends SyncOrchestrator {
  DriveSyncOrchestrator({
    required super.db,
    required this.authService,
  }) : super(providerId: 'google_drive_api');

  final GoogleAuthService authService;

  @override
  Future<void> executeSync() async {
    final stopwatch = Stopwatch()..start();
    await updateCursor('sync_status', 'in_progress');

    try {
      final headers = await authService.getAuthHeaders();
      final client = _AuthenticatedClient(headers, http.Client());
      final driveApi = drive.DriveApi(client);

      await _runFullScan(driveApi);

      await updateCursor('last_sync_time', DateTime.now().toIso8601String());
      await updateCursor('sync_status', 'idle');
      KnightLogger.info('[DRIVE] Sync completed in ${stopwatch.elapsed.inSeconds}s');
    } catch (e) {
      await updateCursor('sync_status', 'failed');
      await updateCursor('last_sync_error', e.toString());
      rethrow;
    }
  }

  Future<void> _runFullScan(drive.DriveApi api) async {
    String? nextPageToken;
    int processed = 0;

    do {
      final response = await api.files.list(
        pageSize: 100,
        $fields: 'nextPageToken, files(id, name, mimeType, modifiedTime, size, webViewLink, owners)',
        q: "trashed = false",
        pageToken: nextPageToken,
      );

      if (response.files != null) {
        for (final file in response.files!) {
          await _processFile(file);
          processed++;
        }
      }

      nextPageToken = response.nextPageToken;
    } while (nextPageToken != null);

    KnightLogger.info('[DRIVE] Indexed $processed files');
  }

  Future<void> _processFile(drive.File file) async {
    if (file.id == null) return;

    final accountEmail = authService.currentUser?.email ?? 'unknown';

    await db.googleResourceDao.upsertResource(GoogleResourceTableCompanion.insert(
      id: file.id!,
      resourceType: 'drive',
      title: file.name ?? 'Untitled',
      resourceDate: file.modifiedTime ?? DateTime.now(),
      metadata: Value(jsonEncode({
        'mimeType': file.mimeType,
        'size': file.size,
        'webViewLink': file.webViewLink,
        'owners': file.owners?.map((o) => o.emailAddress).toList(),
      })),
      originAccount: accountEmail,
      rawMetadata: Value(jsonEncode(file.toJson())),
      syncStatus: const Value('synced'),
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
