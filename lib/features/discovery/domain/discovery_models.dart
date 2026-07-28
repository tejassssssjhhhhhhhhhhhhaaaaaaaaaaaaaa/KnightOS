import 'package:flutter/foundation.dart';
import '../../../core/intelligence/domain/memory_domain.dart';
import '../../../core/intelligence/domain/memory_category.dart';

enum QuestionPriority { critical, high, medium, low }

enum QuestionType { string, list, boolean, date, number, json, map, options }

@immutable
class DiscoveryQuestion {
  const DiscoveryQuestion({
    required this.id,
    required this.text,
    required this.purpose,
    required this.type,
    required this.domain,
    required this.category,
    this.priority = QuestionPriority.medium,
    this.dependencies = const [],
    this.followUpRules = const {},
    this.options = const [],
    this.isDynamic = false,
  });

  final String id;
  final String text;
  final String purpose;
  final QuestionType type;
  final MemoryDomain domain;
  final BookCategory category;
  final QuestionPriority priority;

  /// List of Question IDs that must be answered before this one is offered.
  final List<String> dependencies;

  /// Map of logic rules (e.g. {"answer": "Yes", "next": "Q-045"})
  final Map<String, dynamic> followUpRules;

  /// Predefined options for 'options' type questions.
  final List<String> options;

  final bool isDynamic;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'purpose': purpose,
      'type': type.name,
      'domainId': domain.id,
      'categoryId': category.id,
      'priority': priority.name,
      'dependencies': dependencies,
      'followUpRules': followUpRules,
      'options': options,
      'isDynamic': isDynamic,
    };
  }

  factory DiscoveryQuestion.fromJson(Map<String, dynamic> json) {
    return DiscoveryQuestion(
      id: json['id'] as String,
      text: json['text'] as String,
      purpose: json['purpose'] as String,
      type: QuestionType.values.byName(json['type'] as String),
      domain: MemoryDomain.fromId(json['domainId'] as int),
      category: BookCategory.fromId(json['categoryId'] as int),
      priority: QuestionPriority.values.byName(
        json['priority'] as String? ?? 'medium',
      ),
      dependencies:
          (json['dependencies'] as List<dynamic>?)?.cast<String>() ?? const [],
      followUpRules:
          (json['followUpRules'] as Map<String, dynamic>?) ?? const {},
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? const [],
      isDynamic: json['isDynamic'] as bool? ?? false,
    );
  }
}

class QuestionStatus {
  const QuestionStatus({
    required this.id,
    this.isAnswered = false,
    this.isSkipped = false,
    this.lastOffered,
    this.memoryId,
  });

  final String id;
  final bool isAnswered;
  final bool isSkipped;
  final DateTime? lastOffered;
  final String? memoryId;
}
