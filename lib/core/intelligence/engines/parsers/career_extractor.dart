import 'entity_extractor.dart';

class CareerExtractor implements EntityExtractor {
  @override
  String get name => 'career_heuristic';
  @override
  String get version => '1.0.0';

  @override
  bool canHandle(String category) => category == 'career';

  @override
  Future<List<ExtractionResult>> extract(String subject, String snippet, Map<String, dynamic> rawMetadata) async {
    final results = <ExtractionResult>[];
    final text = '$subject $snippet'.toLowerCase();
    final messageId = rawMetadata['id'] as String? ?? 'unknown';
    final threadId = rawMetadata['threadId'] as String? ?? 'unknown';
    final accountId = rawMetadata['originAccount'] as String? ?? 'unknown';

    // 1. Job Applications
    if (text.contains('application') || text.contains('applied')) {
      results.add(ExtractionResult(
        title: 'Job Application: ${_extractOrganization(text)}',
        summary: 'Detected job application submission',
        type: 'career_event',
        subtype: 'application',
        timestamp: _extractDate(rawMetadata),
        confidence: 0.9,
        reason: 'Matched application keywords',
        extractorName: name,
        extractorVersion: version,
        evidence: ExtractionEvidence(
          subject: subject,
          snippet: snippet,
          matchedRule: 'application_keyword',
          matchedPattern: 'application|applied',
          messageId: messageId,
          threadId: threadId,
          accountId: accountId,
        ),
        searchTokens: {
          'organization': _extractOrganization(text),
        },
      ));
    }

    // 2. Interviews
    if (text.contains('interview') || text.contains('invitation')) {
      results.add(ExtractionResult(
        title: 'Interview Invitation: ${_extractOrganization(text)}',
        summary: 'Detected interview request',
        type: 'career_event',
        subtype: 'interview',
        timestamp: _extractDate(rawMetadata),
        confidence: 0.95,
        reason: 'Matched interview keywords',
        extractorName: name,
        extractorVersion: version,
        evidence: ExtractionEvidence(
          subject: subject,
          snippet: snippet,
          matchedRule: 'interview_keyword',
          matchedPattern: 'interview',
          messageId: messageId,
          threadId: threadId,
          accountId: accountId,
        ),
        searchTokens: {
          'organization': _extractOrganization(text),
        },
      ));
    }

    // 3. Learning / Certifications
    if (text.contains('certificate') || text.contains('completed') || text.contains('course')) {
       results.add(ExtractionResult(
        title: 'Learning Completion: $subject',
        summary: 'Detected course or certification completion',
        type: 'career_event',
        subtype: 'learning',
        timestamp: _extractDate(rawMetadata),
        confidence: 0.8,
        reason: 'Matched learning keywords',
        extractorName: name,
        extractorVersion: version,
        evidence: ExtractionEvidence(
          subject: subject,
          snippet: snippet,
          matchedRule: 'learning_keyword',
          matchedPattern: 'certificate|course|completed',
          messageId: messageId,
          threadId: threadId,
          accountId: accountId,
        ),
        searchTokens: {
          'title': subject,
        },
      ));
    }

    return results;
  }

  String _extractOrganization(String text) {
    // Very simple extraction for now
    final organizations = ['google', 'microsoft', 'amazon', 'apple', 'meta', 'netflix', 'uber', 'linkedin'];
    for (final org in organizations) {
      if (text.contains(org)) return org.toUpperCase();
    }
    return 'UNKNOWN ORGANIZATION';
  }

  DateTime _extractDate(Map<String, dynamic> raw) {
    final dateStr = raw['internalDate']?.toString() ?? '0';
    return DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateStr) ?? DateTime.now().millisecondsSinceEpoch);
  }
}
