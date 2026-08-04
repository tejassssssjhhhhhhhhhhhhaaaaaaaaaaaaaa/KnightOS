import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import 'controllers/manual_import_controller.dart';
import 'providers/import_history_provider.dart';

import 'widgets/connector_card.dart';

class ImportCenterScreen extends ConsumerWidget {
  const ImportCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(manualImportControllerProvider);
    final controller = ref.read(manualImportControllerProvider.notifier);
    final history = ref.watch(importHistoryProvider);

    return KnightPageScaffold(
      title: 'Import Center',
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.inbox),
          tooltip: 'Evidence Inbox',
          onPressed: () => context.push('/evidence/inbox'),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cloud Connectors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Automate evidence collection from your trusted cloud providers.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const ConnectorCard(),
            
            const SizedBox(height: 32),
            const Text(
              'Manual Evidence Ingestion',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            _ImportTypeGrid(
              onSelected: (type) => controller.pickAndImport(type),
              isLoading: state.isImporting,
            ),

            if (state.error != null) ...[
              const SizedBox(height: 24),
              _ErrorCard(message: state.error!),
            ],

            if (state.lastImportedId != null) ...[
              const SizedBox(height: 24),
              _SuccessCard(id: state.lastImportedId!),
            ],

            const SizedBox(height: 32),
            const Text(
              'Recent Imports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            history.when(
              data: (items) => items.isEmpty 
                ? const Text('No recent manual imports.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(item.originalName),
                        subtitle: Text('Imported: ${item.ingestedAt.toLocal()}'),
                      );
                    },
                  ),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error loading history: $err'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportTypeGrid extends StatelessWidget {
  const _ImportTypeGrid({required this.onSelected, required this.isLoading});
  final Function(String) onSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _TypeTile(
          title: 'Resume',
          icon: Icons.description,
          onTap: () => onSelected('resume'),
          isLoading: isLoading,
        ),
        _TypeTile(
          title: 'Certificate',
          icon: Icons.verified,
          onTap: () => onSelected('certificate'),
          isLoading: isLoading,
        ),
        _TypeTile(
          title: 'CSV Data',
          icon: Icons.table_chart,
          onTap: () => onSelected('csv'),
          isLoading: isLoading,
        ),
        _TypeTile(
          title: 'Image',
          icon: Icons.image,
          onTap: () => onSelected('image'),
          isLoading: isLoading,
        ),
      ],
    );
  }
}

class _TypeTile extends StatelessWidget {
  const _TypeTile({required this.title, required this.icon, required this.onTap, required this.isLoading});
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Import Successful', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                Text('Evidence ID: $id', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
