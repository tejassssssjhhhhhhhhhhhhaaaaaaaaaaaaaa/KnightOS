import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/google_calendar_controller.dart';
import '../../../../core/domain/connectors/i_connector.dart';

import 'calendar_filter_ui.dart';

class ConnectorCard extends ConsumerWidget {
  const ConnectorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(googleCalendarControllerProvider);
    final controller = ref.read(googleCalendarControllerProvider.notifier);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calendar_month, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Google Calendar',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _getStatusText(state.status),
                        style: TextStyle(color: _getStatusColor(state.status)),
                      ),
                    ],
                  ),
                ),
                if (state.isSyncing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else ...[
                  if (state.status == ConnectorStatus.completed || state.status == ConnectorStatus.connected)
                    IconButton(
                      icon: const Icon(Icons.settings, size: 20),
                      onPressed: () => _showFilterDialog(context),
                    ),
                  _buildAction(context, state, controller),
                ],
              ],
            ),
            if (state.error != null) ...[
              const SizedBox(height: 12),
              Text(state.error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
            if (state.lastProcessed > 0) ...[
              const SizedBox(height: 12),
              Text('Last sync processed ${state.lastProcessed} events', style: const TextStyle(fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CalendarFilterUI(),
    );
  }

  Widget _buildAction(BuildContext context, GoogleCalendarState state, GoogleCalendarNotifier controller) {
    if (state.status == ConnectorStatus.registered || state.status == ConnectorStatus.failed) {
      return TextButton(
        onPressed: () => controller.authorize(),
        child: const Text('Connect'),
      );
    }
    
    return IconButton(
      icon: const Icon(Icons.sync),
      onPressed: () => controller.sync(),
    );
  }

  String _getStatusText(ConnectorStatus status) {
    switch (status) {
      case ConnectorStatus.registered: return 'Not Connected';
      case ConnectorStatus.authorized: return 'Authorized';
      case ConnectorStatus.connected: return 'Connected';
      case ConnectorStatus.syncing: return 'Syncing...';
      case ConnectorStatus.completed: return 'Synced';
      case ConnectorStatus.failed: return 'Sync Failed';
      default: return status.name;
    }
  }

  Color _getStatusColor(ConnectorStatus status) {
    switch (status) {
      case ConnectorStatus.completed: return Colors.green;
      case ConnectorStatus.failed: return Colors.red;
      case ConnectorStatus.syncing: return Colors.blue;
      default: return Colors.grey;
    }
  }
}
