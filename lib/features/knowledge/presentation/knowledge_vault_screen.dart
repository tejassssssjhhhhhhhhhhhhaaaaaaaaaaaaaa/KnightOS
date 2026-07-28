import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/knight_background.dart';
import '../../../core/design_system/widgets/knight_layout.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import '../../../core/design_system/widgets/knight_states.dart';
import '../../../core/domain/models/models.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import 'widgets/vault_hero.dart';
import 'widgets/vault_search_bar.dart';
import 'widgets/vault_category_card.dart';
import 'widgets/vault_document_card.dart';
import 'widgets/vault_upload_menu.dart';
import 'document_details_screen.dart';
import 'knowledge_vault_controller.dart';

class KnowledgeVaultScreen extends ConsumerStatefulWidget {
  const KnowledgeVaultScreen({super.key});

  @override
  ConsumerState<KnowledgeVaultScreen> createState() =>
      _KnowledgeVaultScreenState();
}

class _KnowledgeVaultScreenState extends ConsumerState<KnowledgeVaultScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(vaultItemsProvider);

    return KnightPageScaffold(
      floatingActionButton: EntranceFader(
        delay: const Duration(milliseconds: 800),
        child: FloatingActionButton.extended(
          onPressed: () => VaultUploadMenu.show(context),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Ingest'),
        ),
      ),
      body: KnightBackground(
        child: itemsAsync.when(
          data: (allItems) {
            final filteredItems = allItems.where((item) {
              return _searchQuery.isEmpty ||
                  item.title.toLowerCase().contains(_searchQuery.toLowerCase());
            }).toList();

            return CustomScrollView(
              clipBehavior: Clip.none,
              slivers: [
                // 1. HERO
                const SliverToBoxAdapter(
                  child: EntranceFader(child: VaultHero()),
                ),

                // 2. SEARCH
                SliverToBoxAdapter(
                  child: EntranceFader(
                    delay: const Duration(milliseconds: 100),
                    child: VaultSearchBar(
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                ),

                // 3. CATEGORIES
                if (_searchQuery.isEmpty) ...[
                  SliverToBoxAdapter(
                    child: EntranceFader(
                      delay: const Duration(milliseconds: 200),
                      child: const KnightSectionHeader(title: 'Categories'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: EntranceFader(
                      delay: const Duration(milliseconds: 250),
                      child: SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignSpacing.m,
                          ),
                          itemCount: DocumentCategory.values.length,
                          itemBuilder: (context, i) => Container(
                            width: 140,
                            margin: const EdgeInsets.only(right: 12),
                            child: VaultCategoryCard(
                              category: DocumentCategory.values[i],
                              count: allItems
                                  .where(
                                    (it) =>
                                        it.category ==
                                        DocumentCategory.values[i],
                                  )
                                  .length,
                              onTap: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                SliverToBoxAdapter(
                  child: EntranceFader(
                    delay: const Duration(milliseconds: 300),
                    child: KnightSectionHeader(
                      title: _searchQuery.isEmpty
                          ? 'Recently Added'
                          : 'Search Results',
                      actionLabel: _searchQuery.isEmpty ? 'See All' : null,
                      onActionPressed: () {},
                    ),
                  ),
                ),

                if (filteredItems.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: KnightEmptyState(
                      title: 'No Matches',
                      message: 'Zero intelligence matches for "$_searchQuery".',
                      icon: Icons.search_off_rounded,
                      actionLabel: 'Clear Search',
                      onAction: () => setState(() => _searchQuery = ''),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => EntranceFader(
                        delay: Duration(milliseconds: 400 + (i * 50)),
                        child: VaultDocumentCard(
                          item: filteredItems[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DocumentDetailsScreen(item: filteredItems[i]),
                            ),
                          ),
                        ),
                      ),
                      childCount: filteredItems.length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            );
          },
          loading: () => const Center(
            child: KnightLoadingState(message: 'Restoring library...'),
          ),
          error: (e, s) => Center(child: KnightErrorState(error: e.toString())),
        ),
      ),
    );
  }
}
