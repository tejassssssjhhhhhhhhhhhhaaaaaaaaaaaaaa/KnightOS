import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';

class MyDataScreen extends ConsumerWidget {
  const MyDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return KnightPageScaffold(
      title: 'My Data',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const Text('DATA STORAGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 2.0)),
          const SizedBox(height: 24),
          // ... implementation
        ],
      ),
    );
  }
}
