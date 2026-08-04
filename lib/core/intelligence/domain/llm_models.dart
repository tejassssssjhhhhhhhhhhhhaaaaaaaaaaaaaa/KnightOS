import 'package:flutter/foundation.dart';

/// Supported local LLM model types.
enum LlmModelType {
  /// Small language model (e.g. Phi-2, TinyLlama).
  small,
  
  /// Medium language model (e.g. Mistral 7B, Llama 3 8B).
  medium,
  
  /// Large language model (typically requires high-end hardware).
  large,
}

/// Metadata for a quantized local model.
@immutable
class LlmModelMetadata {
  const LlmModelMetadata({
    required this.id,
    required this.name,
    required this.type,
    required this.fileSizeMb,
    required this.format,
    required this.quantization,
  });

  final String id;
  final String name;
  final LlmModelType type;
  final int fileSizeMb;
  final String format; // e.g. GGUF, TFLite
  final String quantization; // e.g. Q4_K_M
}

/// Prompt and configuration for LLM inference.
class LlmInferenceRequest {
  const LlmInferenceRequest({
    required this.prompt,
    this.systemPrompt,
    this.temperature = 0.7,
    this.maxTokens = 512,
    this.stopSequences = const [],
  });

  final String prompt;
  final String? systemPrompt;
  final double temperature;
  final int maxTokens;
  final List<String> stopSequences;
}

/// Result of an LLM inference cycle.
class LlmInferenceResult {
  const LlmInferenceResult({
    required this.text,
    required this.tokensGenerated,
    required this.inferenceTimeMs,
    required this.confidence,
  });

  final String text;
  final int tokensGenerated;
  final int inferenceTimeMs;
  final double confidence;
}
