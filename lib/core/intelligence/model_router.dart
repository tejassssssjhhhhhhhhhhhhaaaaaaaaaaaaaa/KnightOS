import '../storage/privacy_vault.dart';

enum IntelligenceModel {
  localSLM,
  cloudLLM,
  specializedExpert,
}

/// Orchestrates routing of AI queries based on privacy, cost, and complexity.
class ModelRouter {
  /// Determines which model to use for a given data classification.
  IntelligenceModel route(PrivacyClassification classification, {bool forceLocal = false}) {
    if (forceLocal || classification == PrivacyClassification.highlySensitive) {
      return IntelligenceModel.localSLM;
    }
    
    if (classification == PrivacyClassification.sensitive) {
      // Sensitive data can be processed by LLM only if anonymized, 
      // but we prefer local or specialized experts for now.
      return IntelligenceModel.localSLM;
    }

    return IntelligenceModel.cloudLLM;
  }
}
