import '../../world/domain/world_models.dart';
import '../../world/engines/device_intelligence.dart';

/// Maintains the "What is happening now?" state for KnightOS.
class WorldContextEngine {
  const WorldContextEngine({required this.deviceIntelligence});

  final DeviceIntelligence deviceIntelligence;

  /// Builds a real-time snapshot of the user's world context.
  Future<WorldContext> captureCurrentContext() async {
    final now = DateTime.now();
    final device = await deviceIntelligence.getLocalDeviceInfo();

    return WorldContext(
      timestamp: now,
      timezone: DateTime.now().timeZoneName,
      locationLabel: 'Unknown', // Future: Inject from LocationService
      weather: 'Checking...', // Future: Inject from WeatherService
      currentActivity: _inferActivity(now, device),
    );
  }

  String _inferActivity(DateTime now, DeviceInfo device) {
    if (now.hour >= 23 || now.hour < 6) {
      return 'Sleeping';
    }
    if (device.activeApps.contains('zoom') ||
        device.activeApps.contains('slack')) {
      return 'Working';
    }
    return 'Active';
  }
}
