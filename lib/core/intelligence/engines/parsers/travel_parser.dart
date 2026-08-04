import 'email_classifier.dart';

class TravelClassifier implements EmailClassifier {
  @override
  String get id => 'travel_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    final text = '$subject $snippet'.toLowerCase();
    
    final keywords = ['flight', 'boarding', 'airline', 'pnr', 'ticket', 'indigo', 'air india', 'trip', 'itinerary'];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.9) : 0.0;
    
    if (text.contains('pnr:') || text.contains('boarding pass')) {
      confidence = 0.98;
    }

    return ClassificationResult(
      category: 'travel',
      confidence: confidence,
      reason: 'Matched $hits travel keywords',
    );
  }
}
