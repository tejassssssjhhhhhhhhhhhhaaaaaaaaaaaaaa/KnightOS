import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/domain/device_models.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../widgets/knight_page_scaffold.dart';

class DeviceHubScreen extends ConsumerWidget {
  const DeviceHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(connectedDevicesProvider);

    return KnightPageScaffold(
      body: devicesAsync.when(
        data: (devices) => _DeviceHubContent(devices: devices),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _DeviceHubContent extends StatelessWidget {
  const _DeviceHubContent({required this.devices});
  final List<KnightDevice> devices;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('DEVICE HUB'),
          pinned: true,
          backgroundColor: DesignColors.background.withValues(alpha: 0.8),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(DesignSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your digital ecosystem is synchronized and ready for autonomous delegation.',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 32),
                ...devices.map((d) => _DeviceTile(device: d)),
                const SizedBox(height: 32),
                _buildAddDeviceCard(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddDeviceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.white05,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DesignColors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.add_link_rounded, color: DesignColors.accentBlue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Link New Device', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Expand your Knight reach', style: TextStyle(fontSize: 12, color: Colors.white24)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white24),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device});
  final KnightDevice device;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DesignColors.white05),
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${device.status.name.toUpperCase()} • Last seen ${DateFormat('HH:mm').format(device.lastSeen)}',
                      style: const TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    switch (device.type) {
      case DeviceType.phone: icon = Icons.phone_android_rounded; break;
      case DeviceType.tablet: icon = Icons.tablet_android_rounded; break;
      case DeviceType.desktop: icon = Icons.desktop_windows_rounded; break;
      case DeviceType.wearable: icon = Icons.watch_rounded; break;
      case DeviceType.hub: icon = Icons.hub_rounded; break;
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesignColors.white05,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: DesignColors.accentBlue, size: 24),
    );
  }

  Color _getStatusColor() {
    switch (device.status) {
      case DeviceStatus.online: return DesignColors.success;
      case DeviceStatus.offline: return Colors.white10;
      case DeviceStatus.away: return DesignColors.warning;
      case DeviceStatus.busy: return DesignColors.error;
    }
  }
}
