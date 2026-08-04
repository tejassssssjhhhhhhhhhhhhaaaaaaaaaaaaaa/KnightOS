import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../platform/providers/finance_platform_providers.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

class InboxFilter {
  final String? priority;
  final String? institution;
  final String? taskType;
  final String searchQuery;

  InboxFilter({
    this.priority,
    this.institution,
    this.taskType,
    this.searchQuery = '',
  });

  InboxFilter copyWith({
    String? priority,
    String? institution,
    String? taskType,
    String? searchQuery,
  }) {
    return InboxFilter(
      priority: priority ?? this.priority,
      institution: institution ?? this.institution,
      taskType: taskType ?? this.taskType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class InboxFilterNotifier extends Notifier<InboxFilter> {
  @override
  InboxFilter build() => InboxFilter();

  void update(InboxFilter filter) => state = filter;
}

final inboxFilterProvider = NotifierProvider<InboxFilterNotifier, InboxFilter>(InboxFilterNotifier.new);

final financeInboxControllerProvider = StreamProvider<List<FinanceInboxTaskData>>((ref) {
  final service = ref.watch(financeInboxServiceProvider);
  final filter = ref.watch(inboxFilterProvider);
  
  return service.watchPendingTasks().map((tasks) {
    return tasks.where((task) {
      if (filter.priority != null && task.priority != filter.priority) return false;
      if (filter.institution != null && task.institution != filter.institution) return false;
      if (filter.taskType != null && task.taskType != filter.taskType) return false;
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        final desc = task.description?.toLowerCase() ?? '';
        final type = task.taskType.toLowerCase();
        final inst = task.institution?.toLowerCase() ?? '';
        return desc.contains(query) || type.contains(query) || inst.contains(query);
      }
      return true;
    }).toList();
  });
});

class InboxExplanation {
  final String title;
  final String reason;
  final String engine;
  final List<String> evidence;
  final double confidence;
  final String suggestedAction;
  final String impact;

  InboxExplanation({
    required this.title,
    required this.reason,
    required this.engine,
    required this.evidence,
    required this.confidence,
    required this.suggestedAction,
    required this.impact,
  });
}

final inboxExplanationProvider = FutureProvider.family<InboxExplanation, FinanceInboxTaskData>((ref, task) async {
  final service = ref.watch(financeInboxServiceProvider);
  final context = await service.getTaskContext(task.messageId ?? '');
  
  return InboxExplanation(
    title: task.taskType,
    reason: task.description ?? 'System identified a possible gap or inconsistency.',
    engine: task.engineSource ?? 'Finance Verification Engine',
    evidence: context['message'] != null ? ['Gmail Message: ${task.messageId}'] : [],
    confidence: task.confidence ?? 0.0,
    suggestedAction: _getSuggestedAction(task.taskType),
    impact: _getImpact(task.taskType),
  );
});

String _getSuggestedAction(String type) {
  switch (type) {
    case 'Needs Review': return 'Verify the extracted amount and merchant.';
    case 'Possible Duplicate': return 'Check if these transactions refer to the same event.';
    case 'Missing Statement': return 'Check for statement emails around this period.';
    default: return 'Review available evidence and resolve.';
  }
}

String _getImpact(String type) {
  switch (type) {
    case 'Needs Review': return 'Ensures accuracy of net worth and expense trends.';
    case 'Possible Duplicate': return 'Prevents over-counting of expenses.';
    default: return 'Improves overall financial platform health.';
  }
}
