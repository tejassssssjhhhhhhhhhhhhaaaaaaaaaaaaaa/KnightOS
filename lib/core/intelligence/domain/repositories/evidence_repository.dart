import '../evidence.dart';

/// Contract for evidence artifact management and integrity verification.
abstract class EvidenceRepository {
  /// Retrieves evidence metadata by its Content-Addressable Identifier.
  Future<Evidence?> getByCaid(String caid);

  /// Stores a new evidence artifact. Implementation must calculate SHA-256
  /// and ensure Content-Addressable Storage (CAS).
  Future<Evidence> store(
    List<int> bytes, {
    required String originalName,
    required String mimeType,
  });

  /// Verifies the integrity of a stored artifact.
  Future<bool> verify(String caid);

  /// Returns the local file path for an artifact (VFS resolver).
  Future<String> resolvePath(String caid);

  /// Lists all evidence related to a specific domain or tag.
  Future<List<Evidence>> list({String? tag});
}
