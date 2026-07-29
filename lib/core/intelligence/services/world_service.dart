import '../engines/world_engine.dart';
import '../domain/world_models.dart';
import '../engines/memory_engine.dart';
import '../../world/domain/world_connector.dart';

/// The public perception API for KnightOS.
/// Coordinates the aggregation of external information into the intelligence core.
class WorldService {
  WorldService({required this.engine, required this.memoryEngine});

  final WorldEngine engine;
  final MemoryEngine memoryEngine;
  WorldState _currentState = WorldState.empty;

  /// Returns the cached state from the last perception cycle.
  WorldState get currentState => _currentState;

  /// Triggers a full perception cycle across all registered connectors.
  Future<WorldResult> syncWorld() async {
    final result = await engine.perceive();
    _currentState = result.state;

    // Persist normalized memories to long-term storage
    if (result.memories.isNotEmpty) {
      await memoryEngine.saveAll(result.memories);
    }

    return result;
  }

  /// Registers a new connector into the world engine.
  void registerConnector(WorldConnector connector) {
    engine.registerConnector(connector);
  }
}
