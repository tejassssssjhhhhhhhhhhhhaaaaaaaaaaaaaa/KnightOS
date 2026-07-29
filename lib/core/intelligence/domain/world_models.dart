import 'package:flutter/foundation.dart';
import 'knight_memory.dart';

/// Metadata describing an external data provider.
@immutable
class WorldSource {
  const WorldSource({
    required this.id,
    required this.name,
    required this.type,
    this.version = '1.0.0',
  });

  final String id;
  final String name;
  final String type;
  final String version;
}

/// A discrete change or update detected in the external world.
@immutable
class WorldEvent {
  const WorldEvent({
    required this.id,
    required this.sourceId,
    required this.type,
    required this.payload,
    required this.timestamp,
  });

  final String id;
  final String sourceId;
  final String type;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
}

/// A point-in-time snapshot of the user's external environment.
@immutable
class WorldState {
  const WorldState({
    required this.weather,
    required this.upcomingEvents,
    required this.marketStatus,
    required this.lastSync,
    this.sourceData = const {},
  });

  final String weather;
  final List<String> upcomingEvents;
  final String marketStatus;
  final DateTime lastSync;
  final Map<String, dynamic> sourceData;

  static const empty = WorldState(
    weather: 'Unknown',
    upcomingEvents: [],
    marketStatus: 'Closed',
    lastSync: DateTime(1970),
  );
}

/// The consolidated result of a world perception cycle.
@immutable
class WorldResult {
  const WorldResult({
    required this.state,
    required this.events,
    required this.memories,
    required this.timestamp,
  });

  final WorldState state;
  final List<WorldEvent> events;
  
  /// External data normalized into memories for long-term storage.
  final List<KnightMemory> memories;
  
  final DateTime timestamp;
}
