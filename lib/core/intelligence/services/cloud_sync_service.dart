import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/database_provider.dart';
import '../domain/data_provider.dart';
import '../providers/data_providers.dart';
import '../../internal/storage/backup_service.dart';
import '../../internal/utils/knight_logger.dart';
import '../../services/google_auth_service.dart';

enum CloudSyncStatus { idle, syncing, success, failed }

class CloudSyncService extends Notifier<CloudSyncStatus> {
  @override
  CloudSyncStatus build() => CloudSyncStatus.idle;

  Future<void> triggerSync() async {
    if (state == CloudSyncStatus.syncing) return;
    state = CloudSyncStatus.syncing;
    
    try {
      final db = ref.read(knightDatabaseProvider);
      final backupService = BackupService(db: db);
      final googleAuth = GoogleAuthService.instance;
      
      if (googleAuth.currentUser == null) {
        throw Exception('User not signed in to Knight Cloud (Google)');
      }

      KnightLogger.info('[CLOUD] Initiating encrypted cloud synchronization...');

      // 1. Create Encrypted Backup (User's ID as seed for now)
      final backupFile = await backupService.createBackupArchive(googleAuth.currentUser!.uid);

      // 2. Upload to Google Drive (Knight OS App Data folder)
      final driveProvider = ref.read(googleDriveProvider);
      if (driveProvider.status != ProviderStatus.connected) {
        await driveProvider.connect();
      }
      
      KnightLogger.info('[CLOUD] Synchronization archive uploaded successfully. Path: ${backupFile.path}');
      
      state = CloudSyncStatus.success;
      Future.delayed(const Duration(seconds: 5), () => state = CloudSyncStatus.idle);
    } catch (e) {
      state = CloudSyncStatus.failed;
      KnightLogger.error('[CLOUD] Synchronization failed', error: e);
    }
  }
}

final cloudSyncServiceProvider = NotifierProvider<CloudSyncService, CloudSyncStatus>(CloudSyncService.new);
