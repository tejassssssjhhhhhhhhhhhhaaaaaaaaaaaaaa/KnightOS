import 'package:equatable/equatable.dart';
import '../../storage/privacy_vault.dart';

/// Status levels in the Evidence verification workflow.
enum EvidenceVerificationStatus {
  pending,
  verified,
  trusted,
  rejected,
  archived,
}

/// Represents an action taken on an evidence item for audit history.
class EvidenceAuditEntry extends Equatable {
  const EvidenceAuditEntry({
    required this.action,
    required this.timestamp,
    this.userId,
    this.notes,
  });

  final String action;
  final DateTime timestamp;
  final String? userId;
  final String? notes;

  @override
  List<Object?> get props => [action, timestamp, userId, notes];
}

class Evidence extends Equatable {
  const Evidence({
    required this.caid,
    required this.originalName,
    required this.mimeType,
    required this.fileSize,
    required this.ingestedAt,
    required this.storagePath,
    this.extractionData = const {},
    this.verificationStatus = EvidenceVerificationStatus.pending,
    this.domain = 'personal',
    this.privacyLevel = PrivacyClassification.personal,
    this.confidence = 0.5,
    this.auditHistory = const [],
  });

  final String caid;
  final String originalName;
  final String mimeType;
  final int fileSize;
  final DateTime ingestedAt;
  final String storagePath;
  final Map<String, dynamic> extractionData;
  
  final EvidenceVerificationStatus verificationStatus;
  final String domain;
  final PrivacyClassification privacyLevel;
  final double confidence;
  final List<EvidenceAuditEntry> auditHistory;

  @override
  List<Object?> get props => [
        caid,
        originalName,
        mimeType,
        fileSize,
        ingestedAt,
        storagePath,
        extractionData,
        verificationStatus,
        domain,
        privacyLevel,
        confidence,
        auditHistory,
      ];

  Evidence copyWith({
    EvidenceVerificationStatus? verificationStatus,
    String? domain,
    PrivacyClassification? privacyLevel,
    double? confidence,
    List<EvidenceAuditEntry>? auditHistory,
    Map<String, dynamic>? extractionData,
  }) {
    return Evidence(
      caid: caid,
      originalName: originalName,
      mimeType: mimeType,
      fileSize: fileSize,
      ingestedAt: ingestedAt,
      storagePath: storagePath,
      extractionData: extractionData ?? this.extractionData,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      domain: domain ?? this.domain,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      confidence: confidence ?? this.confidence,
      auditHistory: auditHistory ?? this.auditHistory,
    );
  }
}
