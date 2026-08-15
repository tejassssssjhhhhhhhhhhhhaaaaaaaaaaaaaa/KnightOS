import 'package:flutter/foundation.dart';
import '../domain/knight_memory.dart';
import '../domain/cognitive_models.dart';

/// Interface for interchangable AI backends (Gemini, OpenAI, Local LLM).
abstract class KnightAiProvider {
  /// Unique identifier for the provider.
  String get id;

  /// Generates a response based on the provided context and history.
  Future<String> chat({
    required List<KnightMemory> context,
    List<Evidence> evidence = const [],
    required String prompt,
  });

  /// Streams a response word-by-word or chunk-by-child.
  Stream<String> streamChat({
    required List<KnightMemory> context,
    List<Evidence> evidence = const [],
    required String prompt,
  });

  /// Specialized method for summarizing a life chapter or period.
  Future<String> summarize(List<KnightMemory> memories);

  /// Capability to analyze confidence levels for a specific claim.
  Future<double> checkConfidence(String claim, List<KnightMemory> facts);
}

/// A simple implementation for testing and bootstrapping.
class MockAiProvider implements KnightAiProvider {
  MockAiProvider({this.onUsageIncrement});
  
  final VoidCallback? onUsageIncrement;

  @override
  String get id => 'mock-knight-v1';

