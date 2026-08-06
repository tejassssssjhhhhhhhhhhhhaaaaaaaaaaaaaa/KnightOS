import 'email_classifier.dart';

class FinanceClassifier implements EmailClassifier {
  @override
  String get id => 'finance_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    final text = '$subject $snippet'.toLowerCase();
    
    // Keywords
    final keywords = [
      'bank', 'account', 'statement', 'transaction', 'upi', 'credited', 'debited', 
      'wallet', 'payment', 'spent', 'bill', 'invoice', 'order', 'refund', 'card', 'hdfc', 'icici', 'sbi',
      'investment', 'stock', 'mutual fund', 'portfolio', 'sip', 'demat', 'zerodha', 'groww',
      'loan', 'emi', 'mortgage', 'interest', 'insurance', 'premium', 'policy', 'tax', 'tds', 'income tax'
    ];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.9) : 0.0;
    
    // Strong matches
    if (text.contains('statement') || 
        text.contains('credited to your account') || 
        text.contains('transaction alert') ||
        text.contains('spent on your card')) {
      confidence = 0.95;
    }

    return ClassificationResult(
      category: 'finance',
      confidence: confidence,
      reason: 'Matched $hits financial keywords',
    );
  }
}
