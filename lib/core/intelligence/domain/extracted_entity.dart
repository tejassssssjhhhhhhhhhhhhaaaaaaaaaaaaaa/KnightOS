import 'package:flutter/foundation.dart';

enum EntityVerificationState {
  unverified,
  likely,
  verified,
  userConfirmed,
  userCorrected,
  systemRevalidated,
}

@immutable
class ExtractedEntity {
  const ExtractedEntity({
    required this.id,
    this.canonicalId,
    required this.type,
    required this.subtype,
    required this.title,
    this.summary,
    required this.eventTimestamp,
    required this.receivedTimestamp,
    required this.parserName,
    required this.parserVersion,
    required this.confidenceScore,
    this.confidenceReason,
    required this.verificationState,
    this.userCorrected = false,
    this.syncBatchId,
    this.version = 1,
    this.evidenceId,
    required this.extractionTimestamp,
  });

  final String id;
  final String? canonicalId;
  final String type;
  final String subtype;
  final String title;
  final String? summary;
  final DateTime eventTimestamp;
  final DateTime receivedTimestamp;
  final String parserName;
  final String parserVersion;
  final double confidenceScore;
  final String? confidenceReason;
  final EntityVerificationState verificationState;
  final bool userCorrected;
  final String? syncBatchId;
  final int version;
  final String? evidenceId;
  final DateTime extractionTimestamp;

  Map<String, dynamic> toJson() => {
    'id': id,
    'canonicalId': canonicalId,
    'type': type,
    'subtype': subtype,
    'title': title,
    'summary': summary,
    'eventTimestamp': eventTimestamp.toIso8601String(),
    'receivedTimestamp': receivedTimestamp.toIso8601String(),
    'parserName': parserName,
    'parserVersion': parserVersion,
    'confidenceScore': confidenceScore,
    'confidenceReason': confidenceReason,
    'verificationState': verificationState.name,
    'userCorrected': userCorrected,
    'syncBatchId': syncBatchId,
    'version': version,
    'evidenceId': evidenceId,
    'extractionTimestamp': extractionTimestamp.toIso8601String(),
  };
}
