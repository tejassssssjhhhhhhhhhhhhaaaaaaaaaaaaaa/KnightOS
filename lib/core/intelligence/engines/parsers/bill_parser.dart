import 'email_classifier.dart';

class BillClassifier implements EmailClassifier {
  @override
  String get id => 'bill_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    final text = '$subject $snippet'.toLowerCase();
    
    final keywords = ['bill', 'invoice', 'due', 'electric', 'water', 'internet', 'broadband', 'mobile bill', 'postpaid'];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.9) : 0.0;
    
    if (text.contains('bill due') || text.contains('amount due:')) {
      confidence = 0.92;
    }

    return ClassificationResult(
      category: 'bill',
      confidence: confidence,
      reason: 'Matched $hits billing keywords',
    );
  }
}
