import 'package:flutter/foundation.dart';

/// Represents a Gmail message structured for Intelligence reasoning.
@immutable
class WorkspaceEmail {
  const WorkspaceEmail({
    required this.id,
    required this.threadId,
    required this.subject,
    required this.sender,
    required this.snippet,
    required this.date,
    this.labels = const [],
    this.isUnread = true,
    this.importance = 'normal',
    this.metadata = const {},
  });

  final String id;
  final String threadId;
  final String subject;
  final String sender;
  final String snippet;
  final DateTime date;
  final List<String> labels;
  final bool isUnread;
  final String importance; // low, normal, high, critical
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => {
    'id': id,
    'threadId': threadId,
    'subject': subject,
    'sender': sender,
    'snippet': snippet,
    'date': date.toIso8601String(),
    'labels': labels,
    'isUnread': isUnread,
    'importance': importance,
    'metadata': metadata,
    'workspaceDataType': 'email',
  };

  factory WorkspaceEmail.fromJson(Map<String, dynamic> json) => WorkspaceEmail(
    id: json['id'] as String,
    threadId: json['threadId'] as String,
    subject: json['subject'] as String,
    sender: json['sender'] as String,
    snippet: json['snippet'] as String,
    date: DateTime.parse(json['date'] as String),
    labels: List<String>.from(json['labels'] as List),
    isUnread: json['isUnread'] as bool? ?? true,
    importance: json['importance'] as String? ?? 'normal',
    metadata: Map<String, dynamic>.from(json['metadata'] as Map),
  );
}

/// Represents a Google Calendar event for Intelligence reasoning.
@immutable
class WorkspaceCalendarEvent {
  const WorkspaceCalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.attendees = const [],
    this.isAllDay = false,
    this.status = 'confirmed',
    this.metadata = const {},
  });

  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final List<String> attendees;
  final bool isAllDay;
  final String status;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'location': location,
    'attendees': attendees,
    'isAllDay': isAllDay,
    'status': status,
    'metadata': metadata,
    'workspaceDataType': 'calendar_event',
  };

  factory WorkspaceCalendarEvent.fromJson(Map<String, dynamic> json) => WorkspaceCalendarEvent(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    startTime: DateTime.parse(json['startTime'] as String),
    endTime: DateTime.parse(json['endTime'] as String),
    location: json['location'] as String?,
    attendees: List<String>.from(json['attendees'] as List? ?? []),
    isAllDay: json['isAllDay'] as bool? ?? false,
    status: json['status'] as String? ?? 'confirmed',
    metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
  );
}

/// Represents a Google Drive file metadata for Intelligence reasoning.
@immutable
class WorkspaceDriveFile {
  const WorkspaceDriveFile({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.modifiedTime,
    this.webViewLink,
    this.sizeBytes,
    this.owners = const [],
    this.metadata = const {},
  });

  final String id;
  final String name;
  final String mimeType;
  final DateTime modifiedTime;
  final String? webViewLink;
  final int? sizeBytes;
  final List<String> owners;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'mimeType': mimeType,
    'modifiedTime': modifiedTime.toIso8601String(),
    'webViewLink': webViewLink,
    'sizeBytes': sizeBytes,
    'owners': owners,
    'metadata': metadata,
    'workspaceDataType': 'drive_file',
  };

  factory WorkspaceDriveFile.fromJson(Map<String, dynamic> json) => WorkspaceDriveFile(
    id: json['id'] as String,
    name: json['name'] as String,
    mimeType: json['mimeType'] as String,
    modifiedTime: DateTime.parse(json['modifiedTime'] as String),
    webViewLink: json['webViewLink'] as String?,
    sizeBytes: json['sizeBytes'] as int?,
    owners: List<String>.from(json['owners'] as List? ?? []),
    metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
  );
}
