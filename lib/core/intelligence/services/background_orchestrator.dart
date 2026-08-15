import 'background_executor.dart';
import 'foreground_orchestrator.dart';
import '../../internal/utils/knight_logger.dart';

/// The unified entry point for all non-foreground DATA work.
/// Decides whether to use WorkManager (periodic/light) or a 
/// Foreground Service (sustained/heavy).
class BackgroundOrchestrator {
  
  /// Initializes all background foundations.
  static Future<void> init() async {
    await BackgroundExecutor.init();
    ForegroundOrchestrator.init();
  }

  /// Triggers a lightweight background maintenance cycle.
  /// Uses WorkManager to respect battery and network constraints.
  static Future<void> runMaintenance() async {
    KnightLogger.info('[ORCHESTRATOR] Triggering background maintenance...');
    await BackgroundExecutor.triggerImmediate();
  }

  /// Starts a sustained heavy processing session.
  /// Required for initial historical syncs to avoid being killed by Android.
  static Future<void> startHeavyLifting({
    required String title,
    required String body,
  }) async {
    KnightLogger.info('[ORCHESTRATOR] Transitioning to Heavy Lifting Mode...');
    await ForegroundOrchestrator.start(title: title, body: body);
  }

  /// Stops heavy processing and releases system resources.
  static Future<void> stopHeavyLifting() async {
    await ForegroundOrchestrator.stop();
  }
}
