import 'email_classifier.dart';

class SubscriptionClassifier implements EmailClassifier {
  @override
  String get id => 'subscription_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    final text = '$subject $snippet'.toLowerCase();
    
    final keywords = ['subscription', 'renew', 'membership', 'netflix', 'spotify', 'premium', 'plan', 'recurring'];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.9) : 0.0;
    
    if (text.contains('your subscription has been renewed')) {
      confidence = 0.99;
    }

    return ClassificationResult(
      category: 'subscription',
      confidence: confidence,
      reason: 'Matched $hits subscription keywords',
    );
  }
}
