import 'email_classifier.dart';

class DocumentClassifier implements EmailClassifier {
  @override
  String get id => 'document_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    final text = '$subject $snippet'.toLowerCase();
    
    final keywords = ['pdf', 'document', 'attached', 'form', 'contract', 'agreement', 'report', 'application'];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.7) : 0.0;

    return ClassificationResult(
      category: 'document',
      confidence: confidence,
      reason: 'Matched $hits document keywords',
    );
  }
}
