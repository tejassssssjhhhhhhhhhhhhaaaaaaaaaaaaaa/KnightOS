import 'intelligence_bus.dart';
import 'intelligence_orchestrator.dart';
import 'engines/memory_engine.dart';
import 'engines/memory_retrieval_engine.dart';

/// Unified facade for the Knight Intelligence Platform.
class IntelligencePlatform {
  IntelligencePlatform({
    required this.bus,
    required this.orchestrator,
    required this.memoryEngine,
    required this.retrieval,
  });

  final IntelligenceBus bus;
  final IntelligenceOrchestrator orchestrator;
  final MemoryEngine memoryEngine;
  final MemoryRetrievalEngine retrieval;

  /// Shorthand to emit events.
  void emit(dynamic event) => bus.emit(event);

  void dispose() {
    bus.dispose();
    orchestrator.dispose();
  }
}
