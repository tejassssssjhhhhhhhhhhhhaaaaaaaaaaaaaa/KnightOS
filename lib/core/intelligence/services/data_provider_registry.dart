import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/data_provider.dart';
import '../services/local_file_data_provider.dart';
import '../services/gmail_data_provider.dart';
import '../services/google_drive_provider.dart';
import '../services/google_calendar_data_provider.dart';
import '../services/google_health_provider.dart';
import '../services/samsung_health_provider.dart';
import '../services/galaxy_watch_provider.dart';
import '../services/google_contacts_provider.dart';
import '../services/google_tasks_provider.dart';
import 'device_intelligence_service.dart';
import 'sync_task_service.dart';
import '../providers/intelligence_providers.dart';
import '../../internal/utils/knight_logger.dart';
import '../../providers/database_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/google_auth_providers.dart';
import '../../providers/storage_providers.dart';

/// Registry to manage all connected data sources.
/// Implemented as a Notifier to provide reactivity to the UI.
class DataProviderRegistry extends Notifier<List<DataProvider>> {
  
  static const _persistenceKeyPrefix = 'knight_provider_intent_';

  @override
  List<DataProvider> build() {
    final providers = <DataProvider>[];
    
    try {
      final db = ref.watch(knightDatabaseProvider);
      final prefs = ref.watch(sharedPreferencesProvider);
      final auth = ref.watch(googleAuthServiceProvider);

      // Helper to initialize and load provider state
      void addProvider(DataProvider provider) {
        providers.add(provider);
        provider.loadState().then((_) async {
          // Migration from SharedPreferences if SQLite state is missing
          final hasSqlIntent = await db.syncMetadataDao.getMetadata(provider.id, 'is_enabled') != null;
          if (!hasSqlIntent) {
            final legacyIntent = prefs.getBool('$_persistenceKeyPrefix${provider.id}') ?? false;
            if (legacyIntent) {
              KnightLogger.info('[REGISTRY] Migrating legacy intent for ${provider.id}');
              await provider.setEnabled(true);
            }
          }

          // If the user enabled this source, attempt to connect
          if (provider.isEnabled && 
              (provider.status == ProviderStatus.disconnected || 
               provider.status == ProviderStatus.notConfigured)) {
            provider.connect();
          }
          notifyChanged();
        });
      }

      // 1. Local File Provider
      try {
        addProvider(LocalFileDataProvider(
          ingestionService: ref.watch(dataIngestionServiceProvider),
          prefsService: ref.watch(importPreferenceServiceProvider),
          db: db,
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init LocalFileDataProvider', error: e, stackTrace: s);
      }

      // 2. Google Providers
      try {
        addProvider(GmailDataProvider(
          extractionEngine: ref.watch(emailExtractionEngineProvider),
          authService: auth,
          db: db,
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GmailDataProvider', error: e, stackTrace: s);
      }

      try {
        addProvider(GoogleDriveProvider(
          backupService: ref.watch(backupServiceProvider),
          restoreService: ref.watch(restoreServiceProvider),
          authService: auth,
          db: db,
          ingestionService: ref.watch(dataIngestionServiceProvider),
          workspaceEngine: ref.watch(workspaceExtractionEngineProvider),
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GoogleDriveProvider', error: e, stackTrace: s);
      }

      try {
        addProvider(GoogleCalendarDataProvider(
          ingestionService: ref.watch(dataIngestionServiceProvider),
          authService: auth,
          db: db,
          workspaceEngine: ref.watch(workspaceExtractionEngineProvider),
          prefs: ref.watch(importPreferenceServiceProvider),
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GoogleCalendarDataProvider', error: e, stackTrace: s);
      }

      try {
        addProvider(GoogleHealthProvider(
          ingestionService: ref.watch(dataIngestionServiceProvider),
          db: db,
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GoogleHealthProvider', error: e, stackTrace: s);
      }

      try {
        addProvider(SamsungHealthProvider(
          ingestionService: ref.watch(dataIngestionServiceProvider),
          db: db,
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init SamsungHealthProvider', error: e, stackTrace: s);
      }

      try {
        final deviceIntelligence = ref.watch(deviceIntelligenceServiceProvider);
        addProvider(GalaxyWatchProvider(
          db: db,
          deviceIntelligenceService: deviceIntelligence,
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GalaxyWatchProvider', error: e, stackTrace: s);
      }

      try {
        addProvider(GoogleContactsProvider(
          authService: auth,
          db: db,
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GoogleContactsProvider', error: e, stackTrace: s);
      }

      try {
        addProvider(GoogleTasksProvider(
          authService: auth,
          db: db,
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GoogleTasksProvider', error: e, stackTrace: s);
      }
    } catch (e, s) {
      KnightLogger.error('[REGISTRY] Critical failure in DataProviderRegistry.build', error: e, stackTrace: s);
    }

    return List.unmodifiable(providers);
  }

  void notifyChanged() {
    state = List.from(state);
  }

  /// Sets the enabled state of a specific data source.
  Future<void> setEnabled(String providerId, bool enabled) async {
    final provider = state.firstWhereOrNull((p) => p.id == providerId);
    if (provider == null) {
      KnightLogger.warn('[REGISTRY] Cannot set enabled: provider $providerId not found');
      return;
    }

    await provider.setEnabled(enabled);
    notifyChanged();
  }

  @Deprecated('Use setEnabled')
  Future<void> setConnectionIntent(String providerId, bool connected) => setEnabled(providerId, connected);

  Future<void> setSyncFrequency(String freq) async {
    await ref.read(importPreferenceServiceProvider).setSyncFrequency(freq);
    ref.read(syncTaskServiceProvider.notifier).refreshSchedule();
    notifyChanged();
  }

  Future<void> setAutoSyncEnabled(bool enabled) async {
    await ref.read(importPreferenceServiceProvider).setAutoSyncEnabled(enabled);
    ref.read(syncTaskServiceProvider.notifier).refreshSchedule();
    notifyChanged();
  }

  Future<void> syncAll() async {
    for (final provider in state) {
      if (provider.isEnabled && (provider.status == ProviderStatus.connected || provider.status == ProviderStatus.error)) {
        try {
          await provider.syncIncremental();
        } catch (e) {
          KnightLogger.error('Sync failed for provider: ${provider.id}', error: e);
        }
      }
    }
    notifyChanged();
  }
}
