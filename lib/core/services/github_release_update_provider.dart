import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'update_service.dart';

class GitHubReleaseUpdateProvider implements UpdateService {
  GitHubReleaseUpdateProvider({
    required this.owner,
    required this.repo,
    this.httpClient,
  });

  final String owner;
  final String repo;
  final HttpClient? httpClient;

  static const _apiBaseUrl = 'api.github.com';

  @override
  Future<UpdateCheckResult> checkForUpdates() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final release = await _fetchLatestRelease();
      if (release == null) {
        return UpdateCheckResult(
          currentVersion: 'v${packageInfo.version}',
          buildNumber: packageInfo.buildNumber,
          releaseDate: '',
          status: UpdateStatus.unavailable,
        );
      }

      final latestVersion = _normalizeVersion(release['tag_name']?.toString() ?? '');
      final installedVersion = _normalizeVersion('v${packageInfo.version}');

      final isUpToDate = _isVersionAtLeast(installedVersion, latestVersion);
      final notes = _parseReleaseNotes(release);
      final publishedDate = _parsePublishedDate(release);
      final apkUrl = _parseApkAssetUrl(release);

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
                releaseDate: publishedDate,
              ),
      );
    } on SocketException catch (_) {
      final packageInfo = await PackageInfo.fromPlatform();
      return UpdateCheckResult(
        currentVersion: 'v${packageInfo.version}',
        buildNumber: packageInfo.buildNumber,
        releaseDate: '',
        status: UpdateStatus.unavailable,
      );
    } on HttpException catch (_) {
      final packageInfo = await PackageInfo.fromPlatform();
      return UpdateCheckResult(
        currentVersion: 'v${packageInfo.version}',
        buildNumber: packageInfo.buildNumber,
        releaseDate: '',
        status: UpdateStatus.unavailable,
      );
    } catch (error) {
      final packageInfo = await PackageInfo.fromPlatform();
      return UpdateCheckResult(
        currentVersion: 'v${packageInfo.version}',
        buildNumber: packageInfo.buildNumber,
        releaseDate: '',
        status: UpdateStatus.unavailable,
      );
    }
  }

  @override
  Future<void> downloadUpdate() async {
    try {
      final release = await _fetchLatestRelease();
      if (release == null) {
        return;
      }

      final apkUrl = _parseApkAssetUrl(release);
      if (apkUrl == null || apkUrl.isEmpty) {
        return;
      }

      debugPrint('Download URL ready: $apkUrl');
    } catch (_) {
      debugPrint('Unable to prepare update download.');
    }
  }

  Future<Map<String, dynamic>?> _fetchLatestRelease() async {
    final client = httpClient ?? HttpClient();
    final request = await client.getUrl(Uri.https(_apiBaseUrl, '/repos/$owner/$repo/releases/latest'));
    request.headers.set('Accept', 'application/vnd.github+json');
    request.headers.set('User-Agent', 'KnightOS-App');

    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      return null;
    }

    final body = await response.transform(utf8.decoder).join();
    return jsonDecode(body) as Map<String, dynamic>;
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
      if (name.toLowerCase().contains('apk') && browserDownloadUrl != null && browserDownloadUrl.isNotEmpty) {
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
        .take(5)
        .toList();
  }

  String _normalizeVersion(String candidate) {
    var version = candidate.trim();
    if (version.isEmpty) {
      return '0.0.0';
    }
    if (!version.startsWith(RegExp(r'[vV]'))) {
      version = 'v$version';
    }
    return version.replaceFirst(RegExp(r'^[vV]'), '');
  }

  bool _isVersionAtLeast(String installed, String latest) {
    final installedParts = installed.split('.').map(int.tryParse).toList();
    final latestParts = latest.split('.').map(int.tryParse).toList();

    final max = installedParts.length > latestParts.length ? installedParts.length : latestParts.length;
    for (var index = 0; index < max; index++) {
      final installedValue = index < installedParts.length ? (installedParts[index] ?? 0) : 0;
      final latestValue = index < latestParts.length ? (latestParts[index] ?? 0) : 0;
      if (installedValue < latestValue) {
        return false;
      }
      if (installedValue > latestValue) {
        return true;
      }
    }
    return true;
  }
}
