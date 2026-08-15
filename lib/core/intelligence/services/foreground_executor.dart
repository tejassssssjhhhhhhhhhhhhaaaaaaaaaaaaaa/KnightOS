import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/preferences_provider.dart';
import 'sync_task_service.dart';
import '../../internal/utils/knight_logger.dart';

/// Entry point for the Foreground Service isolate.
@pragma('vm:entry-point')
void foregroundCallbackDispatcher() {
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}

/// Handles the lifecycle of heavy background work.
class ForegroundTaskHandler extends TaskHandler {
  ProviderContainer? _container;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    KnightLogger.info('[FOREGROUND] Service isolate started');
    
    // 1. Initialize mandatory dependencies for this isolate
    final prefs = await SharedPreferences.getInstance();
    
    // 2. Setup isolated ProviderContainer
    _container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    if (_container == null) return;

    // 3. Process the entire queue until empty
    _container!.read(syncTaskServiceProvider.notifier).runFullQueue();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    KnightLogger.info('[FOREGROUND] Service isolate destroying');
    _container?.dispose();
  }

  @override
  void onNotificationButtonPressed(String id) {
     KnightLogger.info('[FOREGROUND] Notification button pressed: $id');
  }
}
