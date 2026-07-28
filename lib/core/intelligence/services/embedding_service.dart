import 'dart:convert';
import '../domain/knight_memory.dart';

/// Contract for vector embedding providers.
abstract class EmbeddingProvider {
  String get id;
  int get version;
  int get dimensions;
  Future<List<double>> generate(String text);
}

/// A local, deterministic placeholder provider that uses string hashing
/// to simulate a vector space for development without external APIs.
class LocalPlaceholderEmbeddingProvider implements EmbeddingProvider {
  @override
  String get id => 'local_placeholder';

  @override
  int get version => 1;

  @override
  int get dimensions => 128;

  @override
  Future<List<double>> generate(String text) async {
    // Highly deterministic but scientifically useless pseudo-embedding
    final bytes = utf8.encode(text.toLowerCase());
    final List<double> vector = List.filled(dimensions, 0.0);

    for (var i = 0; i < bytes.length; i++) {
      vector[i % dimensions] += bytes[i] / 255.0;
    }

    // Normalize to unit length
    final double magnitude = vector.fold(0, (sum, val) => sum + (val * val));
    if (magnitude > 0) {
      final double invMag = 1.0 / magnitude;
      for (var i = 0; i < dimensions; i++) {
        vector[i] *= invMag;
      }
    }

    return vector;
  }
}

/// Manages embedding generation and lifecycle for KnightOS.
class EmbeddingService {
  EmbeddingService({EmbeddingProvider? provider})
    : _provider = provider ?? LocalPlaceholderEmbeddingProvider();

  final EmbeddingProvider _provider;

  /// Generates an embedding for a memory based on its content and summary.
  Future<KnightMemory> embed(KnightMemory memory) async {
    final textToEmbed = _extractTextToEmbed(memory);
    final vector = await _provider.generate(textToEmbed);

    return memory.copyWith(
      metadata: memory.metadata.copyWith(
        embedding: vector,
        semanticMetadata: {
          'provider': _provider.id,
          'version': _provider.version,
          'generatedAt': DateTime.now().toIso8601String(),
        },
      ),
    );
  }

  String _extractTextToEmbed(KnightMemory memory) {
    final buffer = StringBuffer();
    if (memory.summary != null) buffer.write('${memory.summary} ');
    buffer.write(jsonEncode(memory.content));
    for (final tag in memory.tags) {
      buffer.write(' $tag');
    }
    return buffer.toString();
  }

  /// Calculates cosine similarity between two vectors.
  static double calculateSimilarity(List<double> v1, List<double> v2) {
    if (v1.length != v2.length) return 0.0;

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < v1.length; i++) {
      dotProduct += v1[i] * v2[i];
      normA += v1[i] * v1[i];
      normB += v2[i] * v2[i];
    }

    if (normA == 0 || normB == 0) return 0.0;
    return dotProduct / (normA * normB);
  }
}
