import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';

class KnowledgeVaultScreen extends ConsumerWidget {
  const KnowledgeVaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      title: 'Knowledge Vault',
      showBackButton: true,
      body: const Center(child: Text('Vault items will appear here')),
    );
  }
}
