import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../companion/companion_models.dart';
import '../../companion/companion_repository.dart';
import '../../companion/companion_service.dart';
import '../../memory/memory_repository.dart';
import '../../memory/memory_service.dart';

class MemoryScreen extends ConsumerStatefulWidget {
  const MemoryScreen({super.key});

  @override
  ConsumerState<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends ConsumerState<MemoryScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _permissionController = TextEditingController(text: 'conversation_only');
  late final CompanionRepository _companionRepository;
  late final MemoryRepository _memoryRepository;
  late final CompanionService _companionService;
  late final MemoryService _memoryService;

  @override
  void initState() {
    super.initState();
    _companionRepository = CompanionRepository();
    _memoryRepository = MemoryRepository();
    _companionService = const CompanionService();
    _memoryService = const MemoryService();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _permissionController.dispose();
    super.dispose();
  }

  Future<void> _saveMemory() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) {
      return;
    }

    final companionEntry = _companionService.createEntry(title: title, body: body, permission: _permissionController.text.trim().isEmpty ? 'conversation_only' : _permissionController.text.trim());
    await _companionRepository.saveEntry(companionEntry);

    final memory = _memoryService.createMemory(
      userId: 'local-user',
      title: title,
      body: body,
      source: 'chat',
      category: 'memory',
      permission: companionEntry.permission,
    );
    await _memoryRepository.saveMemory(memory);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Memory saved with your chosen permission.')));
    _titleController.clear();
    _bodyController.clear();
    _permissionController.text = 'conversation_only';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Memory',
      showBackButton: true,
      body: FutureBuilder<List<CompanionEntry>>(
        future: _companionRepository.loadEntries(),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? const <CompanionEntry>[];
          return ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trusted companion memory', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Everything here stays user-controlled. Choose whether to remember it forever, temporarily, or only in this conversation.', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Memory title')),
                      const SizedBox(height: 12),
                      TextField(controller: _bodyController, maxLines: 4, decoration: const InputDecoration(labelText: 'What should Knight remember?')),
                      const SizedBox(height: 12),
                      TextField(controller: _permissionController, decoration: const InputDecoration(labelText: 'Permission')),
                      const SizedBox(height: 16),
                      FilledButton.icon(onPressed: _saveMemory, icon: const Icon(Icons.memory_rounded), label: const Text('Save memory')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (entries.isEmpty)
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('No private memories yet. Add one and Knight will keep it under your chosen permission.')))
              else ...[
                Text('Stored memories', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...entries.map((entry) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.memory_outlined),
                    title: Text(entry.title),
                    subtitle: Text('${entry.permission} • ${entry.body}'),
                  ),
                )),
              ],
            ],
          );
        },
      ),
    );
  }
}
