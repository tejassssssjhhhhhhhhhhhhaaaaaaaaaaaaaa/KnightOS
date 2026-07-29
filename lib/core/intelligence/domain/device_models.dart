import 'package:flutter/foundation.dart';

enum DeviceType {
  phone,
  tablet,
  desktop,
  wearable,
  hub,
}

enum DeviceStatus {
  online,
  offline,
  away,
  busy,
}

@immutable
class KnightDevice {
  const KnightDevice({
    required this.id,
    required this.name,
    required this.type,
    this.status = DeviceStatus.online,
    this.capabilities = const [],
    required this.lastSeen,
  });

  final String id;
  final String name;
  final DeviceType type;
  final DeviceStatus status;
  final List<String> capabilities;
  final DateTime lastSeen;

  KnightDevice copyWith({
    DeviceStatus? status,
    DateTime? lastSeen,
  }) {
    return KnightDevice(
      id: id,
      name: name,
      type: type,
      status: status ?? this.status,
      capabilities: capabilities,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
