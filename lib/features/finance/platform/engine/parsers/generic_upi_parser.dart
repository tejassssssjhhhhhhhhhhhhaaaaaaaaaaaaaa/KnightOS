import '../../interfaces/finance_parser.dart';
import '../../models/extraction_result.dart';

class GenericUpiParser implements IFinanceParser {
  @override
  String get institutionId => 'upi_generic';
  @override
  String get version => '1.0.0';

  @override
  bool canHandle(String sender, String subject, String body) {
    final text = '$subject $body'.toLowerCase();
    final financialKeywords = [
      'upi', 'vpa', 'transaction', 'debited', 'credited', 'spent',
      'rs.', 'inr', '₹', 'bank', 'statement', 'account'
    ];
    return financialKeywords.any((kw) => text.contains(kw));
  }

  @override
  Future<ExtractionResult> parse(String messageId, String subject, String body, DateTime timestamp) async {
    final text = '$subject $body'.toLowerCase();
    
    final amount = _extractAmount(text);
    final merchant = _extractMerchant(text);
    final ref = _extractRef(text);

    return ExtractionResult(
      messageId: messageId,
      amount: amount,
      merchant: merchant,
      referenceNumber: ref,
      date: timestamp,
      institution: 'UPI',
      parserVersion: version,
      confidenceLevel: amount != null ? ConfidenceLevel.high : ConfidenceLevel.low,
      confidenceScore: amount != null ? 0.95 : 0.2,
      rawExtractedData: {
        'subject': subject,
        'has_amount': amount != null,
      },
    );
  }

  double? _extractAmount(String text) {
    final regExp = RegExp(r'(?:rs|inr|₹)\.?\s*([\d,]+(?:\.\d{2})?)', caseSensitive: false);
    final match = regExp.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)?.replaceAll(',', '') ?? '');
    }
    return null;
  }

  String? _extractMerchant(String text) {
    final toMatch = RegExp(r'to\s+([a-z0-9\s&]{3,20})', caseSensitive: false).firstMatch(text);
    return toMatch?.group(1)?.trim().toUpperCase();
  }

  String? _extractRef(String text) {
    final refMatch = RegExp(r'(?:ref|id|number)\s*[:#]?\s*([a-z0-9]{4,20})', caseSensitive: false).firstMatch(text);
    return refMatch?.group(1);
  }
}
