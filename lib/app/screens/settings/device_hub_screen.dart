import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/knight_page_scaffold.dart';

// Placeholder providers if not found elsewhere
final connectedDevicesProvider = Provider<List<dynamic>>((ref) => []);
// ignore: unused_element
final _externalIntegrationsProvider = Provider<List<dynamic>>((ref) => []);

class DeviceHubScreen extends ConsumerWidget {
  const DeviceHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return KnightPageScaffold(
      title: 'Device Hub',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(28),
        children: const [
          Text('CONNECTED DEVICES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 2.0)),
          SizedBox(height: 24),
          Center(child: Text('No devices connected.', style: TextStyle(color: Colors.white38))),
        ],
      ),
    );
  }
}
