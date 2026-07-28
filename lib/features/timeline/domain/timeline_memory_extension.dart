import 'timeline_entry.dart';

/// Interface for semantic search and retrieval from the timeline.
abstract class TimelineSearchService {
  /// Searches for entries matching a semantic query.
  Future<List<TimelineEntry>> search(String query);

  /// Retrieves contextually relevant entries for a given date or topic.
  Future<List<TimelineEntry>> getContext(
    DateTime timestamp, {
    List<TimelineCategory>? categories,
  });
}

/// Interface for generating high-level summaries and life insights.
abstract class TimelineSummaryService {
  /// Generates a summary for a specific time period.
  Future<String> summarizePeriod(DateTime start, DateTime end);

  /// Identifies trends and recurring themes in the timeline.
  Future<List<String>> identifyThemes();
}

/// Interface for linking timeline entries to AI conversations.
abstract class TimelineChatLinkService {
  /// Links a specific chat message or conversation to a timeline entry.
  Future<void> linkToEntry(String entryId, String conversationId);

  /// Retrieves conversations linked to a specific timeline entry.
  Future<List<String>> getLinkedConversations(String entryId);
}
