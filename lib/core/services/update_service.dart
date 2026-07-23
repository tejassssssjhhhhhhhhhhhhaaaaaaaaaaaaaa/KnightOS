import 'package:flutter/foundation.dart';

abstract class UpdateService {
  Future<UpdateCheckResult> checkForUpdates();

  Future<void> downloadUpdate();
}

enum UpdateStatus {
  latest,
  updateAvailable,
  checking,
  unavailable,
}

class UpdateCheckResult {
  const UpdateCheckResult({
    required this.currentVersion,
    required this.buildNumber,
    required this.releaseDate,
    required this.status,
    this.updateInfo,
  });

  final String currentVersion;
  final String buildNumber;
  final String releaseDate;
  final AppUpdateInfo? updateInfo;
  final UpdateStatus status;

  bool get hasUpdate => updateInfo != null;
}

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.version,
    required this.releaseNotes,
    this.releaseDate,
  });

  final String version;
  final List<String> releaseNotes;
  final String? releaseDate;
}

class MockUpdateService implements UpdateService {
  @override
  Future<UpdateCheckResult> checkForUpdates() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return const UpdateCheckResult(
      currentVersion: 'v0.1.0',
      buildNumber: '#1',
      releaseDate: '2026-07-23',
      status: UpdateStatus.updateAvailable,
      updateInfo: AppUpdateInfo(
        version: 'v0.2.0',
        releaseNotes: [
          'Improved welcome experience',
          'Better login flow',
          'Performance improvements',
        ],
        releaseDate: '2026-07-24',
      ),
    );
  }

  @override
  Future<void> downloadUpdate() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    debugPrint('Update download requested. Connect a real backend to continue.');
  }
}
