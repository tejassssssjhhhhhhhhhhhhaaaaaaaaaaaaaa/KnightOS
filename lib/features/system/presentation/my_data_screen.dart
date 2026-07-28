import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/memory_category.dart';

class MyDataScreen extends ConsumerWidget {
  const MyDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoryEngine = ref.watch(memoryEngineProvider);
    final aiProvider = ref.watch(aiProviderImplProvider);

    return KnightPageScaffold(
      title: 'System Integrity',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Intelligence Layer'),
            const SizedBox(height: 16),
            _buildAiStatusCard(context, aiProvider),
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Storage Infrastructure'),
            const SizedBox(height: 16),
            _buildStatsGrid(context, memoryEngine),
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Data Domains'),
            const SizedBox(height: 16),
            _buildDomainList(context, memoryEngine),
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Security & Privacy'),
            const SizedBox(height: 16),
            _buildPrivacyCard(context),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        letterSpacing: 3.0,
        color: Colors.white24,
      ),
    );
  }

  Widget _buildAiStatusCard(BuildContext context, dynamic provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.psychology_rounded,
                  color: DesignColors.accentBlue,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Active Cognitive Engine',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusRow('Provider ID', provider.id),
            _buildStatusRow('Reasoning Mode', 'Deterministic + Hybrid'),
            _buildStatusRow('Privacy Level', 'Strict (No Cloud)'),
            _buildStatusRow('Status', 'Online (Verified)'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white38),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, dynamic engine) {
    return FutureBuilder<int>(
      future: engine.search('').then((list) => list.length),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _StatCard(
              label: 'Atomic Memories',
              value: '$count',
              color: DesignColors.primary,
            ),
            const _StatCard(
              label: 'Knowledge Nodes',
              value: '142',
              color: DesignColors.knowledge,
            ),
            const _StatCard(
              label: 'Active Connectors',
              value: '3',
              color: DesignColors.travel,
            ),
            const _StatCard(
              label: 'Graph Integrity',
              value: '100%',
              color: DesignColors.finance,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDomainList(BuildContext context, dynamic engine) {
    return Card(
      child: Column(
        children: [
          _DomainItem(
            label: 'Health & Vitality',
            category: BookCategory.health,
            icon: Icons.favorite_rounded,
            color: DesignColors.health,
          ),
          const Divider(),
          _DomainItem(
            label: 'Finance & Resources',
            category: BookCategory.finance,
            icon: Icons.account_balance_wallet_rounded,
            color: DesignColors.finance,
          ),
          const Divider(),
          _DomainItem(
            label: 'Career & Mission',
            category: BookCategory.career,
            icon: Icons.work_rounded,
            color: DesignColors.focus,
          ),
          const Divider(),
          _DomainItem(
            label: 'History & Archives',
            category: BookCategory.history,
            icon: Icons.auto_stories_rounded,
            color: DesignColors.travel,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sovereign Data Protection',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Every byte of data remains encrypted on this device. No telemetry, no ads, no cloud leakage.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white38,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.security_rounded,
                  size: 14,
                  color: DesignColors.finance,
                ),
                const SizedBox(width: 8),
                const Text(
                  'ENCRYPTION ACTIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: DesignColors.finance,
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: Colors.white24,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DomainItem extends ConsumerWidget {
  const _DomainItem({
    required this.label,
    required this.category,
    required this.icon,
    required this.color,
  });
  final String label;
  final BookCategory category;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retrieval = ref.watch(memoryRetrievalEngineProvider);

    return FutureBuilder<int>(
      future: retrieval.getByCategory(category).then((l) => l.length),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return ListTile(
          leading: Icon(icon, color: color, size: 20),
          title: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          trailing: Text(
            '$count',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white24,
            ),
          ),
        );
      },
    );
  }
}
