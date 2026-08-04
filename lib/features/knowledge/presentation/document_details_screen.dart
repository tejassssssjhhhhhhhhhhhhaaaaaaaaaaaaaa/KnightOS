import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';

class DocumentDetailsScreen extends ConsumerWidget {
  const DocumentDetailsScreen({required this.documentId, super.key});
  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      title: 'Document Details',
      showBackButton: true,
      body: Center(
        child: Text('Document ID: $documentId'),
      ),
    );
  }
}
