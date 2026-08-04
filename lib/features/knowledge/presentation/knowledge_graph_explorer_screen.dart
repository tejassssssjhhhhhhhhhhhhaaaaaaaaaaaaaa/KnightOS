import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';

class KnowledgeGraphExplorerScreen extends ConsumerWidget {
  const KnowledgeGraphExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      title: 'Knowledge Graph',
      showBackButton: true,
      body: Center(
        child: Text('Nodes: 0'),
      ),
    );
  }
}
