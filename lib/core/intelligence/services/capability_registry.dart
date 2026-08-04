import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Defines the types of intelligence data a provider can supply.
enum SystemCapability {
  emailSync,
  calendarSync,
  healthSync,
  fileSync,
  financialSync,
  locationSync,
  identityResolution,
  evidenceValidation,
}

/// Registry for system capabilities and feature flags.
class CapabilityRegistry {
  CapabilityRegistry();

  final Map<String, List<SystemCapability>> _providerCapabilities = {
    'gmail_api': [SystemCapability.emailSync],
    'google_calendar': [SystemCapability.calendarSync],
    'google_drive_provider': [SystemCapability.fileSync],
    'google_health': [SystemCapability.healthSync],
    'onedrive_local': [SystemCapability.fileSync],
    'internal_engine': [SystemCapability.identityResolution, SystemCapability.evidenceValidation],
  };

  /// Returns the capabilities of a specific provider.
  List<SystemCapability> getCapabilities(String providerId) {
    return _providerCapabilities[providerId] ?? [];
  }

  /// Returns all providers that support a specific capability.
  List<String> getProvidersFor(SystemCapability capability) {
    return _providerCapabilities.entries
        .where((e) => e.value.contains(capability))
        .map((e) => e.key)
        .toList();
  }

  /// Feature Flags (Runtime)
  bool isFeatureEnabled(String featureId) {
    // Future: Connect to Remote Config or Settings
    return true; 
  }
}

final capabilityRegistryProvider = Provider<CapabilityRegistry>((ref) {
  return CapabilityRegistry();
});
