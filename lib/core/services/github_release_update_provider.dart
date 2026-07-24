import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'update_service.dart';

class GitHubReleaseUpdateProvider implements UpdateService {
  GitHubReleaseUpdateProvider({
    required this.owner,
    required this.repo,
    this.httpClient,
    this.runtimeConfig = const UpdateRuntimeConfig(),
  });

  final String owner;
  final String repo;
  final HttpClient? httpClient;
  final UpdateRuntimeConfig runtimeConfig;

  static const _apiBaseUrl = 'api.github.com';
  static const _apkFileName = 'knight_os_update.apk';
  static const _minimumDownloadBytes = 4096;

  String get repository => '$owner/$repo';

  @override
  Future<UpdateCheckResult> checkForUpdates() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final release = await _fetchLatestReleaseWithRetry();
      final installedVersion = _composeInstalledVersion(packageInfo);
      if (release == null) {
        return UpdateCheckResult(
          currentVersion: 'v${packageInfo.version}',
          buildNumber: packageInfo.buildNumber,
          releaseDate: '',
          status: UpdateStatus.noReleasesFound,
          errorMessage: 'No releases found for this repository.',
        );
      }

      final rawLatestVersion = release['tag_name']?.toString() ?? '';
      final latestVersion = normalizeVersion(rawLatestVersion);
      if (rawLatestVersion.trim().isEmpty) {
        return _result(
          packageInfo,
          UpdateStatus.versionUnavailable,
          errorMessage: 'The latest release tag is empty.',
        );
      }
      if (!_isSemanticVersion(rawLatestVersion)) {
        return _result(
          packageInfo,
          UpdateStatus.versionUnavailable,
          errorMessage: 'GitHub release tag "$rawLatestVersion" is not a supported semantic version.',
        );
      }
      final notes = _parseReleaseNotes(release);
      final publishedDate = _parsePublishedDate(release);
      final apkUrl = _parseApkAssetUrl(release);
      final comparison = compareVersions(installedVersion, latestVersion);
      final isUpToDate = comparison >= 0;
      final buildNumberComparison = _compareBuildNumber(packageInfo.buildNumber, release['target_commitish']?.toString());

      debugPrint('Parsed release: ${jsonEncode(release)}');
      debugPrint('Installed Version : $installedVersion');
      debugPrint('Latest Version    : $latestVersion');
      debugPrint('APK URL           : ${apkUrl ?? "NULL"}');
      debugPrint('Comparison Result : $comparison');
      debugPrint('Build Number Check: $buildNumberComparison');
      debugPrint('Is Up To Date     : $isUpToDate');
      if (!isUpToDate && apkUrl == null) {
        return _result(
          packageInfo,
          UpdateStatus.apkAssetMissing,
          releaseDate: publishedDate ?? '',
          errorMessage: 'Release $latestVersion does not include a downloadable APK asset.',
          updateInfo: AppUpdateInfo(version: latestVersion, releaseNotes: notes, downloadUrl: '', releaseDate: publishedDate),
        );
      }

