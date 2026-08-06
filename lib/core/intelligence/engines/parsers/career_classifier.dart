import 'email_classifier.dart';

class CareerClassifier implements EmailClassifier {
  @override
  String get id => 'career_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    final text = '$subject $snippet'.toLowerCase();
    
    // Keywords for Career
    final keywords = [
      'job', 'application', 'interview', 'offer', 'hiring', 'recruiter', 'linkedin',
      'resume', 'cv', 'experience', 'salary', 'contract', 'employment', 'position',
      'certification', 'training', 'course', 'learning', 'skill', 'assessment',
      'naukri', 'indeed', 'glassdoor', 'work'
    ];
    int hits = 0;
    for (final kw in keywords) {
      if (text.contains(kw)) hits++;
    }

    double confidence = hits > 0 ? (hits / keywords.length).clamp(0.0, 0.9) : 0.0;
    
    // Strong matches
    if (text.contains('interview invitation') || 
        text.contains('application received') || 
        text.contains('job offer') ||
        text.contains('congratulations on your new role')) {
      confidence = 0.95;
    }

    return ClassificationResult(
      category: 'career',
      confidence: confidence,
      reason: 'Matched $hits career keywords',
    );
  }
}
