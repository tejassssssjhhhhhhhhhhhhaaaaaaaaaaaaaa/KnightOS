import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'knight_message.dart';

/// Represents a conversation session with Knight.
@immutable
class KnightConversation {
  KnightConversation({
    String? id,
    required this.title,
    required this.messages,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       lastUpdatedAt = lastUpdatedAt ?? DateTime.now();

  final String id;
  final String title;
  final List<KnightMessage> messages;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  KnightConversation copyWith({
    String? title,
    List<KnightMessage>? messages,
    DateTime? lastUpdatedAt,
  }) {
    return KnightConversation(
      id: id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  factory KnightConversation.fromJson(Map<String, dynamic> json) {
    return KnightConversation(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((m) => KnightMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );
  }

  static KnightConversation get empty =>
      KnightConversation(title: 'New Conversation', messages: []);
}
