import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/widgets/knight_page_scaffold.dart';
import '../../../../core/domain/entities/evidence.dart';
import '../controllers/evidence_inbox_controller.dart';

class EvidenceDetailScreen extends ConsumerWidget {
  const EvidenceDetailScreen({super.key, required this.item});
  final Evidence item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(evidenceInboxControllerProvider.notifier);

    return KnightPageScaffold(
      title: 'Evidence Detail',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.originalName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _StatusChip(status: item.verificationStatus),
            const SizedBox(height: 24),
            
            const Text('Metadata Extraction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (item.mimeType == 'application/x-google-calendar-event')
              _CalendarMetadataView(data: item.extractionData)
            else
              _MetadataView(data: item.extractionData),
            
            const SizedBox(height: 32),
            const Text('Audit History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (item.auditHistory.isEmpty) 
              const Text('No audit entries yet.')
            else 
              ...item.auditHistory.map((entry) => ListTile(
                dense: true,
                title: Text(entry.action),
                subtitle: Text(entry.timestamp.toLocal().toString()),
                trailing: entry.notes != null ? const Icon(Icons.comment) : null,
              )),

            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.reject(item.caid);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('REJECT'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.verify(item.caid);
                      Navigator.pop(context);
                    },
                    child: const Text('VERIFY & TRUST'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final EvidenceVerificationStatus status;
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status.name.toUpperCase()),
      backgroundColor: status == EvidenceVerificationStatus.verified ? Colors.green.shade50 : null,
    );
  }
}

class _MetadataView extends StatelessWidget {
  const _MetadataView({required this.data});
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        const JsonEncoder.withIndent('  ').convert(data),
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}

class _CalendarMetadataView extends StatelessWidget {
  const _CalendarMetadataView({required this.data});
  final Map<String, dynamic> data;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow('Category', data['category']?.toString().toUpperCase() ?? 'UNKNOWN', icon: Icons.category),
        _buildRow('Start', data['start_time'] ?? 'N/A', icon: Icons.access_time),
        _buildRow('End', data['end_time'] ?? 'N/A', icon: Icons.access_time_filled),
        _buildRow('Location', data['location'] ?? 'None', icon: Icons.location_on),
        _buildRow('Attendees', '${data['attendees_count'] ?? 0}', icon: Icons.people),
        const Divider(),
        _buildRow('Connector', data['source_connector'] ?? 'Unknown', icon: Icons.hub),
        _buildRow('Google ID', data['id'] ?? 'N/A', icon: Icons.fingerprint),
      ],
    );
  }

  Widget _buildRow(String label, String value, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
