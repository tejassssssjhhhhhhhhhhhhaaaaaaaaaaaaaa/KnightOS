import 'email_classifier.dart';

class PromotionClassifier implements EmailClassifier {
  @override
  String get id => 'promotion_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    final text = '$subject $snippet'.toLowerCase();
    
    final keywords = ['offer', 'discount', 'sale', 'off', 'deal', 'promo', 'coupon', 'exclusive', 'newsletter'];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.8) : 0.0;

    return ClassificationResult(
      category: 'promotion',
      confidence: confidence,
      reason: 'Matched $hits promotional keywords',
    );
  }
}
