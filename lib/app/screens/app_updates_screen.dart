import 'package:flutter/material.dart';

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

class _AppUpdatesScreenState extends State<AppUpdatesScreen> {
  late final UpdateService _service;
  late final AndroidUpdateInstaller _installer;
  UpdateCheckResult? _result;
  bool _isLoading = true;
  bool _isUpdating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.updateService ?? GitHubReleaseUpdateProvider(owner: 'tejassssssjhhhhhhhhhhhhaaaaaaaaaaaaaa', repo: 'KnightOS');
    _installer = const AndroidUpdateInstaller();
    _refreshUpdates();
  }

  Future<void> _refreshUpdates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _service.checkForUpdates();
      if (!mounted) return;
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _triggerUpdate() async {
    if (_result == null || !_result!.hasUpdate) {
      return;
    }

    setState(() => _isUpdating = true);
    try {
      await _service.downloadUpdate();
      if (!mounted) return;
      final apkUrl = _result!.updateInfo?.releaseNotes.isNotEmpty == true ? 'https://github.com/tejassssssjhhhhhhhhhhhhaaaaaaaaaaaaaa/KnightOS/releases/latest' : null;
      if (apkUrl != null) {
        final launched = await _installer.openDownloadUrl(apkUrl);
        if (!launched) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to open the APK installer from this device.')),
          );
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update flow started. Install the downloaded APK from your device notifications.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to start update: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KnightPageScaffold(
      title: 'App Updates',
      showBackButton: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshUpdates,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Unable to load update information.\n$_errorMessage',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onErrorContainer),
                      ),
                    )
                  else if (_result != null) ...[
                    _buildStatusCard(theme),
                    const SizedBox(height: 20),
                    if (_result!.hasUpdate)
                      _buildUpdateAvailableCard(theme)
                    else
                      _buildNoUpdateCard(theme),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isUpdating ? null : _refreshUpdates,
                        icon: const Icon(Icons.sync_outlined),
                        label: const Text('Check for Updates'),
                      ),
                    ),
                  ],
                ],
              ),
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
            Text('Current app version', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(result.currentVersion, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _infoChip('Build', result.buildNumber),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoChip('Release', result.releaseDate.isNotEmpty ? result.releaseDate : 'Unavailable'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Status', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(_statusLabel(result.status), style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
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
                Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You\'re running the latest version.',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'KnightOS will check GitHub Releases for the latest build and prompt you when an update is available.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
            Text('KnightOS Update Available', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text('Version', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(updateInfo.version, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Text('What\'s New', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...updateInfo.releaseNotes.map((note) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle, size: 8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(note, style: theme.textTheme.bodyMedium)),
                ],
              ),
            )),
            const SizedBox(height: 16),
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
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
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
    }
  }
}
