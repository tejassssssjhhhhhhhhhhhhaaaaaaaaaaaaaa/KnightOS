import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/connectors/infrastructure/connector_registry.dart';
import '../../../core/connectors/domain/knight_connector.dart';

class ConnectorDashboardScreen extends ConsumerWidget {
  const ConnectorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectors = ConnectorRegistry.connectors;

    return KnightPageScaffold(
      title: 'Data Ecosystem',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildConnectorGrid(context, connectors),
            const SizedBox(height: 32),
            _buildSyncHistory(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unified Connectors',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage the ingestion and synchronization of your digital footprint.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white38),
        ),
      ],
    );
  }

  Widget _buildConnectorGrid(
    BuildContext context,
    List<KnightConnector> connectors,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: connectors.length,
      itemBuilder: (context, i) {
        final connector = connectors[i];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    connector.metadata.icon,
                    color: connector.metadata.accentColor,
                  ),
                  const Spacer(),
                  Text(
                    connector.metadata.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'v${connector.metadata.version}',
                    style: const TextStyle(fontSize: 10, color: Colors.white24),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSyncHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text('No recent ingestion missions found.'),
      ],
    );
  }
}
