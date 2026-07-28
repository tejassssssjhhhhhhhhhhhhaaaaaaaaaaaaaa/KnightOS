import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';

/// Calculates certainty levels for facts and inferences.
class ConfidenceEngine {
  const ConfidenceEngine();

  /// Evaluates the reliability of a specific memory based on its source and provenance.
  double evaluateCertainty(KnightMemory memory) {
    if (memory.source == MemorySource.manual) {
      return 1.0; // User-provided facts are "Ground Truth"
    }
    if (memory.source == MemorySource.sensor) {
      return 0.95; // Direct measurements are highly reliable
    }
    if (memory.source == MemorySource.imported) {
      return 0.90; // Verified external sources
    }
    if (memory.source == MemorySource.aiGenerated) {
      return memory.confidence; // Depend on AI's self-assessment
    }
    return 0.5;
  }

  /// Determines if a specific content is a "Known Fact" vs "Reasonable Inference".
  String classifyContent(KnightMemory memory) {
    final certainty = evaluateCertainty(memory);
    if (certainty > 0.95) return 'Known Fact';
    if (certainty > 0.70) return 'Reasonable Inference';
    return 'Unverified Information';
  }
}
