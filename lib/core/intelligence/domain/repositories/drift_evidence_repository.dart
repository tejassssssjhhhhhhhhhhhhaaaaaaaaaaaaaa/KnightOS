import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../../internal/storage/drift/knight_database.dart';
import '../evidence.dart';
import 'evidence_repository.dart';

/// Implementation of [EvidenceRepository] managing a Content-Addressable Storage (CAS) vault.
class DriftEvidenceRepository implements EvidenceRepository {
  DriftEvidenceRepository({required EvidenceDao evidenceDao})
    : _dao = evidenceDao;

  final EvidenceDao _dao;

  @override
  Future<Evidence?> getByCaid(String caid) async {
    final data = await _dao.getByCaid(caid);
    return data != null ? _mapToDomain(data) : null;
  }

  @override
  Future<Evidence> store(
    List<int> bytes, {
    required String originalName,
    required String mimeType,
  }) async {
    // 1. Calculate Content-Addressable Identifier (SHA-256)
    final caid = sha256.convert(bytes).toString();

    // 2. Check for existing (Deduplication)
    final existing = await getByCaid(caid);
    if (existing != null) return existing;

    // 3. Move to physical vault
    final vaultDir = await _getVaultDirectory();
    final subDir = Directory(p.join(vaultDir.path, caid.substring(0, 2)));
    if (!await subDir.exists()) await subDir.create(recursive: true);

    final extension = p.extension(originalName);
    final fileName = '$caid$extension';
    final filePath = p.join(subDir.path, fileName);
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    // 4. Save metadata to DB
    final ingestedAt = DateTime.now();
    final relativePath = p.relative(filePath, from: vaultDir.path);

    final companion = EvidenceTableCompanion.insert(
      id: const Uuid().v4(),
      caid: caid,
      originalName: originalName,
      mimeType: mimeType,
      fileSize: bytes.length,
      ingestedAt: ingestedAt,
      storagePath: relativePath,
    );

    await _dao.upsertEvidence(companion);

    return Evidence(
      caid: caid,
      originalName: originalName,
      mimeType: mimeType,
      fileSize: bytes.length,
      ingestedAt: ingestedAt,
      storagePath: relativePath,
    );
  }

  @override
  Future<bool> verify(String caid) async {
    final meta = await getByCaid(caid);
    if (meta == null) return false;

    final absolutePath = await resolvePath(caid);
    final file = File(absolutePath);
    if (!await file.exists()) return false;

    final bytes = await file.readAsBytes();
    final currentHash = sha256.convert(bytes).toString();
    return currentHash == caid;
  }

  @override
  Future<String> resolvePath(String caid) async {
    final meta = await getByCaid(caid);
    if (meta == null) throw Exception('Evidence artifact not found: $caid');

    final vaultDir = await _getVaultDirectory();
    return p.join(vaultDir.path, meta.storagePath);
  }

  @override
  Future<List<Evidence>> list({String? tag}) async {
    final list = await _dao.getAllEvidence();
    return list.map(_mapToDomain).toList();
  }

  // --- Helpers ---

  Future<Directory> _getVaultDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final vault = Directory(p.join(appDir.path, 'knight_os', 'vault'));
    if (!await vault.exists()) await vault.create(recursive: true);
    return vault;
  }

  Evidence _mapToDomain(EvidenceTableData data) {
    return Evidence(
      caid: data.caid,
      originalName: data.originalName,
      mimeType: data.mimeType,
      fileSize: data.fileSize,
      ingestedAt: data.ingestedAt,
      storagePath: data.storagePath,
      extractionData: jsonDecode(data.extractionData),
    );
  }
}
