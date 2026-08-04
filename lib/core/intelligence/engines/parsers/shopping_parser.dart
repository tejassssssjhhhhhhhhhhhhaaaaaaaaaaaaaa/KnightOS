import 'email_classifier.dart';

class ShoppingClassifier implements EmailClassifier {
  @override
  String get id => 'shopping_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    final text = '$subject $snippet'.toLowerCase();
    
    final keywords = ['order', 'amazon', 'flipkart', 'shipped', 'delivered', 'purchase', 'receipt', 'invoice'];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.9) : 0.0;
    
    if (text.contains('your amazon.in order') || text.contains('out for delivery')) {
      confidence = 0.95;
    }

    return ClassificationResult(
      category: 'shopping',
      confidence: confidence,
      reason: 'Matched $hits shopping keywords',
    );
  }
}
