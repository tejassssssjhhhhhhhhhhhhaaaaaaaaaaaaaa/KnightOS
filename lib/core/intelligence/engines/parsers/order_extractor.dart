import 'entity_extractor.dart';

class OrderExtractor implements EntityExtractor {
  @override
  String get name => 'order_heuristic';
  @override
  String get version => '1.0.0';

  @override
  bool canHandle(String category) => category == 'shopping' || category == 'food';

  @override
  Future<List<ExtractionResult>> extract(String subject, String snippet, Map<String, dynamic> rawMetadata) async {
    final results = <ExtractionResult>[];
    final text = '$subject $snippet'.toLowerCase();
    final messageId = rawMetadata['id'] as String? ?? 'unknown';
    final threadId = rawMetadata['threadId'] as String? ?? 'unknown';
    final accountId = rawMetadata['originAccount'] as String? ?? 'unknown';

    final orderId = _extractOrderId(text);
    final merchant = _extractMerchant(text);

    if (orderId != null) {
      results.add(ExtractionResult(
        title: 'Order $orderId at $merchant',
        summary: 'Detected from confirmation email',
        type: 'order',
        subtype: text.contains('amazon') || text.contains('flipkart') ? 'shopping' : 'food',
        timestamp: _extractDate(rawMetadata),
        confidence: 0.85,
        reason: 'Matched order ID and merchant keywords',
        extractorName: name,
        extractorVersion: version,
        evidence: ExtractionEvidence(
          subject: subject,
          snippet: snippet,
          matchedRule: 'order_id_regex',
          matchedPattern: '[0-9-]{10,}',
          messageId: messageId,
          threadId: threadId,
          accountId: accountId,
        ),
        searchTokens: {
          'order_id': orderId,
          'merchant': merchant,
        },
      ));
    }

    return results;
  }

  String? _extractOrderId(String text) {
    final amzMatch = RegExp(r'(\d{3}-\d{7}-\d{7})').firstMatch(text);
    if (amzMatch != null) return amzMatch.group(1);
    final genericMatch = RegExp(r'order (?:no|number)[:\s]+([a-z0-9-]{8,})').firstMatch(text);
    return genericMatch?.group(1)?.toUpperCase();
  }

  String _extractMerchant(String text) {
    final merchants = ['amazon', 'flipkart', 'swiggy', 'zomato', 'myntra', 'uber', 'ola'];
    for (final m in merchants) {
      if (text.contains(m)) return m.toUpperCase();
    }
    return 'UNKNOWN MERCHANT';
  }

  DateTime _extractDate(Map<String, dynamic> raw) {
    final dateStr = raw['internalDate']?.toString() ?? '0';
    return DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateStr) ?? DateTime.now().millisecondsSinceEpoch);
  }
}
