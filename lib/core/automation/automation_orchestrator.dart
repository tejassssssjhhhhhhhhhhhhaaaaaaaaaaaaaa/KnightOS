import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'engines/trigger_engine.dart';
import 'engines/action_engine.dart';
import 'workflows/proactive_budget_workflow.dart';
import '../intelligence/engines/memory_engine.dart';
import '../intelligence/intelligence_bus.dart';
import '../intelligence/services/google_data_hub.dart';
import '../intelligence/services/sync_task_service.dart';
import 'package:knight_os/core/internal/utils/knight_logger.dart';

/// Orchestrates the entire Version 5 automation system.
class AutomationOrchestrator {
  AutomationOrchestrator({
    required this.bus,
    required this.memoryEngine,
    required this.ref,
  }) : triggers = TriggerEngine(bus: bus),
       actions = ActionEngine() {
    _init();
  }

  final IntelligenceBus bus;
  final MemoryEngine memoryEngine;
  final Ref ref;
  final TriggerEngine triggers;
  final ActionEngine actions;

  void _init() {
    KnightLogger.info('[AUTOMATION] Initializing Knight OS Platform...');
    
    // 1. Initialize Intelligence Subsystems
    ref.read(syncTaskServiceProvider.notifier).startPolling();
    
    // 2. Trigger Google Data Hub Synchronization (Delayed to avoid startup ANR)
    Future.delayed(const Duration(seconds: 5), () {
       if (ref.exists(googleDataHubProvider)) {
         ref.read(googleDataHubProvider.notifier).startUnifiedSync();
       }
    });
    
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
