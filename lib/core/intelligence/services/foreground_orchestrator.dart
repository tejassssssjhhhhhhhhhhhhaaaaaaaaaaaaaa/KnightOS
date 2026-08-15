import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'foreground_executor.dart';
import '../../internal/utils/knight_logger.dart';

/// Orchestrates user-visible heavy-lifting tasks (e.g., initial ingestion).
class ForegroundOrchestrator {

  /// Sets up the notification channel and basic service parameters.
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'knight_heavy_sync',
        channelName: 'Knight Heavy Sync',
        channelDescription: 'Processes historical data and large-scale indexing.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(10000), // Check every 10 seconds
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  /// Starts the foreground service to begin processing the task queue.
  static Future<bool> start({required String title, required String body}) async {
    if (await FlutterForegroundTask.isRunningService) {
       return true;
    }

    KnightLogger.info('[FOREGROUND] Starting heavy ingestion service...');
    
    final ServiceRequestResult result = await FlutterForegroundTask.startService(
      notificationTitle: title,
      notificationText: body,
      callback: foregroundCallbackDispatcher,
    );

    return result is ServiceRequestSuccess;
  }

  /// Stops the service once heavy work is complete.
  static Future<bool> stop() async {
    KnightLogger.info('[FOREGROUND] Stopping heavy ingestion service...');
    final ServiceRequestResult result = await FlutterForegroundTask.stopService();
    return result is ServiceRequestSuccess;
  }
}
