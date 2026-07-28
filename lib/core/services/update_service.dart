abstract class UpdateService {
  Future<UpdateCheckResult> checkForUpdates();

  Future<UpdateDownloadResult> downloadUpdate({
    void Function(int received, int total)? onProgress,
  });
}

class UpdateRuntimeConfig {
  const UpdateRuntimeConfig({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(seconds: 2),
    this.requestTimeout = const Duration(seconds: 15),
  });

  final int maxAttempts;
  final Duration baseDelay;
  final Duration requestTimeout;
}

enum UpdateStatus {
  latest,
  updateAvailable,
  checking,
  unavailable,
  networkError,
  apiError,
  parsingError,
  repositoryNotFound,
  noReleasesFound,
  apkAssetMissing,
  versionUnavailable,
}

class UpdateCheckResult {
  const UpdateCheckResult({
    required this.currentVersion,
    required this.buildNumber,
    required this.releaseDate,
    required this.status,
    this.updateInfo,
    this.errorMessage,
  });

  final String currentVersion;
  final String buildNumber;
  final String releaseDate;
  final AppUpdateInfo? updateInfo;
  final UpdateStatus status;
  final String? errorMessage;

  bool get hasUpdate => updateInfo != null;
}

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.version,
    required this.releaseNotes,
    required this.downloadUrl,
    this.releaseDate,
  });

  final String version;
  final List<String> releaseNotes;
  final String downloadUrl;
  final String? releaseDate;
}

class UpdateDownloadResult {
  const UpdateDownloadResult({required this.filePath, required this.bytes});

  final String filePath;
  final int bytes;
}
