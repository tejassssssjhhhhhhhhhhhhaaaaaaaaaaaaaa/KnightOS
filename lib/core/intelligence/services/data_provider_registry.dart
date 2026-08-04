import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/data_provider.dart';
import '../services/local_file_data_provider.dart';
import '../services/gmail_data_provider.dart';
import '../services/google_drive_provider.dart';
import '../services/google_calendar_data_provider.dart';
import '../services/google_health_provider.dart';
import '../services/samsung_health_provider.dart';
import '../services/galaxy_watch_provider.dart';
import 'device_intelligence_service.dart';
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

      // 1. Local File Provider
      try {
        providers.add(LocalFileDataProvider(
          ingestionService: ref.watch(dataIngestionServiceProvider),
          prefsService: ref.watch(importPreferenceServiceProvider),
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init LocalFileDataProvider', error: e, stackTrace: s);
      }

      // 2. Google Providers
      try {
        final gmail = GmailDataProvider(
          extractionEngine: ref.watch(emailExtractionEngineProvider),
          authService: ref.watch(googleAuthServiceProvider),
          db: db,
          onChanged: notifyChanged,
        );
        providers.add(gmail);
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GmailDataProvider', error: e, stackTrace: s);
      }

      try {
        providers.add(GoogleDriveProvider(
          backupService: ref.watch(backupServiceProvider),
          restoreService: ref.watch(restoreServiceProvider),
          authService: ref.watch(googleAuthServiceProvider),
          db: db,
          ingestionService: ref.watch(dataIngestionServiceProvider),
          workspaceEngine: ref.watch(workspaceExtractionEngineProvider),
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GoogleDriveProvider', error: e, stackTrace: s);
      }

      try {
        providers.add(GoogleCalendarDataProvider(
          ingestionService: ref.watch(dataIngestionServiceProvider),
          authService: ref.watch(googleAuthServiceProvider),
          db: db,
          workspaceEngine: ref.watch(workspaceExtractionEngineProvider),
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GoogleCalendarDataProvider', error: e, stackTrace: s);
      }

      try {
        providers.add(GoogleHealthProvider(
          ingestionService: ref.watch(dataIngestionServiceProvider),
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GoogleHealthProvider', error: e, stackTrace: s);
      }

      try {
        providers.add(SamsungHealthProvider(
          ingestionService: ref.watch(dataIngestionServiceProvider),
          db: db,
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init SamsungHealthProvider', error: e, stackTrace: s);
      }

      try {
        providers.add(GalaxyWatchProvider(
          db: db,
          deviceIntelligenceService: ref.watch(deviceIntelligenceServiceProvider),
          onChanged: notifyChanged,
        ));
      } catch (e, s) {
        KnightLogger.error('[REGISTRY] Failed to init GalaxyWatchProvider', error: e, stackTrace: s);
      }

      // P0: Synchronization - If user intended to connect, trigger it
      _restoreConnectionIntents(providers, prefs);
    } catch (e, s) {
      KnightLogger.error('[REGISTRY] Critical failure in DataProviderRegistry.build', error: e, stackTrace: s);
    }

    return List.unmodifiable(providers);
  }

  void _restoreConnectionIntents(List<DataProvider> providers, SharedPreferences prefs) {
    for (final provider in providers) {
      final intended = prefs.getBool('$_persistenceKeyPrefix${provider.id}') ?? false;
      if (intended && provider.status == ProviderStatus.disconnected) {
        KnightLogger.info('[REGISTRY] Restoring connection intent for ${provider.id}');
        // Trigger connect in next frame to avoid build-phase exceptions
        Future.microtask(() => provider.connect());
      }
    }
  }

  /// Forces a state update to notify listeners (UI) that provider internal state changed.
  void notifyChanged() {
    state = List.from(state);
  }

  Future<void> setConnectionIntent(String providerId, bool connected) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('$_persistenceKeyPrefix$providerId', connected);
    
    final provider = state.firstWhereOrNull((p) => p.id == providerId);
    if (provider == null) {
      KnightLogger.warn('[REGISTRY] Cannot set intent: provider $providerId not found');
      return;
    }

    if (connected) {
      await provider.connect();
    } else {
      await provider.disconnect();
    }
    notifyChanged();
  }

  Future<void> syncAll() async {
    for (final provider in state) {
      if (provider.status == ProviderStatus.connected || provider.status == ProviderStatus.error) {
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
