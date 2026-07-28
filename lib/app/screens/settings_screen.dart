import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_constants.dart';
import '../widgets/knight_page_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildProfileCard(context),
            const SizedBox(height: 32),
            _buildSettingsList(context),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DesignColors.white05),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: DesignColors.accentBlue,
            child: Text('TJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tejas Jha', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Senior Associate - Technical Support', style: TextStyle(fontSize: 12, color: Colors.white38)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final items = [
      _SItem('Profile & Account', Icons.person_outline_rounded),
      _SItem('Preferences', Icons.tune_rounded),
      _SItem('Data & Privacy', Icons.security_rounded),
      _SItem('Integrations', Icons.hub_outlined),
      _SItem('Notifications', Icons.notifications_none_rounded),
      _SItem('Appearance', Icons.palette_outlined),
    ];

    return Column(
      children: [
        ...items.map((item) => _buildSettingsTile(item)),
        const SizedBox(height: 12),
        _buildAboutTile(context),
      ],
    );
  }

  Widget _buildSettingsTile(_SItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(item.icon, color: Colors.white38, size: 22),
        title: Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10, size: 20),
        onTap: () {},
      ),
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline_rounded, color: Colors.white38, size: 22),
      title: const Text('About Knight OS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: const Text('Version 2.0.0', style: TextStyle(fontSize: 11, color: Colors.white24)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10, size: 20),
      onTap: () {},
    );
  }
}

class _SItem {
  const _SItem(this.label, this.icon);
  final String label;
  final IconData icon;
}
