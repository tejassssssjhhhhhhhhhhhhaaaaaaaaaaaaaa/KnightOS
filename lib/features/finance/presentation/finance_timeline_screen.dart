import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import 'controllers/finance_timeline_controller.dart';
import 'widgets/finance_timeline_widgets.dart';

class FinanceTimelineScreen extends ConsumerWidget {
  const FinanceTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(financeTimelineProvider);

    return KnightPageScaffold(
      title: 'Timeline',
      showBackButton: true,
      body: timelineAsync.when(
        data: (periods) => periods.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                onRefresh: () => ref.read(financeTimelineProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: periods.length,
                  itemBuilder: (context, index) => MonthTimelineCard(period: periods[index]),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Timeline Error: $e')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_rounded, size: 64, color: Colors.white10),
          const SizedBox(height: 24),
          Text('NO HISTORY', style: KnightTokens.label.copyWith(color: Colors.white10)),
          const SizedBox(height: 8),
          const Text('Your financial story begins with your first sync.', style: TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }
}
