import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/services/android_update_installer.dart';
import '../../core/services/github_release_update_provider.dart';
import '../../core/services/update_service.dart';
import '../widgets/knight_page_scaffold.dart';

class AppUpdatesScreen extends StatefulWidget {
  const AppUpdatesScreen({this.updateService, super.key});

  final UpdateService? updateService;

  @override
  State<AppUpdatesScreen> createState() => _AppUpdatesScreenState();
}

class _AppUpdatesScreenState extends State<AppUpdatesScreen>
    with WidgetsBindingObserver {
  UpdateService? _service;
  late final AndroidUpdateInstaller _installer;
  UpdateCheckResult? _result;
  bool _isLoading = true;
  bool _isUpdating = false;
  int _downloadedBytes = 0;
  int _downloadTotalBytes = 0;
  String? _errorMessage;
  Future<void>? _refreshFuture;

  @override
  void initState() {
    super.initState();
    _installer = const AndroidUpdateInstaller();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refreshUpdates());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshUpdates(showLoading: false));
    }
  }

  UpdateService _buildService() {
    return widget.updateService ??
        GitHubReleaseUpdateProvider(
          owner: 'tejassssssjhhhhhhhhhhhhaaaaaaaaaaaaaa',
          repo: 'KnightOS',
        );
  }

  Future<void> _refreshUpdates({bool showLoading = true}) async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    _refreshFuture = _performRefresh(showLoading: showLoading);
    try {
      await _refreshFuture!;
    } finally {
      if (mounted) {
        _refreshFuture = null;
      }
    }
  }

  Future<void> _performRefresh({bool showLoading = true}) async {
    _service = _buildService();
    debugPrint('Starting update refresh. showLoading=$showLoading');

    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _result = null;
      });
    } else {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      debugPrint('LOG 1: PackageInfo version = ${packageInfo.version}');
      debugPrint(
        'LOG 2: PackageInfo build number = ${packageInfo.buildNumber}',
      );

      final result = await _service!.checkForUpdates();
      if (!mounted) return;

      final normalizedInstalled = _normalizeVersion(packageInfo.version);
      final normalizedGitHub = _normalizeVersion(
        result.updateInfo?.version ?? result.currentVersion,
      );
      final comparison = _compareVersions(
        normalizedInstalled,
        normalizedGitHub,
      );
      debugPrint(
        'Update status resolved: ${result.status.name} (comparison=$comparison)',
      );
      debugPrint(
        'LOG 3: GitHub tag = ${result.updateInfo?.version ?? result.currentVersion}',
      );
      debugPrint('LOG 4: Normalized installed version = $normalizedInstalled');
      debugPrint('LOG 5: Normalized GitHub version = $normalizedGitHub');
      debugPrint('LOG 6: Comparison result = $comparison');
      debugPrint('LOG 7: Final UpdateStatus = ${result.status.name}');

      setState(() {
        _result = result;
        _errorMessage = _shouldShowError(result) ? result.errorMessage : null;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
        _result = UpdateCheckResult(
          currentVersion: 'v0.0.0',
          buildNumber: '0',
          releaseDate: '',
          status: UpdateStatus.apiError,
          errorMessage: error.toString(),
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _triggerUpdate() async {
    if (_result == null || !_result!.hasUpdate) {
      return;
    }

    setState(() {
      _isUpdating = true;
      _downloadedBytes = 0;
      _downloadTotalBytes = 0;
      _errorMessage = null;
    });
    try {
      final service = _service ?? _buildService();
      final download = await service.downloadUpdate(
        onProgress: (received, total) {
          if (!mounted) return;
          setState(() {
            _downloadedBytes = received;
            _downloadTotalBytes = total;
          });
        },
      );
      if (!mounted) return;
      final launched = await _installer.installApk(download.filePath);
      if (!mounted) return;
      if (!launched) {
        throw StateError(
          'Android could not open the downloaded APK installer.',
        );
      }
      await _refreshUpdates(showLoading: false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'APK downloaded. Confirm installation in the Android installer.',
          ),
        ),
      );
    } catch (error, stackTrace) {
      if (!mounted) return;
      debugPrint('Update installation failed: $error\n$stackTrace');
      setState(() {
        _errorMessage = error.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to start update: ${_formatErrorMessage(error)}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
          _downloadedBytes = 0;
          _downloadTotalBytes = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KnightPageScaffold(
      title: 'App Updates',
      showBackButton: true,
      body: RefreshIndicator(
        onRefresh: () => _refreshUpdates(showLoading: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading)
                  _buildCheckingCard(theme)
                else if (_errorMessage != null &&
                    _result != null &&
                    _shouldShowError(_result!))
                  _buildErrorCard(theme)
                else if (_result != null) ...[
                  _buildStatusCard(theme),
                  const SizedBox(height: 20),
                  if (_result!.status == UpdateStatus.updateAvailable)
                    _buildUpdateAvailableCard(theme)
                  else if (_result!.status == UpdateStatus.latest)
                    _buildNoUpdateCard(theme)
                  else
                    _buildErrorCard(theme),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isUpdating
                          ? null
                          : () => unawaited(_refreshUpdates()),
                      icon: const Icon(Icons.sync_outlined),
                      label: const Text('Check for Updates'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckingCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Checking for updates',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Contacting GitHub Releases and validating the latest package.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    final result = _result!;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Version',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result.currentVersion,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _infoChip(
                    'Latest Version',
                    result.updateInfo?.version ?? result.currentVersion,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoChip(
                    'Release Date',
                    result.releaseDate.isNotEmpty
                        ? result.releaseDate
                        : 'Unavailable',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Status',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _statusLabel(result.status),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.errorContainer.withValues(alpha: 0.25),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.error,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _statusLabel(_result!.status),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _result!.errorMessage ?? 'An update check error occurred.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoUpdateCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Up to date',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'KnightOS will check GitHub Releases for the latest build and prompt you when an update is available.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateAvailableCard(ThemeData theme) {
    final updateInfo = _result!.updateInfo!;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KnightOS Update Available',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Version',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              updateInfo.version,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Release Notes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...updateInfo.releaseNotes.map(
              (note) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.circle, size: 8),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(note, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isUpdating) ...[
              LinearProgressIndicator(
                value: _downloadTotalBytes > 0
                    ? _downloadedBytes / _downloadTotalBytes
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                _downloadTotalBytes > 0
                    ? 'Downloading ${_formatBytes(_downloadedBytes)} of ${_formatBytes(_downloadTotalBytes)}'
                    : 'Downloading APK…',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isUpdating ? null : _triggerUpdate,
                    icon: const Icon(Icons.system_update_alt_outlined),
                    label: const Text('Update Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isUpdating ? null : _refreshUpdates,
                    icon: const Icon(Icons.schedule_outlined),
                    label: const Text('Later'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowError(UpdateCheckResult result) {
    return result.status != UpdateStatus.latest &&
        result.status != UpdateStatus.updateAvailable;
  }

  String _statusLabel(UpdateStatus status) {
    switch (status) {
      case UpdateStatus.latest:
        return 'You\'re running the latest version.';
      case UpdateStatus.updateAvailable:
        return 'An update is available.';
      case UpdateStatus.checking:
        return 'Checking for updates…';
      case UpdateStatus.unavailable:
        return 'Update checks are unavailable.';
      case UpdateStatus.networkError:
        return 'We could not reach GitHub. Please try again in a moment.';
      case UpdateStatus.apiError:
        return 'GitHub returned an unexpected API error.';
      case UpdateStatus.parsingError:
        return 'The release payload could not be parsed correctly.';
      case UpdateStatus.repositoryNotFound:
        return 'The configured repository could not be found.';
      case UpdateStatus.noReleasesFound:
        return 'No releases were found for the selected repository.';
      case UpdateStatus.apkAssetMissing:
        return 'The latest release is missing an APK asset.';
      case UpdateStatus.versionUnavailable:
        return 'The release version could not be interpreted.';
    }
  }

  String _normalizeVersion(String candidate) {
    var version = candidate.trim();
    if (version.isEmpty) {
      return '0.0.0';
    }

    version = version.replaceFirst(RegExp(r'^[vV]'), '');
    version = version.split('+').first;
    version = version.split('-').first;
    version = version.replaceAll(RegExp(r'[^0-9.]'), '');

    return version.isEmpty ? '0.0.0' : version;
  }

  int _compareVersions(String installed, String latest) {
    final installedParts = _normalizeVersion(
      installed,
    ).split('.').map(int.tryParse).toList();
    final latestParts = _normalizeVersion(
      latest,
    ).split('.').map(int.tryParse).toList();
    final max = installedParts.length > latestParts.length
        ? installedParts.length
        : latestParts.length;

    for (var index = 0; index < max; index++) {
      final installedValue = index < installedParts.length
          ? (installedParts[index] ?? 0)
          : 0;
      final latestValue = index < latestParts.length
          ? (latestParts[index] ?? 0)
          : 0;
      if (installedValue < latestValue) {
        return -1;
      }
      if (installedValue > latestValue) {
        return 1;
      }
    }
    return 0;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatErrorMessage(Object error) {
    return error.toString().replaceAll('\n', ' ').trim();
  }
}
