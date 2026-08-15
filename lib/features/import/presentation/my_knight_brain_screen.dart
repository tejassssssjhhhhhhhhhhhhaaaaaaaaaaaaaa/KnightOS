import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/intelligence/providers/brain_provider.dart';
import '../../../core/intelligence/domain/memory_domain.dart';
import '../../../core/intelligence/domain/memory_metadata.dart';
import 'widgets/brain_health_widget.dart';
import 'widgets/memory_list_item.dart';

class MyKnightBrainScreen extends ConsumerStatefulWidget {
  const MyKnightBrainScreen({super.key});

  @override
  ConsumerState<MyKnightBrainScreen> createState() => _MyKnightBrainScreenState();
}

class _MyKnightBrainScreenState extends ConsumerState<MyKnightBrainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync = ref.watch(brainMetricsProvider);
    final health = ref.watch(brainHealthProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildBrainVisualization(),
                      const SizedBox(height: 32),
                      BrainHealthWidget(health: health),
                      const SizedBox(height: 32),
                      metricsAsync.when(
                        data: (metrics) => _buildMetricsGrid(metrics),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text('Error loading metrics: $e', style: const TextStyle(color: Colors.redAccent)),
                      ),
                      const SizedBox(height: 32),
                      _buildKnowledgeDomains(ref),
                      const SizedBox(height: 32),
                      _buildSearchField(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.blueAccent,
                    labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    tabs: const [
                      Tab(text: 'ALL'),
                      Tab(text: 'NEEDS REVIEW'),
                      Tab(text: 'INFERRED'),
                      Tab(text: 'CONFIRMED'),
                      Tab(text: 'STALE'),
                      Tab(text: 'CONFLICTS'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildMemoryList(ref, null),
                _buildMemoryList(ref, KnowledgeState.needsReview),
                _buildMemoryList(ref, KnowledgeState.inferred),
                _buildMemoryList(ref, KnowledgeState.userConfirmed),
                const Center(child: Text('0 stale items found.', style: TextStyle(color: Colors.white24))),
                const Center(child: Text('0 conflicts found.', style: TextStyle(color: Colors.white24))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      floating: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'MY KNIGHT BRAIN',
        style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, fontSize: 14),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INTERNAL KNOWLEDGE GRAPH',
          style: KnightTokens.label,
        ),
        const SizedBox(height: 8),
        Text(
          'What KNIGHT currently knows about your life.',
          style: KnightTokens.subheadline.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildBrainVisualization() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.psychology_outlined, color: Colors.blueAccent, size: 60),
          for (var i = 0; i < 8; i++)
            _PositionedNode(index: i),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(BrainMetrics metrics) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: [
        _metricCard('TOTAL FACTS', metrics.totalFacts.toString(), Colors.blueAccent),
        _metricCard('CONFIRMED', metrics.confirmed.toString(), Colors.greenAccent),
        _metricCard('INFERRED', metrics.inferred.toString(), Colors.purpleAccent),
        _metricCard('NEEDS REVIEW', metrics.needsReview.toString(), Colors.orangeAccent),
      ],
    );
  }

  Widget _metricCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildKnowledgeDomains(WidgetRef ref) {
    final metricsAsync = ref.watch(brainMetricsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('KNOWLEDGE DOMAINS', style: KnightTokens.label),
        const SizedBox(height: 16),
        metricsAsync.when(
          data: (metrics) {
            final activeDomains = metrics.domainCounts.keys.toList();
            if (activeDomains.isEmpty) {
              return const Text('KNIGHT is still learning.', style: TextStyle(color: Colors.white24));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeDomains.length,
              itemBuilder: (context, index) {
                final domainId = activeDomains[index];
                final domain = MemoryDomain.fromId(domainId);
                final count = metrics.domainCounts[domainId] ?? 0;
                
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(domain.icon, color: domain.color, size: 20),
                  title: Text(domain.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  subtitle: Text('$count known facts', style: const TextStyle(fontSize: 11, color: Colors.white24)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10),
                  onTap: () {
                    _tabController.animateTo(0); // Go to ALL
                    ref.read(brainSearchQueryProvider.notifier).update('domain:${domain.label}');
                    _searchController.text = 'domain:${domain.label}';
                  },
                );
              },
            );
          },
          loading: () => const SizedBox(),
          error: (_, _) => const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (val) => ref.read(brainSearchQueryProvider.notifier).update(val),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Search memories...',
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.white24, size: 20),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.03),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildMemoryList(WidgetRef ref, KnowledgeState? filterState) {
    final memoriesAsync = ref.watch(brainFilteredMemoriesProvider);

    return memoriesAsync.when(
      data: (memories) {
        var filtered = memories;
        if (filterState != null) {
          filtered = memories.where((m) => m.knowledgeState == filterState.name).toList();
        }

        if (filtered.isEmpty) {
          return Center(child: Text(filterState == null ? 'No memories found.' : 'No items in ${filterState.name.toUpperCase()} state.', style: const TextStyle(color: Colors.white24)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: filtered.length,
          itemBuilder: (context, index) => MemoryListItem(memory: filtered[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _PositionedNode extends StatelessWidget {
  const _PositionedNode({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    // Semi-random layout for visualization
    final double x = (index % 3 - 1) * 80.0 + (index > 4 ? 20 : -20);
    final double y = (index / 3 - 1) * 40.0;
    
    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.3), blurRadius: 8, spreadRadius: 1),
          ],
        ),
      ),
    );
  }
}
