import 'package:equatable/equatable.dart';
import '../../storage/privacy_vault.dart';

enum AuthMethod {
  none,
  oAuth2,
  apiKey,
  localPath,
}

enum SyncMode {
  manual,
  scheduled,
  realTime,
}

/// Metadata defining a KnightOS connector and its capabilities.
class ConnectorManifest extends Equatable {
  const ConnectorManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.vendor,
    required this.supportedPlatforms,
    required this.authMethod,
    this.requiredPermissions = const [],
    required this.supportedCapabilities,
    required this.syncModes,
    required this.privacyClassification,
    this.minKnightOsVersion = '6.0.0',
  });

  final String id;
  final String name;
  final String version;
  final String vendor;
  final List<String> supportedPlatforms; // 'android', 'ios', 'web'
  final AuthMethod authMethod;
  final List<String> requiredPermissions;
  final List<String> supportedCapabilities; // e.g., 'calendar', 'documents'
  final List<SyncMode> syncModes;
  final PrivacyClassification privacyClassification;
  final String minKnightOsVersion;

  @override
  List<Object?> get props => [
        id,
        name,
        version,
        vendor,
        supportedPlatforms,
        authMethod,
        requiredPermissions,
        supportedCapabilities,
        syncModes,
        privacyClassification,
        minKnightOsVersion,
      ];
}
