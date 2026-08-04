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
    required this.calendarEvents,
    required this.marketStatus,
    this.lastSync,
    this.emailThreads = const [],
    this.sourceData = const {},
  });

  final String weather;
  final List<CalendarEvent> calendarEvents;
  final List<EmailThread> emailThreads;
  final String marketStatus;
  final DateTime? lastSync;
  final Map<String, dynamic> sourceData;

  /// Semantic titles of upcoming events (for simple UI display).
  List<String> get upcomingEvents => 
      calendarEvents.map((e) => e.title).toList();

  static final empty = WorldState(
    weather: 'Unknown',
    calendarEvents: const [],
    emailThreads: const [],
    marketStatus: 'Closed',
    lastSync: DateTime.fromMillisecondsSinceEpoch(0),
  );
}

/// Represents a calendar event from an external provider.
@immutable
class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.location,
    this.description,
  });

  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String? description;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'location': location,
    'description': description,
  };

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => CalendarEvent(
    id: json['id'],
    title: json['title'],
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    location: json['location'],
    description: json['description'],
  );
}

/// Represents an email thread from an external provider.
@immutable
class EmailThread {
  const EmailThread({
    required this.id,
    required this.subject,
    required this.sender,
    required this.snippet,
    required this.receivedAt,
    this.isUnread = true,
  });

  final String id;
  final String subject;
  final String sender;
  final String snippet;
  final DateTime receivedAt;
  final bool isUnread;

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'sender': sender,
    'snippet': snippet,
    'receivedAt': receivedAt.toIso8601String(),
    'isUnread': isUnread,
  };

  factory EmailThread.fromJson(Map<String, dynamic> json) => EmailThread(
    id: json['id'],
    subject: json['subject'],
    sender: json['sender'],
    snippet: json['snippet'],
    receivedAt: DateTime.parse(json['receivedAt']),
    isUnread: json['isUnread'] ?? true,
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
    this.diff = const [],
  });

  final WorldState state;
  final List<WorldEvent> events;
  
  /// External data normalized into memories for long-term storage.
  final List<KnightMemory> memories;
  
  final DateTime timestamp;

  /// Semantic summary of what changed since the last cycle.
  final List<String> diff;
}
