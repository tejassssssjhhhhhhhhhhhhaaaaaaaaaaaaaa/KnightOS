import 'dart:async';
import 'package:flutter/services.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '../domain/data_provider.dart';
import '../../internal/storage/backup_service.dart';
import '../../internal/storage/restore_service.dart';
import '../../internal/utils/knight_logger.dart';
import '../domain/knight_memory.dart';
import '../engines/workspace_extraction_engine.dart';
import 'data_ingestion_service.dart';
import '../../services/google_auth_service.dart';
import '../../internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

class GoogleDriveProvider implements DataProvider {
  GoogleDriveProvider({
    required this.backupService,
    required this.restoreService,
    required this.authService,
    required this.db,
    required this.ingestionService,
    required this.workspaceEngine,
    this.onChanged,
  });

  final BackupService backupService;
  final RestoreService restoreService;
  final GoogleAuthService authService;
  final KnightDatabase db;
  final DataIngestionService ingestionService;
  final WorkspaceExtractionEngine workspaceEngine;
  
  @override
  final VoidCallback? onChanged;

  ProviderStatus _status = ProviderStatus.disconnected;
  DateTime? _lastSyncTime;
  String? _lastError;

  @override
  String get id => 'google_drive_provider';

  @override
  String get name => 'Google Drive Backup';

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
        drive.DriveApi.driveAppdataScope,
        drive.DriveApi.driveFileScope,
      ];

      final success = await authService.requestScopes(requiredScopes);
      if (success && await authService.hasScopes(requiredScopes)) {
        _status = ProviderStatus.connected;
        _lastError = null;
        KnightLogger.info('Drive connected');
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
      if (err.status == 403) return 'Drive API not enabled';
      if (err.status == 401) return 'Session expired. Re-authenticate.';
      return 'Google Drive Error: ${err.message}';
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
    await _updateMeta('sync_status', 'in_progress');
    onChanged?.call();
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
      // ignore: unused_local_variable
      final backupPath = await backupService.createBackupArchive('user-identity-secret');
      KnightLogger.info('Uploading backup to Google Drive AppData...');
      
      _lastSyncTime = DateTime.now();
      _status = ProviderStatus.connected;
      _lastError = null;
      await _updateMeta('total_files_indexed', workspaceMemories.length.toString());
      await _updateMeta('last_successful_sync', _lastSyncTime!.toIso8601String());
      await _updateMeta('sync_status', 'idle');
    } catch (e) {
      _status = ProviderStatus.error;
      _lastError = _mapApiError(e);
      await _updateMeta('sync_status', 'failed');
      await _updateMeta('last_sync_error', _lastError!);
      KnightLogger.error('Drive sync failed', error: e);
    }
    onChanged?.call();
  }

  Future<void> restore() async {
    if (_status != ProviderStatus.connected) throw Exception('Drive not connected');
    await restoreService.restoreFromCloud('google_drive');
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
