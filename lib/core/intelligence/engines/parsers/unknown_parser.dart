import 'email_classifier.dart';

class UnknownClassifier implements EmailClassifier {
  @override
  String get id => 'unknown_v1';
  @override
  String get version => '1.0.0';

  @override
  Future<ClassificationResult> classify(String subject, String snippet) async {
    return const ClassificationResult(
      category: 'unknown',
      confidence: 0.1,
      reason: 'Default fallback',
    );
  }
}