      return UpdateCheckResult(
        currentVersion: 'v${packageInfo.version}',
        buildNumber: packageInfo.buildNumber,
        releaseDate: publishedDate ?? '',
        status: isUpToDate ? UpdateStatus.latest : UpdateStatus.updateAvailable,
        updateInfo: isUpToDate
            ? null
            : AppUpdateInfo(
                version: latestVersion,
                releaseNotes: notes,
                downloadUrl: apkUrl!,
                releaseDate: publishedDate,
              ),
      );
    } on SocketException catch (error) {
      final packageInfo = await PackageInfo.fromPlatform();
      return UpdateCheckResult(
        currentVersion: 'v${packageInfo.version}',
        buildNumber: packageInfo.buildNumber,
        releaseDate: '',
        status: UpdateStatus.networkError,
        errorMessage: 'Unable to reach GitHub right now. ${_formatError(error)}',
      );
    } on HttpException catch (error) {
      final packageInfo = await PackageInfo.fromPlatform();
      final message = error.message;
      final status = message == 'Repository not found.'
          ? UpdateStatus.repositoryNotFound
          : message == 'No releases found for this repository.'
              ? UpdateStatus.noReleasesFound
              : UpdateStatus.apiError;
      return UpdateCheckResult(
        currentVersion: 'v${packageInfo.version}',
        buildNumber: packageInfo.buildNumber,
        releaseDate: '',
        status: status,
        errorMessage: 'GitHub API error: ${_formatError(error)}',
      );
    } on FormatException catch (error) {
      final packageInfo = await PackageInfo.fromPlatform();
      return UpdateCheckResult(
        currentVersion: 'v${packageInfo.version}',
        buildNumber: packageInfo.buildNumber,
        releaseDate: '',
        status: UpdateStatus.parsingError,
        errorMessage: 'Unable to parse GitHub release data: ${_formatError(error)}',
      );
    } catch (error, stackTrace) {
      final packageInfo = await PackageInfo.fromPlatform();
      debugPrint('GitHub update check failed: $error\n$stackTrace');
      return UpdateCheckResult(
        currentVersion: 'v${packageInfo.version}',
        buildNumber: packageInfo.buildNumber,
        releaseDate: '',
        status: UpdateStatus.apiError,
        errorMessage: 'GitHub update check failed: ${_formatError(error)}',
      );
    }
  }

  @override
  Future<UpdateDownloadResult> downloadUpdate({void Function(int received, int total)? onProgress}) async {
    final release = await _fetchLatestReleaseWithRetry();
    final apkUrl = _parseApkAssetUrl(release ?? {});
    if (apkUrl == null || apkUrl.isEmpty) {
      throw const HttpException('The latest release does not contain a downloadable APK asset.');
    }

    debugPrint('Download URL: $apkUrl');
    final client = httpClient ?? HttpClient();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$_apkFileName');
    if (await file.exists()) {
      await file.delete();
    }

    var attempt = 0;
    Object? lastError;
    while (attempt < runtimeConfig.maxAttempts) {
      attempt += 1;
      try {
        final request = await client.getUrl(Uri.parse(apkUrl));
        request.headers.set('Accept', 'application/octet-stream');
        request.headers.set('User-Agent', 'KnightOS-App');
        request.cookies.clear();
        final response = await request.close().timeout(runtimeConfig.requestTimeout, onTimeout: () {
          throw TimeoutException('Timed out while downloading the APK update.', runtimeConfig.requestTimeout);
        });
        if (response.statusCode == HttpStatus.tooManyRequests || response.statusCode >= 500) {
          if (attempt < runtimeConfig.maxAttempts) {
            await Future<void>.delayed(runtimeConfig.baseDelay * attempt);
            continue;
          }
          throw HttpException('APK download returned status ${response.statusCode}.');
        }
        if (response.statusCode != HttpStatus.ok) {
          throw HttpException('APK download returned status ${response.statusCode}.');
        }

        final sink = file.openWrite();
        var received = 0;
        try {
          await for (final chunk in response) {
            sink.add(chunk);
            received += chunk.length;
            onProgress?.call(received, response.contentLength);
          }
        } finally {
          await sink.close();
        }
        if (received < _minimumDownloadBytes || !await file.exists()) {
          throw const FormatException('Downloaded APK is empty or incomplete.');
        }
        final header = await file.openRead(0, 2).fold<List<int>>(<int>[], (bytes, chunk) => bytes..addAll(chunk));
        if (header.length < 2 || header[0] != 0x50 || header[1] != 0x4b) {
          await file.delete();
          throw const FormatException('Downloaded file is not a valid APK archive.');
        }
        debugPrint('Downloaded APK: ${file.path} ($received bytes)');
        return UpdateDownloadResult(filePath: file.path, bytes: received);
      } catch (error) {
        lastError = error;
        if (attempt >= runtimeConfig.maxAttempts) {
          rethrow;
        }
        debugPrint('Retrying APK download after transient failure: $error');
        await Future<void>.delayed(runtimeConfig.baseDelay * attempt);
      }
    }
    throw lastError ?? const FormatException('APK download failed.');
  }

  UpdateCheckResult _result(
    PackageInfo packageInfo,
    UpdateStatus status, {
    String releaseDate = '',
    String? errorMessage,
    AppUpdateInfo? updateInfo,
  }) => UpdateCheckResult(
        currentVersion: 'v${packageInfo.version}',
        buildNumber: packageInfo.buildNumber,
        releaseDate: releaseDate,
        status: status,
        errorMessage: errorMessage,
        updateInfo: updateInfo,
      );

  Future<Map<String, dynamic>?> _fetchLatestReleaseWithRetry() async {
    Object? lastError;
    for (var attempt = 1; attempt <= runtimeConfig.maxAttempts; attempt++) {
      try {
        return await _fetchLatestRelease();
      } catch (error) {
        lastError = error;
        if (!_shouldRetry(error, attempt)) {
          rethrow;
        }
        debugPrint('Retrying GitHub release check after transient failure ($attempt/${runtimeConfig.maxAttempts}): $error');
        if (attempt < runtimeConfig.maxAttempts) {
          await Future<void>.delayed(runtimeConfig.baseDelay * attempt);
        }
      }
    }
    throw lastError ?? StateError('GitHub release check failed.');
  }

  bool _shouldRetry(Object error, int attempt) {
    if (attempt >= runtimeConfig.maxAttempts) {
      return false;
    }
    if (error is SocketException) {
      return true;
    }
    if (error is HttpException) {
      final message = error.message.toLowerCase();
      return message.contains('rate limit') || message.contains('status 429') || message.contains('status 5');
    }
    return false;
  }

  Future<Map<String, dynamic>?> _fetchLatestRelease() async {
    final client = httpClient ?? HttpClient();
    final apiUrl = Uri.https(_apiBaseUrl, '/repos/$owner/$repo/releases/latest');
    debugPrint('Repository: $repository');
    debugPrint('API URL: $apiUrl');

    final request = await client.getUrl(apiUrl);
    request.headers.set('Accept', 'application/vnd.github+json');
    request.headers.set('User-Agent', 'KnightOS-App');

    final response = await request.close().timeout(runtimeConfig.requestTimeout, onTimeout: () {
      throw TimeoutException('Timed out while contacting GitHub Releases.', runtimeConfig.requestTimeout);
    });
    final responseBody = await response.transform(utf8.decoder).join();
    debugPrint('HTTP status: ${response.statusCode}');
    debugPrint('Response: ${responseBody.substring(0, responseBody.length > 500 ? 500 : responseBody.length)}');

    if (response.statusCode == HttpStatus.notFound) {
      final repositoryRequest = await client.getUrl(Uri.https(_apiBaseUrl, '/repos/$owner/$repo'));
      repositoryRequest.headers.set('Accept', 'application/vnd.github+json');
      repositoryRequest.headers.set('User-Agent', 'KnightOS-App');
      final repositoryResponse = await repositoryRequest.close();
      if (repositoryResponse.statusCode == HttpStatus.notFound) {
        throw const HttpException('Repository not found.');
      }
      if (repositoryResponse.statusCode == HttpStatus.ok) {
        throw const HttpException('No releases found for this repository.');
      }
      throw HttpException('GitHub repository check returned status ${repositoryResponse.statusCode}.');
    }
    if (response.statusCode == HttpStatus.forbidden) {
      throw const HttpException('GitHub API rate limit reached.');
    }
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('GitHub API returned status ${response.statusCode}.');
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('GitHub release payload is not a JSON object.');
    }
    return decoded;
  }

  String? _parseApkAssetUrl(Map<String, dynamic> release) {
    final assets = release['assets'];
    if (assets is! List) {
      return null;
    }

    for (final asset in assets) {
      if (asset is! Map<String, dynamic>) {
        continue;
      }
      final name = asset['name']?.toString() ?? '';
      final browserDownloadUrl = asset['browser_download_url']?.toString();
      final size = asset['size'];
      final contentType = asset['content_type']?.toString() ?? '';
      final looksLikeApkAsset = name.toLowerCase().endsWith('.apk') || name.toLowerCase().contains('.apk');
      final looksLikeAndroidPackage = contentType.toLowerCase().contains('apk') || contentType.toLowerCase().contains('android');
      final hasValidSize = size is int ? size > 0 : true;
      if (looksLikeApkAsset && browserDownloadUrl != null && browserDownloadUrl.isNotEmpty && hasValidSize && (looksLikeAndroidPackage || contentType.isEmpty)) {
        return browserDownloadUrl;
      }
    }
    return null;
  }

  String? _parsePublishedDate(Map<String, dynamic> release) {
    final publishedAt = release['published_at']?.toString();
    if (publishedAt == null || publishedAt.isEmpty) {
      return null;
    }

    try {
      final date = DateTime.parse(publishedAt);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return null;
    }
  }

  List<String> _parseReleaseNotes(Map<String, dynamic> release) {
    final body = release['body']?.toString() ?? '';
    if (body.trim().isEmpty) {
      return const ['No release notes provided.'];
    }

    return body
        .split(RegExp(r'\r?\n'))
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.trim())
        .take(6)
        .toList();
  }

  String normalizeVersion(String candidate) {
    final parsed = _parseVersion(candidate);
    return '${parsed.major}.${parsed.minor}.${parsed.patch}';
  }

  String _composeInstalledVersion(PackageInfo packageInfo) {
    return normalizeVersion('v${packageInfo.version}');
  }

  bool _isSemanticVersion(String candidate) {
    return RegExp(r'^[vV]?\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+\d+)?$').hasMatch(candidate.trim());
  }

  bool isVersionAtLeast(String installed, String latest) {
    return compareVersions(installed, latest) >= 0;
  }

  int compareVersions(String installed, String latest) {
    final installedVersion = _parseVersion(installed);
    final latestVersion = _parseVersion(latest);

    if (installedVersion.major != latestVersion.major) {
      return installedVersion.major.compareTo(latestVersion.major);
    }
    if (installedVersion.minor != latestVersion.minor) {
      return installedVersion.minor.compareTo(latestVersion.minor);
    }
    if (installedVersion.patch != latestVersion.patch) {
      return installedVersion.patch.compareTo(latestVersion.patch);
    }

    final prereleaseCompare = _comparePrerelease(installedVersion.prerelease, latestVersion.prerelease);
    if (prereleaseCompare != 0) {
      return prereleaseCompare;
    }

    return _compareBuildMetadata(installedVersion.buildMetadata, latestVersion.buildMetadata);
  }

  int _comparePrerelease(String? installed, String? latest) {
    if (installed == null && latest == null) {
      return 0;
    }
    if (installed == null) {
      return 1;
    }
    if (latest == null) {
      return -1;
    }
    return installed.compareTo(latest);
  }

  int _compareBuildMetadata(String? installed, String? latest) {
    if (installed == null && latest == null) {
      return 0;
    }
    if (installed == null) {
      return -1;
    }
    if (latest == null) {
      return 1;
    }

    final installedNumeric = int.tryParse(installed);
    final latestNumeric = int.tryParse(latest);
    if (installedNumeric != null && latestNumeric != null) {
      return installedNumeric.compareTo(latestNumeric);
    }
    return installed.compareTo(latest);
  }

  int _compareBuildNumber(String? installedBuildNumber, String? releaseTag) {
    final installed = int.tryParse(installedBuildNumber ?? '');
    final release = int.tryParse(releaseTag ?? '');
    if (installed == null || release == null) {
      return 0;
    }
    return installed.compareTo(release);
  }

  _VersionMetadata _parseVersion(String candidate) {
    var version = candidate.trim();
    if (version.isEmpty) {
      return const _VersionMetadata(major: 0, minor: 0, patch: 0);
    }

    version = version.replaceFirst(RegExp(r'^[vV]'), '');
    final buildSplit = version.split('+');
    final coreVersion = buildSplit.first;
    final buildMetadata = buildSplit.length > 1 ? buildSplit[1] : null;

    final prereleaseSplit = coreVersion.split('-');
    final releaseVersion = prereleaseSplit.first;
    final prerelease = prereleaseSplit.length > 1 ? prereleaseSplit[1] : null;

    final parts = releaseVersion
        .replaceAll(RegExp(r'[^0-9.]'), '')
        .split('.')
        .map(int.tryParse)
        .toList();

    final major = parts.isNotEmpty && parts[0] != null ? parts[0]! : 0;
    final minor = parts.length > 1 && parts[1] != null ? parts[1]! : 0;
    final patch = parts.length > 2 && parts[2] != null ? parts[2]! : 0;

    return _VersionMetadata(
      major: major,
      minor: minor,
      patch: patch,
      prerelease: prerelease,
      buildMetadata: buildMetadata,
    );
  }

  String _formatError(Object error) {
    return error.toString().replaceAll('\n', ' ').trim();
  }
}

class _VersionMetadata {
  const _VersionMetadata({
    required this.major,
    required this.minor,
    required this.patch,
    this.prerelease,
    this.buildMetadata,
  });

  final int major;
  final int minor;
  final int patch;
  final String? prerelease;
  final String? buildMetadata;
}
