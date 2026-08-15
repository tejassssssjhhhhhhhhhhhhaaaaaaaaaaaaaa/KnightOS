import 'dart:async';
import 'package:flutter/services.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import '../domain/data_provider.dart';
import '../../internal/storage/backup_service.dart';
import '../../internal/storage/restore_service.dart';
import '../../internal/utils/knight_logger.dart';
import '../domain/knight_memory.dart';
import '../engines/workspace_extraction_engine.dart';
import 'data_ingestion_service.dart';
import '../../services/google_auth_service.dart';
import 'base_data_provider.dart';

class GoogleDriveProvider extends BaseDataProvider {
  GoogleDriveProvider({
    required this.backupService,
    required this.restoreService,
    required this.authService,
    required super.db,
    required this.ingestionService,
    required this.workspaceEngine,
    super.onChanged,
  });

  final BackupService backupService;
  final RestoreService restoreService;
  final GoogleAuthService authService;
  final DataIngestionService ingestionService;
  final WorkspaceExtractionEngine workspaceEngine;

  @override
  String get id => 'google_drive_api';

  @override
  String get name => 'Google Drive Backup';

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
        drive.DriveApi.driveAppdataScope,
        drive.DriveApi.driveFileScope,
      ];

      final success = await authService.requestScopes(requiredScopes);
      if (success && await authService.hasScopes(requiredScopes)) {
        updateInternalState(status: ProviderStatus.connected, error: '');
        KnightLogger.info('Drive connected');
      } else {
        updateInternalState(status: ProviderStatus.requiresAuthorization, error: 'Drive permissions not granted');
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
      if (err.status == 403) return 'Drive API not enabled';
      if (err.status == 401) return 'Session expired. Re-authenticate.';
      return 'Google Drive Error: ${err.message}';
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
      final headers = await authService.getAuthHeaders();
      final client = _AuthenticatedClient(headers, http.Client());
      final driveApi = drive.DriveApi(client);

      KnightLogger.info('Indexing Google Drive files...');

      final filesResponse = await driveApi.files.list(
        pageSize: 100,
        $fields: 'files(id, name, mimeType, modifiedTime, size, webViewLink)',
        q: "trashed = false",
      );

      final List<KnightMemory> workspaceMemories = [];
      for (final file in filesResponse.files ?? []) {
        workspaceMemories.add(workspaceEngine.extractDriveFile({
          'id': file.id,
          'name': file.name,
          'mimeType': file.mimeType,
          'modifiedTime': file.modifiedTime,
          'webViewLink': file.webViewLink,
          'size': file.size,
        }));
      }

      await ingestionService.ingestWorkspaceMemories(workspaceMemories);

      // Perform Backup as well
      await backupService.createBackupArchive('user-identity-secret');
      
      updateInternalState(
        status: ProviderStatus.connected, 
        successful: DateTime.now(), 
        error: '', 
        stats: SyncStats(fetched: workspaceMemories.length, created: workspaceMemories.length)
      );
    } catch (e) {
      updateInternalState(status: ProviderStatus.error, error: _mapApiError(e));
      KnightLogger.error('Drive sync failed', error: e);
    }
  }

  Future<void> restore() async {
    if (status != ProviderStatus.connected) throw Exception('Drive not connected');
    await restoreService.restoreFromCloud('google_drive');
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
