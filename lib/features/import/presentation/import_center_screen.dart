import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/knight_background.dart';
import '../../../core/design_system/widgets/knight_layout.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../infrastructure/import_registry.dart';
import '../../atlas/presentation/life_atlas_controller.dart';
import '../../knowledge/presentation/knowledge_vault_controller.dart';
import '../../../core/internal/utils/import_processor.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import 'widgets/import_source_card.dart';

class ImportCenterScreen extends ConsumerWidget {
  const ImportCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = ImportRegistry.providers;

    return KnightPageScaffold(
      floatingActionButton: EntranceFader(
        delay: const Duration(milliseconds: 1000),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final engine = ref.read(memoryEngineProvider);
            await ImportProcessor.processLocalTimeline(engine);
            // Refresh dependent providers
            ref.invalidate(atlasEventsProvider);
            ref.invalidate(vaultItemsProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'MISSION SUCCESS: Digital footprint integrated.',
                  ),
                ),
              );
            }
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          icon: const Icon(Icons.bolt_rounded),
          label: const Text('Process Local Mission'),
        ),
      ),
      body: KnightBackground(
        child: CustomScrollView(
          clipBehavior: Clip.none,
          slivers: [
            // 1. HORIZON HERO
            SliverToBoxAdapter(
              child: EntranceFader(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    DesignSpacing.m,
                    DesignSpacing.xl,
                    DesignSpacing.m,
                    DesignSpacing.l,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DATA INGESTION',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: DesignColors.travel,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.m),
                      Text(
                        'Import History',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(fontSize: 34),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Securely integrate your digital footprint into the KnightOS ecosystem.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white38),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. PROVIDERS (PLUGINS)
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 100),
                child: const KnightSectionHeader(title: 'Available Sources'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: DesignSpacing.m,
                  crossAxisSpacing: DesignSpacing.m,
                  childAspectRatio: 1.3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => EntranceFader(
                    delay: Duration(milliseconds: 200 + (i * 100)),
                    child: ImportSourceCard(
                      provider: providers[i],
                      onImport: () {},
                    ),
                  ),
                  childCount: providers.length,
                ),
              ),
            ),

            // 3. AUDIT LOG (MANIFESTS)
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 500),
                child: const KnightSectionHeader(title: 'Mission Manifests'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => EntranceFader(
                    delay: Duration(milliseconds: 600 + (i * 50)),
                    child: _buildManifestItem(context),
                  ),
                  childCount: 3,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 140)),
          ],
        ),
      ),
    );
  }

  Widget _buildManifestItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(DesignSpacing.l),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: DesignRadius.card,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignSpacing.s),
            decoration: BoxDecoration(
              color: DesignColors.finance.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: DesignColors.finance,
              size: 16,
            ),
          ),
          const SizedBox(width: DesignSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statement_July.pdf',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                Text(
                  'PARSER: FINANCE v1.0 • 84 RECORDS',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
          const Text(
            'TODAY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }
}
