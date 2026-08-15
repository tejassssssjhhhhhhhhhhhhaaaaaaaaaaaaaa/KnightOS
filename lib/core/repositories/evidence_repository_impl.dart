import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../domain/entities/evidence.dart';
import '../domain/repositories/i_evidence_repository.dart';
import '../internal/storage/drift/knight_database.dart';
import '../storage/privacy_vault.dart';
import 'package:drift/drift.dart';

class EvidenceRepositoryImpl implements IEvidenceRepository {
  EvidenceRepositoryImpl(this._dao);

  final EvidenceDao _dao;
  final _uuid = const Uuid();

  @override
  Future<void> store(Evidence evidence) async {
    await _dao.upsertEvidence(
      EvidenceTableCompanion.insert(
        id: _uuid.v4(),
        caid: evidence.caid,
        originalName: evidence.originalName,
        mimeType: evidence.mimeType,
        fileSize: evidence.fileSize,
        ingestedAt: evidence.ingestedAt,
        storagePath: evidence.storagePath,
        extractionData: Value(json.encode(evidence.extractionData)),
        verificationStatus: Value(evidence.verificationStatus.name),
        domain: Value(evidence.domain),
        privacyLevel: Value(evidence.privacyLevel.name),
        confidence: Value(evidence.confidence),
        auditHistory: Value(json.encode(evidence.auditHistory.map((e) => {
          'action': e.action,
          'timestamp': e.timestamp.toIso8601String(),
          'notes': e.notes,
          'userId': e.userId,
        }).toList())),
      ),
    );
  }

  @override
  Future<Evidence?> getByCaid(String caid) async {
    final data = await _dao.getByCaid(caid);
    if (data == null) return null;
    return _mapToEntity(data);
  }

  @override
  Future<List<Evidence>> getAll() async {
    final list = await _dao.getAllEvidence();
    return list.map(_mapToEntity).toList();
  }

  Evidence _mapToEntity(EvidenceTableData data) {
    return Evidence(
      caid: data.caid,
      originalName: data.originalName,
      mimeType: data.mimeType,
      fileSize: data.fileSize,
      ingestedAt: data.ingestedAt,
      storagePath: data.storagePath,
      extractionData: (data.extractionData != null && data.extractionData.isNotEmpty)
          ? json.decode(data.extractionData) as Map<String, dynamic>
          : {},
      verificationStatus: EvidenceVerificationStatus.values.firstWhere(
        (e) => e.name == data.verificationStatus,
        orElse: () => EvidenceVerificationStatus.pending,
      ),
      domain: data.domain,
      privacyLevel: PrivacyClassification.values.firstWhere(
        (p) => p.name == data.privacyLevel,
        orElse: () => PrivacyClassification.personal,
      ),
      confidence: data.confidence,
      auditHistory: (data.auditHistory != null && data.auditHistory.isNotEmpty)
          ? (json.decode(data.auditHistory) as List).map((e) => EvidenceAuditEntry(
        action: e['action'],
        timestamp: DateTime.parse(e['timestamp']),
        notes: e['notes'],
        userId: e['userId'],
      )).toList()
          : [],
    );
  }
}
