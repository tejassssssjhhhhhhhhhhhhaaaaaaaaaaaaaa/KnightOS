import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Roles involved in a Knight conversation.
enum KnightMessageRole {
  user,
  assistant,
  system;

  String get label {
    switch (this) {
      case KnightMessageRole.user:
        return 'User';
      case KnightMessageRole.assistant:
        return 'Knight';
      case KnightMessageRole.system:
        return 'System';
    }
  }
}

/// Status of a message in the conversation.
enum KnightMessageStatus { sending, sent, error }

/// Represents a single message in a Knight conversation.
@immutable
class KnightMessage {
  KnightMessage({
    String? id,
    required this.role,
    required this.content,
    DateTime? timestamp,
    this.status = KnightMessageStatus.sent,
    this.metadata = const {},
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  final String id;
  final KnightMessageRole role;
  final String content;
  final DateTime timestamp;
  final KnightMessageStatus status;
  final Map<String, dynamic> metadata;

  KnightMessage copyWith({
    String? content,
    KnightMessageStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return KnightMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      timestamp: timestamp,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'metadata': metadata,
    };
  }

  factory KnightMessage.fromJson(Map<String, dynamic> json) {
    return KnightMessage(
      id: json['id'] as String,
      role: KnightMessageRole.values.byName(json['role'] as String),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: KnightMessageStatus.values.byName(json['status'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );
  }
}
