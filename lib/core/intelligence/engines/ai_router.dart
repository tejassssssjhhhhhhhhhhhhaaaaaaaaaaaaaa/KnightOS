import '../domain/cognitive_models.dart';
import '../domain/ai_models.dart';
import 'ai_provider.dart';

/// Dynamically routes requests to the most appropriate AI model.
class AiRouter {
  final Map<String, KnightAiProvider> _providers = {};
  final Map<String, ModelManifest> _manifests = {};

  void registerProvider(KnightAiProvider provider, ModelManifest manifest) {
    _providers[manifest.id] = provider;
    _manifests[manifest.id] = manifest;
  }

  /// Selects the best provider for the given intent.
  KnightAiProvider selectProvider(KnightIntent intent) {
    // 1. Logic: Map intent to required capability
    final requiredCap = _getRequiredCapability(intent);

    // 2. Selection: Find first model matching the capability
    for (var entry in _manifests.entries) {
      if (entry.value.capabilities.contains(requiredCap)) {
        return _providers[entry.key]!;
      }
    }

    // Fallback to first available
    return _providers.values.first;
  }

  AiCapability _getRequiredCapability(KnightIntent intent) {
    switch (intent) {
      case KnightIntent.planning:
      case KnightIntent.decision:
      case KnightIntent.analysis:
        return AiCapability.precise;
      case KnightIntent.question:
      case KnightIntent.conversation:
        return AiCapability.fast;
      default:
        return AiCapability.fast;
    }
  }

  List<ModelManifest> get manifests => _manifests.values.toList();
}
