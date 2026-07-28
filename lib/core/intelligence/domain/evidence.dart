import 'package:flutter/foundation.dart';

/// Represents a pointer to a specific evidence artifact.
@immutable
class SourceLink {
  const SourceLink({required this.caid, this.fragment});

  /// Content-Addressable Identifier (SHA-256 hash).
  final String caid;

  /// Deep-link fragment (e.g. page=2, line=40).
  final String? fragment;

  /// Returns the knight:// URI representation.
  String toUri() =>
      'knight://evidence/$caid${fragment != null ? "#$fragment" : ""}';

  /// Parses a knight:// URI into a SourceLink.
  factory SourceLink.fromUri(String uri) {
    if (!uri.startsWith('knight://evidence/')) {
      throw ArgumentError('Invalid SourceLink URI format');
    }
    final parts = uri.substring('knight://evidence/'.length).split('#');
    return SourceLink(
      caid: parts[0],
      fragment: parts.length > 1 ? parts[1] : null,
    );
  }

  Map<String, dynamic> toJson() => {'uri': toUri()};
  factory SourceLink.fromJson(Map<String, dynamic> json) =>
      SourceLink.fromUri(json['uri'] as String);
}

/// Metadata for a stored proof artifact in the Evidence Vault.
@immutable
class Evidence {
  const Evidence({
    required this.caid,
    required this.originalName,
    required this.mimeType,
    required this.fileSize,
    required this.ingestedAt,
    required this.storagePath,
    this.extractionData = const {},
  });

  final String caid;
  final String originalName;
  final String mimeType;
  final int fileSize;
  final DateTime ingestedAt;
  final String storagePath;
  final Map<String, dynamic> extractionData;

  Map<String, dynamic> toJson() {
    return {
      'caid': caid,
      'originalName': originalName,
      'mimeType': mimeType,
      'fileSize': fileSize,
      'ingestedAt': ingestedAt.toIso8601String(),
      'storagePath': storagePath,
      'extractionData': extractionData,
    };
  }

  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      caid: json['caid'] as String,
      originalName: json['originalName'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: json['fileSize'] as int,
      ingestedAt: DateTime.parse(json['ingestedAt'] as String),
      storagePath: json['storagePath'] as String,
      extractionData: json['extractionData'] as Map<String, dynamic>,
    );
  }
}
