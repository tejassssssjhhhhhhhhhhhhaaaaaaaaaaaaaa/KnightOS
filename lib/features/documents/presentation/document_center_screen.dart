import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';

class DocumentCenterScreen extends ConsumerWidget {
  const DocumentCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return KnightPageScaffold(
      title: 'Documents',
      showBackButton: true,
      body: ListView.builder(
        padding: const EdgeInsets.all(28),
        itemCount: 0,
        itemBuilder: (context, i) => const SizedBox.shrink(),
      ),
    );
  }
}
