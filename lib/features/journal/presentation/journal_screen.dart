import 'package:flutter/material.dart';
import '../../../app/widgets/knight_page_scaffold.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Emotional journal',
      showBackButton: true,
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emotional journal',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Type, speak, or attach a reflection. Mood is optional and is only captured if you choose to share it.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Start writing'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
