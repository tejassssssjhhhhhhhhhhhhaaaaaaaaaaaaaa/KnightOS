import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/widgets/knight_page_scaffold.dart';
import '../../core/brain/knight_brain.dart';
import '../../core/providers/app_providers.dart';

class UniversalSearchScreen extends ConsumerStatefulWidget {
  const UniversalSearchScreen({super.key});

  @override
  ConsumerState<UniversalSearchScreen> createState() =>
      _UniversalSearchScreenState();
}

class _UniversalSearchScreenState extends ConsumerState<UniversalSearchScreen> {
  late final KnightBrain _brain;
  final _controller = TextEditingController();
  Future<Map<String, Object?>>? _searchFuture;

  @override
  void initState() {
    super.initState();
    _brain = ref.read(knightBrainProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runSearch() {
    setState(() {
      _searchFuture = _brain.searchAcrossSystems(_controller.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Universal search',
      showBackButton: true,
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Search memories, journals, and learning',
            ),
            onSubmitted: (_) => _runSearch(),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _runSearch,
            icon: const Icon(Icons.search_rounded),
            label: const Text('Search'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<Map<String, Object?>>(
              future: _searchFuture,
              builder: (context, snapshot) {
                final matches =
                    (snapshot.data?['matches'] as List?) ??
                    const <Map<String, Object?>>[];
                if (matches.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Search your memories, learning, journal, and companion notes.',
                      ),
                    ),
                  );
                }
                return ListView(
                  children: matches
                      .map(
                        (match) => Card(
                          child: ListTile(
                            title: Text(
                              match['title'] as String? ?? 'Untitled',
                            ),
                            subtitle: Text(match['type'] as String? ?? 'item'),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
