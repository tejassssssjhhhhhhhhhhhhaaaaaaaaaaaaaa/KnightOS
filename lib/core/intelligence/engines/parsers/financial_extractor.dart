import 'entity_extractor.dart';

class FinancialExtractor implements EntityExtractor {
  @override
  String get name => 'financial_heuristic';
  @override
  String get version => '1.0.0';

  @override
  bool canHandle(String category) => category == 'finance' || category == 'bill';

  @override
  Future<List<ExtractionResult>> extract(String subject, String snippet, Map<String, dynamic> rawMetadata) async {
    final results = <ExtractionResult>[];
    final text = '$subject $snippet'.toLowerCase();
    final messageId = rawMetadata['id'] as String? ?? 'unknown';
    final threadId = rawMetadata['threadId'] as String? ?? 'unknown';
    final accountId = rawMetadata['originAccount'] as String? ?? 'unknown';

    // 1. UPI Extraction
    if (text.contains('upi') || text.contains('vpa')) {
      final amount = _extractAmount(text);
      final merchant = _extractMerchant(text);
      
      if (amount != null) {
        results.add(ExtractionResult(
          title: 'UPI Payment to $merchant',
          summary: 'Amount: ₹$amount',
          type: 'transaction',
          subtype: 'upi',
          timestamp: _extractDate(rawMetadata),
          confidence: 0.9,
          reason: 'Matched UPI pattern and found amount',
          extractorName: name,
          extractorVersion: version,
          evidence: ExtractionEvidence(
            subject: subject,
            snippet: snippet,
            matchedRule: 'upi_regex',
            matchedPattern: 'rs. [\\d,.]+',
            messageId: messageId,
            threadId: threadId,
            accountId: accountId,
          ),
          searchTokens: {
            'merchant': merchant,
            'amount': amount.toString(),
            'method': 'upi',
          },
        ));
      }
    }

    return results;
  }

  double? _extractAmount(String text) {
    final regExp = RegExp(r'(?:rs|inr|₹)\.?\s*([\d,]+(?:\.\d{2})?)');
    final match = regExp.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)?.replaceAll(',', '') ?? '');
    }
    return null;
  }

  String _extractMerchant(String text) {
    final toMatch = RegExp(r'to\s+([a-z0-9\s&]{3,20})').firstMatch(text);
    return toMatch?.group(1)?.trim().toUpperCase() ?? 'UNKNOWN MERCHANT';
  }

  DateTime _extractDate(Map<String, dynamic> raw) {
    final dateStr = raw['internalDate']?.toString() ?? '0';
    return DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateStr) ?? DateTime.now().millisecondsSinceEpoch);
  }
}
