import 'entity_extractor.dart';

class TravelExtractor implements EntityExtractor {
  @override
  String get name => 'travel_heuristic';
  @override
  String get version => '1.0.0';

  @override
  bool canHandle(String category) => category == 'travel';

  @override
  Future<List<ExtractionResult>> extract(String subject, String snippet, Map<String, dynamic> rawMetadata) async {
    final results = <ExtractionResult>[];
    final text = '$subject $snippet'.toLowerCase();
    final messageId = rawMetadata['id'] as String? ?? 'unknown';
    final threadId = rawMetadata['threadId'] as String? ?? 'unknown';
    final accountId = rawMetadata['originAccount'] as String? ?? 'unknown';

    final pnr = _extractPNR(text);
    if (pnr != null) {
      results.add(ExtractionResult(
        title: 'Flight Booking: $pnr',
        summary: 'Detected PNR from email snippet',
        type: 'booking',
        subtype: 'flight',
        timestamp: _extractDate(rawMetadata),
        confidence: 0.95,
        reason: 'Confirmed PNR pattern match',
        extractorName: name,
        extractorVersion: version,
        evidence: ExtractionEvidence(
          subject: subject,
          snippet: snippet,
          matchedRule: 'pnr_regex',
          matchedPattern: '[a-z][a-z0-9]{5}',
          messageId: messageId,
          threadId: threadId,
          accountId: accountId,
        ),
        searchTokens: {
          'pnr': pnr,
          'airline': _extractAirline(text),
        },
      ));
    }

    return results;
  }

  String? _extractPNR(String text) {
    final match = RegExp(r'pnr[:\s]+([a-z][a-z0-9]{5})').firstMatch(text);
    return match?.group(1)?.toUpperCase();
  }

  String _extractAirline(String text) {
    final airlines = ['indigo', 'air india', 'vistara', 'spicejet', 'emirates', 'qatar'];
    for (final airline in airlines) {
      if (text.contains(airline)) return airline.toUpperCase();
    }
    return 'UNKNOWN AIRLINE';
  }

  DateTime _extractDate(Map<String, dynamic> raw) {
    final dateStr = raw['internalDate']?.toString() ?? '0';
    return DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateStr) ?? DateTime.now().millisecondsSinceEpoch);
  }
}
