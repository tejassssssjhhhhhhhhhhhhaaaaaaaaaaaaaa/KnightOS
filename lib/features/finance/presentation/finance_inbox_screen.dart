import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import 'controllers/finance_inbox_controller.dart';
import 'widgets/finance_inbox_widgets.dart';
import '../platform/providers/finance_platform_providers.dart';

class FinanceInboxScreen extends ConsumerWidget {
  const FinanceInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(financeInboxControllerProvider);
    final filter = ref.watch(inboxFilterProvider);

    return KnightPageScaffold(
      title: 'Finance Inbox',
      showBackButton: true,
      body: Column(
        children: [
          _buildHeader(ref, filter),
          Expanded(
            child: tasksAsync.when(
              data: (tasks) => tasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) => InboxItemCard(
                        task: tasks[index],
                        onAction: (action) => _handleAction(context, ref, tasks[index], action),
                        onExplain: () => _showExplanation(context, tasks[index]),
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Inbox Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref, InboxFilter filter) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => ref.read(inboxFilterProvider.notifier).update(filter.copyWith(searchQuery: v)),
            decoration: InputDecoration(
              hintText: 'Search merchant, institution...',
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'PRIORITY',
                  selected: filter.priority != null,
                  onTap: () => _showFilterMenu(ref, 'priority'),
                ),
                _FilterChip(
                  label: 'TYPE',
                  selected: filter.taskType != null,
                  onTap: () => _showFilterMenu(ref, 'taskType'),
                ),
                _FilterChip(
                  label: 'INSTITUTION',
                  selected: filter.institution != null,
                  onTap: () => _showFilterMenu(ref, 'institution'),
                ),
                if (filter.priority != null || filter.taskType != null || filter.institution != null)
                  TextButton(
                    onPressed: () => ref.read(inboxFilterProvider.notifier).update(InboxFilter()),
                    child: const Text('CLEAR ALL', style: TextStyle(fontSize: 10, color: Colors.blueAccent)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 64, color: Colors.white10),
          const SizedBox(height: 24),
          Text('OPERATIONAL NOMINAL', style: KnightTokens.label.copyWith(color: Colors.white10)),
          const SizedBox(height: 8),
          const Text('No pending tasks in the Finance Inbox.', style: TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }

  void _showFilterMenu(WidgetRef ref, String type) {
    // Simplified filter selection logic
  }

  void _handleAction(BuildContext context, WidgetRef ref, dynamic task, String action) async {
    final service = ref.read(financeInboxServiceProvider);
    
    switch (action) {
      case 'resolve':
        await service.resolveTask(task.id, 'Manually Resolved');
        break;
      case 'ignore':
        await service.resolveTask(task.id, 'Ignored');
        break;
      // Add other cases...
    }
  }

  void _showExplanation(BuildContext context, dynamic task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => InboxExplainSheet(task: task),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        backgroundColor: selected ? Colors.blueAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
        side: BorderSide(color: selected ? Colors.blueAccent : Colors.white10),
        onPressed: onTap,
      ),
    );
  }
}
