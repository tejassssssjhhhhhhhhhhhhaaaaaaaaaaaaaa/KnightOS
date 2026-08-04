import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../intelligence_bus.dart';
import '../domain/intelligence_events.dart';
import '../providers/intelligence_providers.dart';
import '../../internal/utils/knight_logger.dart';
import 'sensor_fusion_engine.dart';

/// Interprets sensor fusion data into higher-level environmental context.
class PerceptionEngine extends Notifier<String> {
  StreamSubscription? _subscription;

  @override
  String build() {
    _init();
    ref.onDispose(() => _subscription?.cancel());
    return 'stationary';
  }

  void _init() {
    final fusionEngine = ref.read(sensorFusionEngineProvider);
    _subscription = fusionEngine.sensorStream.listen(_analyzePerception);
  }

  void _analyzePerception(SensorData data) {
    final fusionEngine = ref.read(sensorFusionEngineProvider);
    final bus = ref.read(intelligenceBusProvider);

    // 1. Movement Intensity
    final intensity = fusionEngine.calculateIntensity(data.accelerometer);
    
    String activityId = 'stationary';

    // 2. Simple Activity Recognition (Heuristics)
    if (intensity > 50.0) {
       activityId = 'moving_vibrant';
    } else if (intensity > 1.0) {
       activityId = 'stable_movement';
    }

    // 3. Proximity Awareness
    if (data.proximity < 1.0) {
      activityId = 'pocket_or_covered';
    }

    // 4. Light Sensitivity
    if (data.light < 5.0 && activityId == 'stationary') {
       activityId = 'dark_environment';
    }

    if (activityId != state) {
      state = activityId;
      _emitActivity(activityId, bus);
    }
  }

  void _emitActivity(String activityId, IntelligenceBus bus) {
    bus.emit(EnvironmentChangedEvent(
      timestamp: DateTime.now(),
      environmentId: activityId,
      metadata: const {'engine': 'perception_v5'},
    ));
    KnightLogger.info('[PERCEPTION] Detected activity: $activityId');
  }
}
