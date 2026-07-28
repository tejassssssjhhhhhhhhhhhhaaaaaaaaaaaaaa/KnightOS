import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/knight_background.dart';
import '../../../core/design_system/widgets/knight_layout.dart';
import '../../../core/design_system/widgets/knight_card.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import '../../../core/intelligence/domain/memory_category.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import 'discovery_controller.dart';
import 'widgets/discovery_timeline.dart';

class DiscoveryDashboardScreen extends ConsumerWidget {
  const DiscoveryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(discoveryEngineProvider);

    return KnightPageScaffold(
      body: KnightBackground(
        child: CustomScrollView(
          clipBehavior: Clip.none,
          slivers: [
            // 1. HERO
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
                        'DISCOVERY CENTER',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: DesignColors.knowledge,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.m),
                      Text(
                        'The Reconstruction',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(fontSize: 34),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Building a high-fidelity model of your existence, one star at a time.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white38),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. TIMELINE
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 100),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: DesignSpacing.m),
                  child: DiscoveryTimeline(),
                ),
              ),
            ),

            // 3. CONSTELLATIONS (DOMAINS)
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 200),
                child: const KnightSectionHeader(title: 'Active Constellations'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: DesignSpacing.m,
                  crossAxisSpacing: DesignSpacing.m,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildBuilderDelegate((context, i) {
                  final book = BookCategory.values[i];
                  return FutureBuilder<double>(
                    future: engine.getCompletionRate(book),
                    builder: (context, snapshot) {
                      final rate = snapshot.data ?? 0.0;
                      return EntranceFader(
                        delay: Duration(milliseconds: 300 + (i * 100)),
                        child: _ConstellationCard(book: book, completion: rate),
                      );
                    },
                  );
                }, childCount: BookCategory.values.length),
              ),
            ),

            // 4. NEXT MISSIONS
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 600),
                child: const KnightSectionHeader(title: 'Recommended Missions'),
              ),
            ),
            SliverToBoxAdapter(
              child: EntranceFader(
                delay: const Duration(milliseconds: 700),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSpacing.m,
                  ),
                  child: KnightHeroCard(
                    title: 'Expand Your Identity',
                    subtitle:
                        'Knight requires higher-fidelity data regarding your core values and beliefs.',
                    ctaLabel: 'Initiate Inquiry',
                    onCtaPressed: () {
                      ref
                          .read(discoveryProvider.notifier)
                          .initiateNextInquiry();
                    },
                    accentColor: DesignColors.knowledge,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 140)),
          ],
        ),
      ),
    );
  }
}

class _ConstellationCard extends StatelessWidget {
  const _ConstellationCard({required this.book, required this.completion});

  final BookCategory book;
  final double completion;

  @override
  Widget build(BuildContext context) {
    final bool isComplete = completion >= 1.0;

    return Container(
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(
          color: isComplete
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      padding: const EdgeInsets.all(DesignSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                isComplete
                    ? Icons.auto_awesome_rounded
                    : Icons.star_outline_rounded,
                color: isComplete ? Colors.white : Colors.white24,
                size: 20,
              ),
              Text(
                '${(completion * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            book.label.split('(').first.trim(),
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: completion,
            minHeight: 2,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            color: isComplete ? Colors.white : Colors.white24,
          ),
        ],
      ),
    );
  }
}
