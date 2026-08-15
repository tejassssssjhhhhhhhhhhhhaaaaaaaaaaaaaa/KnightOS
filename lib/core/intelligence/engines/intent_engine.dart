import '../domain/cognitive_models.dart';

/// Detects the user's primary intent from natural language input.
class IntentEngine {
  const IntentEngine();

  /// Classifies the input text into a [KnightIntent].
  KnightIntent detectIntent(String text) {
    final input = text.trim().toLowerCase();
    
    // Casual Conversation (Greetings, etc.)
    if (input == 'hi' ||
        input == 'hello' ||
        input == 'hey' ||
        input.startsWith('hi ') ||
        input.startsWith('hello ') ||
        input.startsWith('hey ') ||
        input.contains('how are you') ||
        input.contains('good morning') ||
        input.contains('good evening') ||
        input.contains('thank you') ||
        input.contains('thanks') ||
        input.contains('bye') ||
        input.contains('goodbye')) {
      return KnightIntent.conversation;
    }

    if (input.contains('what can you do') ||
        input.contains('help') ||
        input.contains('how to use') ||
        input.contains('features')) {
      return KnightIntent.conversation;
    }

    // Finance Intent
    if (input.contains('spend') ||
        input.contains('expense') ||
        input.contains('cost') ||
        input.contains('transaction') ||
        input.contains('bank') ||
        input.contains('money') ||
        input.contains('balance') ||
        input.contains('net worth') ||
        input.contains('save') ||
        input.contains('saving')) {
      return KnightIntent.analysis; // Mapping financial questions to analysis for now
    }

    // Calendar / Planner Intent
    if (input.contains('meeting') ||
        input.contains('appointment') ||
        input.contains('event') ||
        input.contains('calendar') ||
        input.contains('schedule') ||
        input.contains('tomorrow') ||
        input.contains('today') ||
        input.contains('next week')) {
      return KnightIntent.planning;
    }

    // Email Intent
    if (input.contains('email') ||
        input.contains('gmail') ||
        input.contains('message') ||
        input.contains('received') ||
        input.contains('inbox')) {
      return KnightIntent.search;
    }

    // Goals / Missions Intent
    if (input.contains('goal') ||
        input.contains('mission') ||
        input.contains('objective') ||
        input.contains('target') ||
        input.contains('achieve')) {
      return KnightIntent.planning;
    }

    // Career Intent
    if (input.contains('work') ||
        input.contains('session') ||
        input.contains('career') ||
        input.contains('skill') ||
        input.contains('focused') ||
        input.contains('job')) {
      return KnightIntent.analysis;
    }

    // Health Intent
    if (input.contains('step') ||
        input.contains('sleep') ||
        input.contains('activity') ||
        input.contains('health') ||
        input.contains('fitness') ||
        input.contains('heart rate') ||
        input.contains('weight')) {
      return KnightIntent.analysis;
    }

    // Travel Intent
    if (input.contains('travel') ||
        input.contains('trip') ||
        input.contains('flight') ||
        input.contains('hotel') ||
        input.contains('visit') ||
        input.contains('tour')) {
      return KnightIntent.analysis;
    }

    if (input.contains('should i') ||
        input.contains('decide') ||
        input.contains('choice')) {
      return KnightIntent.decision;
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

    if (input.startsWith('hi') ||
        input.startsWith('hello') ||
        input.startsWith('hey') ||
        input.contains('how are you') ||
        input.contains('good morning') ||
        input.contains('good evening') ||
        input.contains('thank you') ||
        input.contains('thanks') ||
        input.contains('bye') ||
        input.contains('goodbye') ||
        input == 'hi' ||
        input == 'hello') {
      return KnightIntent.conversation;
    }

    if (input.contains('what can you do') ||
        input.contains('help') ||
        input.contains('how to use') ||
        input.contains('features')) {
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
