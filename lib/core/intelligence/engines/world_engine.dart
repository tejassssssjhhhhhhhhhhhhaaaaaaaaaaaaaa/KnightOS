import '../domain/world_models.dart';
import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../../world/domain/world_connector.dart';
import '../intelligence_bus.dart';

/// The perception layer that aggregates and normalizes external data.
class WorldEngine {
  WorldEngine({required this.bus});

  final IntelligenceBus bus;
  final List<WorldConnector> _connectors = [];
  WorldState _lastState = WorldState.empty;

  List<WorldConnector> get registeredConnectors => List.unmodifiable(_connectors);

  void registerConnector(WorldConnector connector) {
    _connectors.add(connector);
  }

  /// Aggregates data from all available connectors and produces a [WorldResult].
  Future<WorldResult> perceive() async {
    final now = DateTime.now();
    final Map<String, dynamic> rawData = {};
    final List<WorldEvent> events = [];
    final List<KnightMemory> memories = [];
    final List<String> diff = [];

    // Parallel execution of connectors
    final results = await Future.wait(_connectors.map((c) async {
      if (await c.isAvailable()) {
        try {
          final data = await c.fetchData();
          return MapEntry(c, data);
        } catch (_) {
          return null;
        }
      }
      return null;
    }));

    for (final entry in results) {
      if (entry == null) continue;
      final connector = entry.key;
      final data = entry.value;
      
      rawData[connector.id] = data;

      // 1. Normalization
      _normalizeConnectorData(connector, data, memories);

      // 2. Change Detection
      final changeMessage = _detectChange(connector, data, events);
      if (changeMessage != null) {
        diff.add(changeMessage);
      }
    }

    final state = WorldState(
      weather: rawData['weather']?['current'] ?? 
               rawData['open-weather']?['current'] ?? 'Unknown',
      calendarEvents: (rawData['google-calendar']?['items'] as List?)
              ?.map((e) => CalendarEvent.fromJson(e))
              .toList() ??
          (rawData['calendar']?['items'] as List?)
              ?.map((e) => CalendarEvent(
                    id: 'ext-${e.hashCode}',
                    title: e.toString(),
                    startTime: now,
                    endTime: now.add(const Duration(hours: 1)),
                  ))
              .toList() ??
          [],
      emailThreads: (rawData['google-email']?['threads'] as List?)
              ?.map((e) => EmailThread.fromJson(e))
              .toList() ??
          [],
      marketStatus: rawData['finance']?['market'] ?? 'Closed',
      lastSync: now,
      sourceData: rawData,
    );

    _lastState = state;

    return WorldResult(
      state: state,
      events: events,
      memories: memories,
      timestamp: now,
      diff: diff,
    );
  }

  void _normalizeConnectorData(
    WorldConnector connector,
    Map<String, dynamic> data,
    List<KnightMemory> memories,
  ) {
    // Shared normalization logic
    if (connector.id.contains('calendar')) {
      final items = data['items'] as List?;
      if (items != null) {
        for (var item in items) {
          final title = item is Map ? item['title'] : item.toString();
          memories.add(KnightMemory.create(
            memoryId: 'ext-event-${item.hashCode}',
            category: BookCategory.history,
            domain: MemoryDomain.memories,
            source: MemorySource.imported,
            content: item is Map ? Map<String, dynamic>.from(item) : {'title': item},
            summary: title,
            provenance: connector.source.id,
          ));
        }
      }
    }

    if (connector.id.contains('email')) {
      final threads = data['threads'] as List?;
      if (threads != null) {
        for (var thread in threads) {
          final subject = thread['subject'] ?? 'No Subject';
          memories.add(KnightMemory.create(
            memoryId: 'ext-email-${thread['id']}',
            category: BookCategory.social,
            domain: MemoryDomain.memories,
            source: MemorySource.imported,
            content: Map<String, dynamic>.from(thread),
            summary: 'Email from ${thread['sender']}: $subject',
            provenance: connector.source.id,
          ));
        }
      }
    }
  }

  String? _detectChange(
    WorldConnector connector,
    Map<String, dynamic> newData,
    List<WorldEvent> events,
  ) {
    final oldData = _lastState.sourceData[connector.id];
    if (oldData != null && oldData.toString() != newData.toString()) {
      final event = WorldEvent(
        id: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        sourceId: connector.id,
        type: 'data_changed',
        payload: newData,
        timestamp: DateTime.now(),
      );
      events.add(event);
      return 'Update from ${connector.name}: Content changed.';
    }
    return null;
  }
}
