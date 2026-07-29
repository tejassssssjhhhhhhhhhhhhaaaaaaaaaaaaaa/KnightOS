import 'package:flutter/foundation.dart';

/// Performance and capability markers for AI models.
enum AiCapability {
  fast,
  precise,
  longContext,
  imageAware,
  audioAware,
  locallyHosted,
}

/// Static metadata for a specific AI model deployment.
@immutable
class ModelManifest {
  const ModelManifest({
    required this.id,
    required this.name,
    required this.capabilities,
    required this.providerName,
    this.estimatedLatencyMs = 500,
  });

  final String id;
  final String name;
  final List<AiCapability> capabilities;
  final String providerName;
  final int estimatedLatencyMs;
}