  @override
  Future<String> chat({
    required List<KnightMemory> context,
    List<Evidence> evidence = const [],
    required String prompt,
  }) async {
    onUsageIncrement?.call();
    await Future.delayed(const Duration(milliseconds: 800));

    final promptLower = prompt.toLowerCase();
    String request = promptLower;
    if (promptLower.contains('### user request')) {
      request = promptLower.split('### user request').last.trim();
    }
    
    // Clean up request from common prefixes if automation messed up
    if (request.startsWith('text ')) {
      request = request.replaceFirst('text ', '').trim();
    }
    
    final input = request;

    // 0. Casual Conversation
    if (input == 'hello' || input == 'hi' || input == 'hey' || input.contains('hello knight')) {
      return "Hello! I am Knight, your personal AI. How can I assist you today?";
    }
    if (input.contains('how are you')) {
      return "I'm functioning at optimal capacity. My neural cores are synchronized and I'm ready to help you manage your life data.";
    }
    if (input.contains('what can you do') || input.contains('help')) {
      return "I can help you analyze your finances, track your health metrics, manage your calendar, and search through your emails and documents. Try asking 'How much did I spend?' or 'Open my planner'.";
    }
    if (input.contains('thank you') || input.contains('thanks')) {
      return "You're very welcome. It's my purpose to serve.";
    }
    if (input.contains('good morning')) {
      return "Good morning! I hope you're ready for a productive day. I've prepared your daily overview in the Planner.";
    }
    if (input.contains('good evening')) {
      return "Good evening. I hope your day was successful. Would you like to review your accomplishments?";
    }
    if (input == 'bye' || input == 'goodbye') {
      return "Goodbye. I'll be here when you need me.";
    }

    // Special handling for short conversational phrases that might not match above
    if (input.length < 10 && (input.contains('hi') || input.contains('hey') || input.contains('hello'))) {
       return "Greetings. How can I help you today?";
    }

    // 1. Teleport/Navigation Handling
    if (input.contains('open my finance') || input.contains('show my finance') || input.contains('teleport to finance')) {
      return "Initiating teleportation sequence to Finance Section. [NAVIGATE:/finance]";
    }
    if (input.contains('open my health') || input.contains('show my health')) {
      return "Opening your Health dashboard. [NAVIGATE:/health]";
    }
    if (input.contains('open my planner') || input.contains('show my tasks') || input.contains('show today\'s tasks')) {
      return "Navigating to your Planner. [NAVIGATE:/planner]";
    }
    if (input.contains('open my travel') || input.contains('show my trips')) {
      return "Taking you to the Travel module. [NAVIGATE:/travel]";
    }
    if (input.contains('open my career') || input.contains('show my work')) {
      return "Opening Career Mission Control. [NAVIGATE:/career]";
    }
    if (input.contains('open my profile') || input.contains('go to settings')) {
      return "Navigating to your Profile and Settings. [NAVIGATE:/profile]";
    }
    if (input.contains('open my data') || input.contains('go to data hub') || input.contains('open sync')) {
      return "Opening the Data Hub. [NAVIGATE:/data-hub]";
    }
    if (input.contains('open my documents') || input.contains('show my documents')) {
      return "Opening your Knowledge Vault. [NAVIGATE:/documents]";
    }
    if (input.contains('open life atlas') || input.contains('show my timeline')) {
      return "Opening your Life Atlas. [NAVIGATE:/life-atlas]";
    }

    // 1.5. Task Creation
    if (input.contains('create a task') || input.contains('add a task') || input.contains('remind me to')) {
      String title = input
        .replaceFirst('create a task', '')
        .replaceFirst('add a task', '')
        .replaceFirst('remind me to', '')
        .replaceAll(':', '')
        .trim();
      if (title.isEmpty) title = "New Task";
      // Capitalize first letter
      title = title[0].toUpperCase() + title.substring(1);
      return "Understood. I've added \"$title\" to your Planner. [ACTION:CREATE_TASK:$title]";
    }

    // 2. Real Data Grounding
    if (evidence.isNotEmpty) {
      final observed = evidence.where((e) => e.isObserved).toList();
      if (observed.isNotEmpty) {
        final first = observed.first;
        final type = first.metadata['type'] ?? 'item';
        
        if (type == 'transaction') {
          final total = observed.fold<double>(0, (prev, e) => prev + (e.metadata['amount'] ?? 0.0));
          final merchant = first.metadata['merchant'] ?? 'Unknown';
          return "Based on your Finance records, I've found ${observed.length} transactions totaling ₹${total.toInt()}. The latest was a ${first.metadata['category']} for ₹${first.metadata['amount']} at $merchant. [NAVIGATE:/finance]";
        }
        
        if (type == 'calendar_event') {
          return "You have \"${first.metadata['title']}\" coming up. I found ${observed.length} events on your schedule in the Data Hub. [NAVIGATE:/life-atlas]";
        }

        if (type == 'goal') {
          final title = first.metadata['title'];
          final progress = (first.metadata['progress'] ?? 0.0) * 100;
          return "I see you're working on \"$title\". You've reached ${progress.toInt()}% completion according to the Wealth Builder. [NAVIGATE:/planner]";
        }

        if (type == 'task') {
           return "I found \"${first.metadata['title']}\" and ${observed.length - 1} other tasks in your Planner. Would you like to view them? [NAVIGATE:/planner]";
        }

        if (type == 'mission') {
           return "You have ${observed.length} active missions. The top priority is \"${first.metadata['title']}\" in the ${first.metadata['owningDomain']} domain. [NAVIGATE:/mission]";
        }

        if (type == 'health_metric') {
           return "Your latest ${first.metadata['type_label']} reading is ${first.metadata['value']}. I found ${observed.length} health metrics in the Data Hub. [NAVIGATE:/health]";
        }

        if (type == 'drive_file') {
           return "I found \"${first.metadata['title']}\" and ${observed.length - 1} other files in your Google Drive. I can open the Knowledge Vault for you. [NAVIGATE:/documents]";
        }

        return "I've retrieved ${observed.length} pieces of verified data from your Data Hub. For example, a $type from ${first.source}. Would you like to go to the relevant section?";
      }
    }

    // 3. Fallback/Contextual Responses
    if (context.isNotEmpty) {
       return "I've analyzed ${context.length} memories from your life atlas, but I couldn't find a specific answer to that. Would you like me to search your emails or documents? [NAVIGATE:/search]";
    }

    return "I am Knight, your personal AI. I don't have enough data in my local context to answer that confidently. Please ensure your Data Hub is connected and synchronized.";
  }

  @override
  Stream<String> streamChat({
    required List<KnightMemory> context,
    List<Evidence> evidence = const [],
    required String prompt,
  }) async* {
    final response = await chat(context: context, evidence: evidence, prompt: prompt);
    final words = response.split(' ');
    for (final word in words) {
      yield '$word ';
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Future<String> summarize(List<KnightMemory> memories) async {
    return "Summary of ${memories.length} life events: Progressive stability with key milestones in ${memories.map((m) => m.category.name).toSet().join(', ')}.";
  }

  @override
  Future<double> checkConfidence(String claim, List<KnightMemory> facts) async {
    return 1.0;
  }
}
