import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knight_os/core/intelligence/engines/sensor_fusion_engine.dart';
import 'package:knight_os/core/intelligence/providers/intelligence_providers.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/domain/intelligence_events.dart';

void main() {
  late ProviderContainer container;
  late SensorFusionEngine fusionEngine;
  late IntelligenceBus bus;

  setUp(() {
    fusionEngine = SensorFusionEngine();
    bus = IntelligenceBus();
    container = ProviderContainer(
      overrides: [
        sensorFusionEngineProvider.overrideWithValue(fusionEngine),
        intelligenceBusProvider.overrideWithValue(bus),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    fusionEngine.dispose();
    bus.dispose();
  });

  test('PerceptionEngine identifies moving_vibrant activity', () async {
    container.read(perceptionEngineProvider.notifier);
    
    // Inject high intensity data
    fusionEngine.updateSensors(
      accelerometer: [10.0, 10.0, 10.0], // intensity > 50.0
      proximity: 5.0,
      light: 100.0,
    );

    // Wait for stream processing
    await Future.delayed(const Duration(milliseconds: 100));

    expect(container.read(perceptionEngineProvider), 'moving_vibrant');
  });

  test('PerceptionEngine identifies pocket_or_covered activity', () async {
    container.read(perceptionEngineProvider.notifier);
    
    // Inject low proximity data
    fusionEngine.updateSensors(
      accelerometer: [0.0, 0.0, 0.0],
      proximity: 0.5,
      light: 1.0,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    expect(container.read(perceptionEngineProvider), 'pocket_or_covered');
  });

  test('PerceptionEngine emits EnvironmentChangedEvent on change', () async {
    // Initialize the engine by reading the notifier
    container.read(perceptionEngineProvider.notifier);

    final events = <IntelligenceEvent>[];
    bus.events.listen(events.add);

    fusionEngine.updateSensors(
      accelerometer: [10.0, 10.0, 10.0],
      proximity: 5.0,
      light: 100.0,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    expect(events.any((e) => e is EnvironmentChangedEvent && e.environmentId == 'moving_vibrant'), isTrue);
  });
}
