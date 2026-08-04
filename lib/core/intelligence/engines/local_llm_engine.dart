import 'dart:async';
import '../domain/llm_models.dart';
import '../../internal/utils/knight_logger.dart';

/// Interface for a local LLM runtime (e.g. llama.cpp, TFLite).
abstract class LlmRuntime {
  Future<void> loadModel(LlmModelMetadata metadata);
  Future<LlmInferenceResult> generate(LlmInferenceRequest request);
  Future<void> unloadModel();
}

/// Orchestrates local LLM execution for privacy-first reasoning.
class LocalLlmEngine {
  LocalLlmEngine({this.runtime});

  final LlmRuntime? runtime;
  LlmModelMetadata? _currentModel;

  /// Executes a reasoning task using the local LLM.
  Future<LlmInferenceResult> reason(String prompt, {String? systemPrompt}) async {
    if (runtime == null) {
      // Fallback to heuristic reasoning if no runtime is available
      return LlmInferenceResult(
        text: 'Heuristic reasoning fallback: No local LLM runtime detected.',
        tokensGenerated: 0,
        inferenceTimeMs: 0,
        confidence: 0.5,
      );
    }

    KnightLogger.info('[LLM] Executing local inference...', category: KnightLogCategory.intelligence);

    final request = LlmInferenceRequest(
      prompt: prompt,
      systemPrompt: systemPrompt,
    );

    try {
      final startTime = DateTime.now();
      final result = await runtime!.generate(request);
      final duration = DateTime.now().difference(startTime);
      
      KnightLogger.info('[LLM] Inference complete in ${duration.inMilliseconds}ms', category: KnightLogCategory.intelligence);
      return result;
    } catch (e, stack) {
      KnightLogger.error('[LLM] Inference failed: $e', stackTrace: stack, category: KnightLogCategory.intelligence);
      rethrow;
    }
  }

  Future<void> loadModel(LlmModelMetadata metadata) async {
    if (runtime == null) return;
    
    KnightLogger.info('[LLM] Loading model: ${metadata.name}', category: KnightLogCategory.intelligence);
    await runtime!.loadModel(metadata);
    _currentModel = metadata;
  }

  LlmModelMetadata? get currentModel => _currentModel;
}
