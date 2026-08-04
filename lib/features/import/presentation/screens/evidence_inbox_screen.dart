import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/widgets/knight_page_scaffold.dart';
import '../../../../core/domain/entities/evidence.dart';
import '../controllers/evidence_inbox_controller.dart';

class EvidenceInboxScreen extends ConsumerWidget {
  const EvidenceInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(evidenceInboxControllerProvider);
    final controller = ref.read(evidenceInboxControllerProvider.notifier);

    return KnightPageScaffold(
      title: 'Evidence Inbox',
      showBackButton: true,
      body: Column(
        children: [
          _FilterHeader(
            currentFilter: state.filter,
            onFilterChanged: controller.setFilter,
          ),
          Expanded(
            child: state.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : state.items.isEmpty 
                ? const Center(child: Text('No evidence matching this filter.'))
                : ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return _EvidenceListTile(
                        item: item,
                        onVerify: () => controller.verify(item.caid),
                        onReject: () => controller.reject(item.caid),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterHeader extends StatelessWidget {
  const _FilterHeader({required this.currentFilter, required this.onFilterChanged});
  final EvidenceVerificationStatus currentFilter;
  final Function(EvidenceVerificationStatus) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: EvidenceVerificationStatus.values.map((status) {
          final isSelected = currentFilter == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(status.name.toUpperCase()),
              selected: isSelected,
              onSelected: (_) => onFilterChanged(status),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EvidenceListTile extends StatelessWidget {
  const _EvidenceListTile({required this.item, required this.onVerify, required this.onReject});
  final Evidence item;
  final VoidCallback onVerify;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insert_drive_file, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.originalName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                _ConfidenceBadge(score: item.confidence),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Source: ${item.extractionData['source_connector'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Domain: ${item.domain}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onReject,
                  child: const Text('REJECT', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onVerify,
                  child: const Text('VERIFY'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.score});
  final double score;
  @override
  Widget build(BuildContext context) {
    final color = score > 0.8 ? Colors.green : score > 0.5 ? Colors.orange : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        '${(score * 100).toInt()}% Confidence',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
