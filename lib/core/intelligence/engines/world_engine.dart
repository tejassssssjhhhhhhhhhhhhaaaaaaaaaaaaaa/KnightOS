import '../domain/world_models.dart';
import '../domain/knight_memory.dart';
import '../../world/domain/world_connector.dart';
import '../intelligence_bus.dart';

/// The perception layer that aggregates and normalizes external data.
class WorldEngine {
  WorldEngine({required this.bus});

  final IntelligenceBus bus;
  final List<WorldConnector> _connectors = [];

  void registerConnector(WorldConnector connector) {
    _connectors.add(connector);
  }

  /// Aggregates data from all available connectors and produces a [WorldResult].
  Future<WorldResult> perceive() async {
    final now = DateTime.now();
    final Map<String, dynamic> rawData = {};
    final List<WorldEvent> events = [];
    final List<KnightMemory> memories = [];

    for (final connector in _connectors) {
      if (await connector.isAvailable()) {
        try {
          final data = await connector.fetchData();
          rawData[connector.id] = data;
          
          // Future: Normalization logic (RAW -> KnightMemory)
          // Future: Change detection logic (Old State vs New State -> WorldEvent)
        } catch (_) {
          // Log and continue
        }
      }
    }

    final state = WorldState(
      weather: rawData['weather']?['current'] ?? 'Unknown',
      upcomingEvents: List<String>.from(rawData['calendar']?['items'] ?? []),
      marketStatus: rawData['finance']?['market'] ?? 'Closed',
      lastSync: now,
      sourceData: rawData,
    );

    return WorldResult(
      state: state,
      events: events,
      memories: memories,
      timestamp: now,
    );
  }
}
