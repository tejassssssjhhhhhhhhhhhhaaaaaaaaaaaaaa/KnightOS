import 'dart:async';
import '../domain/device_models.dart';
import '../domain/intelligence_events.dart';
import '../intelligence_bus.dart';

class MultiDeviceManager {
  MultiDeviceManager({required this.bus}) {
    _init();
  }

  final IntelligenceBus bus;
  final Map<String, KnightDevice> _registry = {};
  final StreamController<List<KnightDevice>> _devicesController = StreamController.broadcast();

  Stream<List<KnightDevice>> get devices => _devicesController.stream;

  void _init() {
    // Register "Local Device" by default
    final local = KnightDevice(
      id: 'local',
      name: 'This Device',
      type: DeviceType.phone,
      lastSeen: DateTime.now(),
    );
    _registry[local.id] = local;
    _broadcast();

    // Listen for heartbeats
    bus.events.where((e) => e is DeviceHeartbeatEvent).listen((e) {
      final event = e as DeviceHeartbeatEvent;
      _updateDevice(event.deviceId, event.status);
    });
  }

  void registerDevice(KnightDevice device) {
    _registry[device.id] = device;
    _broadcast();
  }

  void _updateDevice(String id, DeviceStatus status) {
    final existing = _registry[id];
    if (existing != null) {
      _registry[id] = existing.copyWith(status: status, lastSeen: DateTime.now());
      _broadcast();
    }
  }

  void _broadcast() {
    _devicesController.add(_registry.values.toList());
  }

  KnightDevice? getDevice(String id) => _registry[id];

  void dispose() {
    _devicesController.close();
  }
}
