class MemoryItem {
  const MemoryItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.source,
    required this.category,
    required this.permission,
    this.tags = const <String>[],
    this.confidence = 0.6,
    this.importance = 0.5,
    this.editable = true,
    this.searchable = true,
  });

  final String id;
  final String userId;
  final String title;
  final String body;
  final DateTime createdAt;
  final String source;
  final String category;
  final String permission;
  final List<String> tags;
  final double confidence;
  final double importance;
  final bool editable;
  final bool searchable;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'source': source,
      'category': category,
      'permission': permission,
      'tags': tags,
      'confidence': confidence,
      'importance': importance,
      'editable': editable,
      'searchable': searchable,
    };
  }

  factory MemoryItem.fromJson(Map<String, Object?> json) {
    return MemoryItem(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? 'local-user',
      title: json['title'] as String? ?? 'Memory',
      body: json['body'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      source: json['source'] as String? ?? 'chat',
      category: json['category'] as String? ?? 'general',
      permission: json['permission'] as String? ?? 'conversation_only',
      tags:
          (json['tags'] as List?)?.whereType<String>().toList() ??
          const <String>[],
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.6,
      importance: (json['importance'] as num?)?.toDouble() ?? 0.5,
      editable: json['editable'] as bool? ?? true,
      searchable: json['searchable'] as bool? ?? true,
    );
  }
}
