import 'package:flutter/material.dart';
import '../../app/widgets/knight_page_scaffold.dart';
import '../../core/brain/knight_brain.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late final KnightBrain _brain;
  late Future<Map<String, Object?>> _timelineFuture;

  @override
  void initState() {
    super.initState();
    _brain = KnightBrain();
    _timelineFuture = _brain.buildTimeline();
  }

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Life timeline',
      showBackButton: true,
      body: FutureBuilder<Map<String, Object?>>(
        future: _timelineFuture,
        builder: (context, snapshot) {
          final items = (snapshot.data?['items'] as List?) ?? const <Map<String, Object?>>[];
          return ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Life timeline', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('This timeline collects journal entries, memories, learning goals, voice notes, and companion reflections in one place.', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('No timeline items yet. Add a memory, journal entry, or learning goal to start building your history.')))
              else ...[
                ...items.map((item) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.timeline_rounded),
                    title: Text(item['title'] as String? ?? 'Untitled'),
                    subtitle: Text(item['type'] as String? ?? 'item'),
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
