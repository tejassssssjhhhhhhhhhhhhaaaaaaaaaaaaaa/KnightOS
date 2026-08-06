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

    // 2. Hotel Booking
    if (text.contains('hotel') || text.contains('check-in') || text.contains('stay')) {
       results.add(ExtractionResult(
        title: 'Hotel Reservation: ${_extractLocation(text)}',
        summary: 'Detected hotel stay details',
        type: 'booking',
        subtype: 'hotel',
        timestamp: _extractDate(rawMetadata),
        confidence: 0.8,
        reason: 'Matched hotel keywords',
        extractorName: name,
        extractorVersion: version,
        evidence: ExtractionEvidence(
          subject: subject,
          snippet: snippet,
          matchedRule: 'hotel_keyword',
          matchedPattern: 'hotel|check-in',
          messageId: messageId,
          threadId: threadId,
          accountId: accountId,
        ),
        searchTokens: {
          'location': _extractLocation(text),
        },
      ));
    }

    // 3. Train/Bus Booking
    if (text.contains('pnr') && (text.contains('irctc') || text.contains('bus') || text.contains('redbus'))) {
       results.add(ExtractionResult(
        title: 'Travel Booking: $pnr',
        summary: 'Detected train or bus booking',
        type: 'booking',
        subtype: text.contains('irctc') ? 'train' : 'bus',
        timestamp: _extractDate(rawMetadata),
        confidence: 0.9,
        reason: 'Matched transport PNR',
        extractorName: name,
        extractorVersion: version,
        evidence: ExtractionEvidence(
          subject: subject,
          snippet: snippet,
          matchedRule: 'transport_pnr',
          matchedPattern: 'pnr',
          messageId: messageId,
          threadId: threadId,
          accountId: accountId,
        ),
        searchTokens: {
          'pnr': pnr ?? 'UNKNOWN',
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

  String _extractLocation(String text) {
    final cities = ['mumbai', 'delhi', 'bangalore', 'pune', 'goa', 'chennai', 'hyderabad', 'kolkata'];
    for (final city in cities) {
      if (text.contains(city)) return city.toUpperCase();
    }
    return 'UNKNOWN LOCATION';
  }

  DateTime _extractDate(Map<String, dynamic> raw) {
    final dateStr = raw['internalDate']?.toString() ?? '0';
    return DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateStr) ?? DateTime.now().millisecondsSinceEpoch);
  }
}
