import 'dart:async';

/// Raw sensor data for fusion.
class SensorData {
  const SensorData({
    required this.accelerometer,
    required this.proximity,
    required this.light,
    required this.timestamp,
  });

  final List<double> accelerometer;
  final double proximity;
  final double light;
  final DateTime timestamp;
}

/// Orchestrates real-time sensor data fusion for environmental awareness.
class SensorFusionEngine {
  SensorFusionEngine();

  final StreamController<SensorData> _controller = StreamController<SensorData>.broadcast();
  Stream<SensorData> get sensorStream => _controller.stream;

  /// Injects raw sensor data for processing.
  void updateSensors({
    required List<double> accelerometer,
    required double proximity,
    required double light,
  }) {
    final data = SensorData(
      accelerometer: accelerometer,
      proximity: proximity,
      light: light,
      timestamp: DateTime.now(),
    );
    _controller.add(data);
  }

  /// Calculates derived metrics (e.g. movement intensity).
  double calculateIntensity(List<double> acc) {
    // Simple magnitude of acceleration vector
    return acc.map((x) => x * x).reduce((a, b) => a + b);
  }

  void dispose() {
    _controller.close();
  }
}
