import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../../../core/providers/database_provider.dart';

class HubResourceListScreen extends ConsumerWidget {
  const HubResourceListScreen({super.key, required this.resourceType});
  final String resourceType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(knightDatabaseProvider);
    
    return KnightPageScaffold(
      title: resourceType.toUpperCase(),
      showBackButton: true,
      body: FutureBuilder<List<dynamic>>(
        future: _fetchData(db),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              if (item is GoogleResourceData) {
                return _ResourceCard(item: item);
              } else if (item is GmailMessageData) {
                return _EmailCard(item: item);
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchData(KnightDatabase db) async {
    if (resourceType == 'email') {
      return db.gmailMessageDao.select(db.gmailMessageTable).get();
    }
    return db.googleResourceDao.getByType(resourceType);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIcon(), size: 64, color: Colors.white10),
          const SizedBox(height: 24),
          Text('NO ${resourceType.toUpperCase()} SYNCED', style: KnightTokens.label.copyWith(color: Colors.white10)),
          const SizedBox(height: 8),
          const Text('Run a historical sync in the Data Hub.', style: TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (resourceType) {
      case 'task': return Icons.task_alt_rounded;
      case 'contact': return Icons.people_rounded;
      case 'calendar': return Icons.calendar_today_rounded;
      case 'drive': return Icons.insert_drive_file_rounded;
      case 'health': return Icons.favorite_rounded;
      case 'email': return Icons.email_rounded;
      default: return Icons.inventory_2_rounded;
    }
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.item});
  final GoogleResourceData item;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> meta = {};
    try {
      meta = jsonDecode(item.metadata ?? '{}');
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (meta['status'] != null)
                _StatusBadge(status: meta['status']),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Synced on ${DateFormat('MMM dd, yyyy').format(item.resourceDate)}',
            style: const TextStyle(fontSize: 12, color: Colors.white38),
          ),
          if (meta.containsKey('location') && meta['location'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 12, color: Colors.white24),
                  const SizedBox(width: 4),
                  Expanded(child: Text(meta['location'], style: const TextStyle(fontSize: 12, color: Colors.white54))),
                ],
              ),
            ),
          if (meta.containsKey('description') && meta['description'] != null && meta['description'].toString().isNotEmpty)
             Padding(
               padding: const EdgeInsets.only(top: 16.0),
               child: Text(meta['description'], style: const TextStyle(fontSize: 13, color: Colors.white60, height: 1.4)),
             ),
          if (meta.containsKey('htmlLink') && meta['htmlLink'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextButton.icon(
                onPressed: () => launchUrl(Uri.parse(meta['htmlLink'])), 
                icon: const Icon(Icons.open_in_new_rounded, size: 14), 
                label: const Text('VIEW IN GOOGLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact, foregroundColor: Colors.blueAccent),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white24;
    if (status == 'confirmed' || status == 'accepted') color = Colors.greenAccent;
    if (status == 'tentative' || status == 'needsAction') color = Colors.orangeAccent;
    if (status == 'cancelled' || status == 'declined') color = Colors.redAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(status.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _EmailCard extends StatelessWidget {
  const _EmailCard({required this.item});
  final GmailMessageData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(item.sender, style: const TextStyle(fontSize: 12, color: Colors.blueAccent)),
          const SizedBox(height: 12),
          Text(
            item.snippet,
            style: const TextStyle(fontSize: 13, color: Colors.white54),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            'Received on ${DateFormat('MMM dd, yyyy HH:mm').format(item.messageDate)}',
            style: const TextStyle(fontSize: 10, color: Colors.white24),
          ),
        ],
      ),
    );
  }
}
