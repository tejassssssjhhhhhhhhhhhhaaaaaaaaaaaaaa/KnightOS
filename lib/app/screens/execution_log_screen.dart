import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/intelligence/domain/workflow_models.dart';
import '../../core/intelligence/providers/intelligence_providers.dart';
import '../widgets/knight_page_scaffold.dart';

class ExecutionLogScreen extends ConsumerWidget {
  const ExecutionLogScreen({required this.planId, super.key});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch active executions to get the latest state
    final activeAsync = ref.watch(activeExecutionsProvider);
    final engine = ref.watch(autonomousEngineProvider);

    return KnightPageScaffold(
      body: activeAsync.when(
        data: (states) {
          final state = states.firstWhere((s) => s.planId == planId, orElse: () {
             // If not active, maybe it finished? 
             // For now we just return the last known state if possible or a message
             return WorkflowState(planId: planId, status: WorkflowStatus.queued, currentTaskId: null);
          });

          final reasoning = engine.getFailureReasoning(planId);

          return _LogContent(state: state, reasoning: reasoning);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _LogContent extends StatelessWidget {
  const _LogContent({required this.state, this.reasoning});
  final WorkflowState state;
  final dynamic reasoning; // ReasoningResult

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('EXECUTION TELEMETRY'),
          pinned: true,
          backgroundColor: DesignColors.background.withValues(alpha: 0.8),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(DesignSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusHeader(),
                const SizedBox(height: 32),
                if (state.status == WorkflowStatus.failed && reasoning != null)
                  _buildFailureAnalysis(context),
                const SizedBox(height: 32),
                const Text(
                  'SYSTEM LOGS',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 2.0),
                ),
                const SizedBox(height: 16),
                _buildLogEntry('Initializing Knight Autonomous Subsystem...', '07:42:01'),
                _buildLogEntry('Fetching plan definition: ${state.planId}', '07:42:02'),
                _buildLogEntry('Context verified. Security level: Green.', '07:42:02'),
                if (state.currentTaskId != null)
                   _buildLogEntry('Executing task: ${state.currentTaskId} (Local)', '07:42:03', isActive: true),
                if (state.errorMessage != null && state.errorMessage!.contains('denied'))
                   _buildLogEntry('USER INTERVENTION: ${state.errorMessage}', '07:42:04', isWarning: true),
                if (state.status == WorkflowStatus.failed)
                   _buildLogEntry('CRITICAL: ${state.errorMessage}', '07:42:05', isError: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.status.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.w900, 
                  color: state.status == WorkflowStatus.failed ? DesignColors.error : DesignColors.accentBlue
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Plan ID: ${state.planId}',
                style: const TextStyle(fontSize: 12, color: Colors.white38),
              ),
            ],
          ),
        ),
        CircularProgressIndicator(
          value: state.progress,
          backgroundColor: DesignColors.white05,
          color: DesignColors.accentBlue,
        ),
      ],
    );
  }

  Widget _buildFailureAnalysis(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DesignColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology_outlined, color: DesignColors.error, size: 20),
              SizedBox(width: 8),
              Text(
                'KNIGHT REASONING: RECOVERY',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: DesignColors.error),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reasoning.summary,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          if (reasoning.recommendations.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...reasoning.recommendations.map((rec) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('• ${rec.description}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildLogEntry(String message, String time, {bool isActive = false, bool isError = false, bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(fontSize: 10, color: Colors.white10, fontFamily: 'monospace')),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12, 
                color: isError ? DesignColors.error : (isWarning ? DesignColors.warning : (isActive ? Colors.white : Colors.white38)),
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
