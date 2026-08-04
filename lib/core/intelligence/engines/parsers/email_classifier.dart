class ClassificationResult {
  final String category;
  final double confidence;
  final String reason;

  const ClassificationResult({
    required this.category,
    required this.confidence,
    required this.reason,
  });
}

abstract class EmailClassifier {
  String get id;
  String get version;

  /// Returns confidence score (0-1) for this email.
  Future<ClassificationResult> classify(String subject, String snippet);
}
