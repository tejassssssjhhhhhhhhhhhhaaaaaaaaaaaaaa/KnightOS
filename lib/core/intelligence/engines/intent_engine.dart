import '../domain/cognitive_models.dart';

/// Detects the user's primary intent from natural language input.
class IntentEngine {
  const IntentEngine();

  /// Classifies the input text into a [KnightIntent].
  KnightIntent detectIntent(String text) {
    final input = text.toLowerCase();

    if (input.contains('should i') ||
        input.contains('decide') ||
        input.contains('choice')) {
      return KnightIntent.decision;
    }

    if (input.contains('plan') ||
        input.contains('schedule') ||
        input.contains('how to achieve')) {
      return KnightIntent.planning;
    }

    if (input.contains('remind') ||
        input.contains('reminder') ||
        input.contains('don\'t forget')) {
      return KnightIntent.reminder;
    }

    if (input.contains('learn') ||
        input.contains('explain') ||
        input.contains('what is')) {
      return KnightIntent.learning;
    }

    if (input.contains('analyze') ||
        input.contains('trend') ||
        input.contains('how am i doing')) {
      return KnightIntent.analysis;
    }

    if (input.contains('search') ||
        input.contains('find') ||
        input.contains('where is')) {
      return KnightIntent.search;
    }

    if (input.contains('reflect') ||
        input.contains('review my week') ||
        input.contains('summary')) {
      return KnightIntent.reflection;
    }

    if (input.startsWith('hi') ||
        input.startsWith('hello') ||
        input.startsWith('hey')) {
      return KnightIntent.conversation;
    }

    if (input.contains('?') ||
        input.contains('who') ||
        input.contains('when') ||
        input.contains('what')) {
      return KnightIntent.question;
    }

    return KnightIntent.conversation;
  }
}
