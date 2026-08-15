import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/preferences_provider.dart';
import '../../internal/utils/knight_logger.dart';
import 'sync_task_service.dart';

/// Entry point for all background execution in Knight OS.
/// This runs in a separate isolate and manages its own lifecycle.
class BackgroundExecutor {
  static const String periodicSyncTask = 'com.knight_os.periodic_sync';
  static const String oneOffSyncTask = 'com.knight_os.one_off_sync';

  /// Initializes WorkManager and schedules the default maintenance task.
  static Future<void> init() async {
    KnightLogger.info('[BACKGROUND] Initializing WorkManager bridge...');
    await Workmanager().initialize(
      backgroundCallbackDispatcher,
      isInDebugMode: false,
    );

    // Schedule periodic maintenance every 15 minutes (minimum allowed by Android)
    await Workmanager().registerPeriodicTask(
      periodicSyncTask,
      periodicSyncTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }

  /// Manually triggers an immediate one-off background task.
  static Future<void> triggerImmediate() async {
    await Workmanager().registerOneOffTask(
      '${oneOffSyncTask}_${DateTime.now().millisecondsSinceEpoch}',
      oneOffSyncTask,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}

/// The terminal entry point required by WorkManager.
@pragma('vm:entry-point')
void backgroundCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final stopwatch = Stopwatch()..start();
    KnightLogger.info('[BACKGROUND] Worker starting: $task');

    // 1. Initialize mandatory dependencies for this isolate
    final prefs = await SharedPreferences.getInstance();
    
    // 2. Setup isolated ProviderContainer
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );

    try {
      // 3. Resolve the Sync Task Service and process the persistent queue
      final syncService = container.read(syncTaskServiceProvider.notifier);
      await syncService.runFullQueue();

      KnightLogger.info('[BACKGROUND] Worker finished: $task in ${stopwatch.elapsed.inSeconds}s');
      return true;
    } catch (e, s) {
      KnightLogger.error('[BACKGROUND] Critical worker failure', error: e, stackTrace: s);
      return false;
    } finally {
      stopwatch.stop();
      container.dispose();
    }
  });
}
