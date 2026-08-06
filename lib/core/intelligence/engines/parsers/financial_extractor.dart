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

    // 1. Transaction Alert Extraction (UPI, Card, NetBanking)
    if (text.contains('upi') || text.contains('vpa') || text.contains('spent') || text.contains('credited') || text.contains('debited')) {
      final amount = _extractAmount(text);
      final merchant = _extractMerchant(text);
      
      if (amount != null) {
        String type = text.contains('credited') ? 'income' : 'expense';
        
        results.add(ExtractionResult(
          title: '${type == 'income' ? 'Received from' : 'Payment to'} $merchant',
          summary: 'Amount: ₹$amount',
          type: 'transaction',
          subtype: text.contains('upi') ? 'upi' : 'banking',
          timestamp: _extractDate(rawMetadata),
          confidence: 0.9,
          reason: 'Matched financial pattern and found amount',
          extractorName: name,
          extractorVersion: version,
          evidence: ExtractionEvidence(
            subject: subject,
            snippet: snippet,
            matchedRule: 'banking_regex',
            matchedPattern: 'rs. [\\d,.]+',
            messageId: messageId,
            threadId: threadId,
            accountId: accountId,
          ),
          searchTokens: {
            'merchant': merchant,
            'amount': amount.toString(),
            'method': text.contains('upi') ? 'upi' : 'bank',
            'type': type,
          },
        ));
      }
    }

    // 2. Investment & SIP Detection
    if (text.contains('mutual fund') || text.contains('sip') || text.contains('stock') || text.contains('zerodha')) {
      final amount = _extractAmount(text);
      if (amount != null) {
        results.add(ExtractionResult(
          title: 'Investment: ${_extractMerchant(text)}',
          summary: 'Amount: ₹$amount',
          type: 'transaction',
          subtype: 'investment',
          timestamp: _extractDate(rawMetadata),
          confidence: 0.85,
          reason: 'Detected investment keywords and amount',
          extractorName: name,
          extractorVersion: version,
          evidence: ExtractionEvidence(
            subject: subject,
            snippet: snippet,
            matchedRule: 'investment_keywords',
            matchedPattern: 'mutual fund|sip|stock',
            messageId: messageId,
            threadId: threadId,
            accountId: accountId,
          ),
          searchTokens: {
            'merchant': _extractMerchant(text),
            'amount': amount.toString(),
            'type': 'expense',
            'category': 'investment',
          },
        ));
      }
    }

    // 3. Loan & EMI Detection
    if (text.contains('emi') || text.contains('loan') || text.contains('mortgage')) {
      final amount = _extractAmount(text);
      if (amount != null) {
         results.add(ExtractionResult(
          title: 'EMI Payment: ${_extractMerchant(text)}',
          summary: 'Amount: ₹$amount',
          type: 'transaction',
          subtype: 'loan',
          timestamp: _extractDate(rawMetadata),
          confidence: 0.85,
          reason: 'Detected loan/EMI keywords and amount',
          extractorName: name,
          extractorVersion: version,
          evidence: ExtractionEvidence(
            subject: subject,
            snippet: snippet,
            matchedRule: 'loan_keywords',
            matchedPattern: 'emi|loan|mortgage',
            messageId: messageId,
            threadId: threadId,
            accountId: accountId,
          ),
          searchTokens: {
            'merchant': _extractMerchant(text),
            'amount': amount.toString(),
            'type': 'expense',
            'category': 'loan',
          },
        ));
      }
    }

    return results;
  }

  double? _extractAmount(String text) {
    // Matches Rs. 100, INR 100, ₹100, 100.00
    final regExp = RegExp(r'(?:rs|inr|₹|amount)\.?\s*([\d,]+(?:\.\d{2})?)', caseSensitive: false);
    final match = regExp.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)?.replaceAll(',', '') ?? '');
    }
    return null;
  }

  String _extractMerchant(String text) {
    // Look for common merchant prefixes
    final toMatch = RegExp(r'(?:to|at|vpa|merchant|payee)\s+([a-z0-9\s&.\-]{3,30})', caseSensitive: false).firstMatch(text);
    if (toMatch != null) {
      return toMatch.group(1)!.trim().toUpperCase();
    }
    
    // Fallback: search for common institutions if merchant not found
    final banks = ['hdfc', 'icici', 'sbi', 'axis', 'amazon', 'flipkart', 'zomato', 'swiggy', 'uber', 'ola'];
    for (final bank in banks) {
      if (text.contains(bank)) return bank.toUpperCase();
    }

    return 'UNKNOWN MERCHANT';
  }

  DateTime _extractDate(Map<String, dynamic> raw) {
    final dateStr = raw['internalDate']?.toString() ?? '0';
    return DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateStr) ?? DateTime.now().millisecondsSinceEpoch);
  }
}
