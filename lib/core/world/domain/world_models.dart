import 'package:flutter/foundation.dart';

/// Represents the current physical and environmental state of the user.
@immutable
class WorldContext {
  const WorldContext({
    required this.timestamp,
    required this.timezone,
    this.locationLabel,
    this.weather,
    this.isHoliday = false,
    this.currentActivity,
    this.activeRoutines = const [],
  });

  final DateTime timestamp;
  final String timezone;
  final String? locationLabel; // e.g. "Home", "Office", "Gym"
  final String? weather; // e.g. "Sunny, 24°C"
  final bool isHoliday;
  final String? currentActivity; // e.g. "Working", "Sleeping", "Commuting"
  final List<String> activeRoutines;

  WorldContext copyWith({
    DateTime? timestamp,
    String? timezone,
    String? locationLabel,
    String? weather,
    bool? isHoliday,
    String? currentActivity,
    List<String>? activeRoutines,
  }) {
    return WorldContext(
      timestamp: timestamp ?? this.timestamp,
      timezone: timezone ?? this.timezone,
      locationLabel: locationLabel ?? this.locationLabel,
      weather: weather ?? this.weather,
      isHoliday: isHoliday ?? this.isHoliday,
      currentActivity: currentActivity ?? this.currentActivity,
      activeRoutines: activeRoutines ?? this.activeRoutines,
    );
  }
}

/// Represents the state of a connected device.
@immutable
class DeviceInfo {
  const DeviceInfo({
    required this.id,
    required this.name,
    required this.type,
    this.batteryLevel,
    this.isCharging = false,
    this.isOnline = true,
    this.activeApps = const [],
    this.lastSeen,
  });

  final String id;
  final String name;
  final String type; // e.g. "mobile", "laptop", "watch"
  final double? batteryLevel; // 0.0 to 1.0
  final bool isCharging;
  final bool isOnline;
  final List<String> activeApps;
  final DateTime? lastSeen;

  DeviceInfo copyWith({
    double? batteryLevel,
    bool? isCharging,
    bool? isOnline,
    List<String>? activeApps,
    DateTime? lastSeen,
  }) {
    return DeviceInfo(
      id: id,
      name: name,
      type: type,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isCharging: isCharging ?? this.isCharging,
      isOnline: isOnline ?? this.isOnline,
      activeApps: activeApps ?? this.activeApps,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
