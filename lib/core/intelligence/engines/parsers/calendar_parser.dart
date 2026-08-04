import 'email_classifier.dart';

class CalendarClassifier implements EmailClassifier {
  @override
  String get id => 'calendar_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    final text = '$subject $snippet'.toLowerCase();
    
    final keywords = ['meeting', 'invite', 'calendar', 'google calendar', 'zoom', 'teams', 'scheduled', 'appointment'];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.9) : 0.0;
    
    if (text.contains('invitation:') || text.contains('has invited you')) {
      confidence = 0.95;
    }

    return ClassificationResult(
      category: 'calendar',
      confidence: confidence,
      reason: 'Matched $hits meeting keywords',
    );
  }
}
