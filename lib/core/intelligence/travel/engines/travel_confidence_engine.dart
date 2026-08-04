class TravelConfidenceEngine {
  /// Calculates confidence using evidence fusion.
  /// Higher scores are assigned when multiple independent sources confirm the same event.
  double calculateConfidence({
    required List<String> sourceConnectorIds,
    bool isVerifiedByUser = false,
  }) {
    if (isVerifiedByUser) return 1.0;
    if (sourceConnectorIds.isEmpty) return 0.0;

    final uniqueSources = sourceConnectorIds.toSet().length;
    
    // Confidence distribution based on source count and variety
    if (uniqueSources >= 4) return 0.95; // Gmail + Photos + Maps + Finance
    if (uniqueSources == 3) return 0.90;
    if (uniqueSources == 2) return 0.80;
    return 0.60; // Single evidence source
  }

  /// Provides a human-readable explanation for the confidence score.
  String getConfidenceReason(List<String> sourceConnectorIds) {
    if (sourceConnectorIds.isEmpty) return 'No evidence found.';
    final uniqueSources = sourceConnectorIds.toSet();
    if (uniqueSources.length >= 2) {
      return 'Confirmed by multiple sources: ${uniqueSources.join(', ')}.';
    }
    return 'Single evidence source: ${uniqueSources.first}.';
  }
}
