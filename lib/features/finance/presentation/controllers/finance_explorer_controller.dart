import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/finance_explorer_filter.dart';
import '../../platform/providers/finance_platform_providers.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

class ExplorerState {
  final List<TransactionData> transactions;
  final bool isLoadingMore;
  final bool hasMore;
  final int offset;

  ExplorerState({
    required this.transactions,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.offset = 0,
  });

  ExplorerState copyWith({
    List<TransactionData>? transactions,
    bool? isLoadingMore,
    bool? hasMore,
    int? offset,
  }) {
    return ExplorerState(
      transactions: transactions ?? this.transactions,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
    );
  }
}

class ExplorerFilterNotifier extends Notifier<ExplorerFilter> {
  @override
  ExplorerFilter build() => ExplorerFilter();

  void update(ExplorerFilter filter) => state = filter;
}

final explorerFilterProvider = NotifierProvider<ExplorerFilterNotifier, ExplorerFilter>(ExplorerFilterNotifier.new);

final financeExplorerProvider = AsyncNotifierProvider<FinanceExplorerController, ExplorerState>(
  FinanceExplorerController.new,
);

class FinanceExplorerController extends AsyncNotifier<ExplorerState> {
  static const int _pageSize = 50;

  @override
  Future<ExplorerState> build() async {
    final filter = ref.watch(explorerFilterProvider);
    final txs = await _fetchTransactions(filter, 0);
    return ExplorerState(
      transactions: txs,
      hasMore: txs.length >= _pageSize,
      offset: _pageSize,
    );
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || currentState.isLoadingMore || !currentState.hasMore) return;

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    final filter = ref.read(explorerFilterProvider);
    final moreTxs = await _fetchTransactions(filter, currentState.offset);

    state = AsyncValue.data(currentState.copyWith(
      transactions: [...currentState.transactions, ...moreTxs],
      isLoadingMore: false,
      hasMore: moreTxs.length >= _pageSize,
      offset: currentState.offset + _pageSize,
    ));
  }

  Future<List<TransactionData>> _fetchTransactions(ExplorerFilter filter, int offset) async {
    final dao = ref.read(financePlatformDaoProvider);
    return dao.searchTransactions(
      query: filter.searchQuery,
      categories: filter.categories,
      types: filter.types,
      start: filter.dateRange?.start,
      end: filter.dateRange?.end,
      limit: _pageSize,
      offset: offset,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
