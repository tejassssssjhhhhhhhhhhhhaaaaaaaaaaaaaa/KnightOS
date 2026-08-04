import 'email_classifier.dart';

class PersonalClassifier implements EmailClassifier {
  @override
  String get id => 'personal_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    // Usually harder to detect, we'll look for conversational markers.
    final text = '$subject $snippet'.toLowerCase();
    
    final keywords = ['hi ', 'hey', 'dear', 'how are you', 'regards', 'thanks', 'best', 'see you'];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.6) : 0.0;

    return ClassificationResult(
      category: 'personal',
      confidence: confidence,
      reason: 'Matched $hits conversational markers',
    );
  }
}
