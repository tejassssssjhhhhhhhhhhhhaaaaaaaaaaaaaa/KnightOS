import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../automation/automation_orchestrator.dart';
import '../intelligence/providers/intelligence_providers.dart';

/// Provider for the [AutomationOrchestrator].
final automationOrchestratorProvider = Provider<AutomationOrchestrator>((ref) {
  final orchestrator = AutomationOrchestrator(
    bus: ref.watch(intelligenceBusProvider),
    memoryEngine: ref.watch(memoryEngineProvider),
  );
  
  ref.onDispose(() => orchestrator.dispose());
  
  return orchestrator;
});
