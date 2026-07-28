import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/intelligence/domain/memory_category.dart';

class VaultHero extends ConsumerWidget {
  const VaultHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retrieval = ref.watch(memoryRetrievalEngineProvider);

    return FutureBuilder<int>(
      future: retrieval
          .getByCategory(BookCategory.skills)
          .then((list) => list.length),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;

        return Container(
          padding: const EdgeInsets.fromLTRB(
            DesignSpacing.m,
            DesignSpacing.xl,
            DesignSpacing.m,
            DesignSpacing.l,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KNOWLEDGE VAULT',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: DesignColors.knowledge,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFF1A1A1A),
                    child: Icon(
                      Icons.inventory_2_rounded,
                      size: 14,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignSpacing.m),
              Text(
                'Personal Library',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 36),
              ),
              const SizedBox(height: 8),
              Text(
                'Distilling your acquired expertise into verified semantic nodes.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white38,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: DesignSpacing.l),
              Row(
                children: [
                  _buildStat(context, '$count', 'Nodes'),
                  const SizedBox(width: DesignSpacing.l),
                  _buildStat(context, 'Verified', 'Integrity'),
                  const SizedBox(width: DesignSpacing.l),
                  _buildStat(context, 'Local', 'Storage'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.white24,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
