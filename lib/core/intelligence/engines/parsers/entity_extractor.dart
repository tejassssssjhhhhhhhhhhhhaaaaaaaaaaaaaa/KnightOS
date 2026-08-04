class ExtractionEvidence {
  final String subject;
  final String snippet;
  final String? bodySnippet;
  final String matchedRule;
  final String matchedPattern;
  final String messageId;
  final String threadId;
  final String accountId;

  const ExtractionEvidence({
    required this.subject,
    required this.snippet,
    this.bodySnippet,
    required this.matchedRule,
    required this.matchedPattern,
    required this.messageId,
    required this.threadId,
    required this.accountId,
  });
}

class ExtractionResult {
  final String title;
  final String? summary;
  final String type;
  final String subtype;
  final DateTime timestamp;
  final double confidence;
  final String reason;
  final ExtractionEvidence evidence;
  final Map<String, String> searchTokens;
  final String extractorName;
  final String extractorVersion;

  const ExtractionResult({
    required this.title,
    this.summary,
    required this.type,
    required this.subtype,
    required this.timestamp,
    required this.confidence,
    required this.reason,
    required this.evidence,
    required this.searchTokens,
    required this.extractorName,
    required this.extractorVersion,
  });
}

abstract class EntityExtractor {
  String get name;
  String get version;

  /// Returns true if this extractor can handle the given category.
  bool canHandle(String category);

  /// Performs extraction on the message metadata.
  Future<List<ExtractionResult>> extract(
    String subject, 
    String snippet, 
    Map<String, dynamic> rawMetadata,
  );
}
