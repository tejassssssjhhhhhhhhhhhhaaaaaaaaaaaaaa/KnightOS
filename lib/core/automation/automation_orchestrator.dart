import 'engines/trigger_engine.dart';
import 'engines/action_engine.dart';
import 'workflows/proactive_budget_workflow.dart';
import '../intelligence/engines/memory_engine.dart';
import '../intelligence/intelligence_bus.dart';
import 'package:knight_os/core/internal/utils/knight_logger.dart';

/// Orchestrates the entire Version 5 automation system.
class AutomationOrchestrator {
  AutomationOrchestrator({
    required this.bus,
    required this.memoryEngine,
  }) : triggers = TriggerEngine(bus: bus),
       actions = ActionEngine() {
    _init();
  }

  final IntelligenceBus bus;
  final MemoryEngine memoryEngine;
  final TriggerEngine triggers;
  final ActionEngine actions;

  void _init() {
    KnightLogger.info('[AUTOMATION] Initializing V5 Framework...');
    
    // 1. Register Core Actions
    actions.registerAction('notify_user', (params) async {
       KnightLogger.info('[CORE ACTION] Notify User: ${params['title']}');
       // In a full implementation, this would trigger a system notification.
       return true;
    });

    // 2. Initialize Workflows
    ProactiveBudgetWorkflow(
      triggers: triggers,
      actions: actions,
      memoryEngine: memoryEngine,
    ).init();

    // 3. Start Engine
    triggers.start();
  }

  void dispose() {
    triggers.stop();
  }
}
