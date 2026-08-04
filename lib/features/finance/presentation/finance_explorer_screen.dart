import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../domain/finance_explorer_filter.dart';
import 'controllers/finance_explorer_controller.dart';
import 'widgets/transaction_explorer_widgets.dart';

class FinanceExplorerScreen extends ConsumerWidget {
  const FinanceExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(financeExplorerProvider);
    final filter = ref.watch(explorerFilterProvider);

    return KnightPageScaffold(
      title: 'Explorer',
      showBackButton: true,
      body: Column(
        children: [
          _buildSearchBar(ref, filter),
          Expanded(
            child: stateAsync.when(
              data: (state) => state.transactions.isEmpty
                  ? _buildEmptyState()
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification && notification.metrics.extentAfter < 500) {
                          ref.read(financeExplorerProvider.notifier).loadMore();
                        }
                        return false;
                      },
                      child: RefreshIndicator(
                        onRefresh: () => ref.read(financeExplorerProvider.notifier).refresh(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: state.transactions.length + (state.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.transactions.length) {
                              return const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()));
                            }
                            return TransactionItemCard(
                              tx: state.transactions[index],
                              onTap: () => _showDetails(context, state.transactions[index]),
                            );
                          },
                        ),
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Explorer Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref, ExplorerFilter filter) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => ref.read(explorerFilterProvider.notifier).update(filter.copyWith(searchQuery: v)),
            decoration: InputDecoration(
              hintText: 'Search merchant, ID, reference...',
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
                _FilterChip(label: 'DATE', selected: filter.dateRange != null, onTap: () {}),
                _FilterChip(label: 'CATEGORY', selected: filter.categories.isNotEmpty, onTap: () {}),
                _FilterChip(label: 'TYPE', selected: filter.types.isNotEmpty, onTap: () {}),
                _FilterChip(label: 'VERIFIED', selected: false, onTap: () {}),
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
          const Icon(Icons.search_off_rounded, size: 64, color: Colors.white10),
          const SizedBox(height: 24),
          Text('NO RESULTS', style: KnightTokens.label.copyWith(color: Colors.white10)),
          const SizedBox(height: 8),
          const Text('Try adjusting your filters or search query.', style: TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, dynamic tx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TransactionDetailSheet(tx: tx),
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
