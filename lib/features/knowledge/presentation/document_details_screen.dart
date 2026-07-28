import 'package:flutter/material.dart';
import '../../../core/design_system/widgets/knight_layout.dart';
import '../../../core/design_system/widgets/knight_card.dart';
import '../../../core/domain/models/models.dart';
import '../../../app/widgets/knight_page_scaffold.dart';

class DocumentDetailsScreen extends StatelessWidget {
  const DocumentDetailsScreen({required this.item, super.key});

  final Document item;

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildSummary(context),
            const SizedBox(height: 32),
            _buildMetadata(context),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: item.category.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.category.icon, color: item.category.color, size: 24),
        ),
        const SizedBox(height: 20),
        Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          item.category.label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Colors.white24,
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KnightSectionHeader(
          title: 'Intelligence Summary',
          useDesignPadding: false,
        ),
        const SizedBox(height: 16),
        KnightPremiumCard(
          content: Text(
            'This document contains verified information regarding ${item.tags.join(", ")}. Knight has indexed this as high-confidence evidence.',
            style: const TextStyle(height: 1.5, color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KnightSectionHeader(
          title: 'Source Details',
          useDesignPadding: false,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildMetaRow('File Size', item.fileSize ?? 'Unknown'),
                const Divider(height: 24),
                _buildMetaRow(
                  'Added At',
                  item.addedAt.toIso8601String().split('T').first,
                ),
                const Divider(height: 24),
                _buildMetaRow('Storage', 'Local System'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white38),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
