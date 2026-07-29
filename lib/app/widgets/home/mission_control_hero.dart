import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../screens/execution_log_screen.dart';

class MissionControlHero extends ConsumerWidget {
  const MissionControlHero({
    required this.name,
    required this.greeting,
    required this.quote,
    super.key,
  });

  final String name;
  final String greeting;
  final String quote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Action Bar (Menu & Notification)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.notes_rounded, color: Colors.white, size: 24),
            Row(
              children: [
                const _AutonomousStatusIndicator(),
                const SizedBox(width: 16),
                Stack(
                  children: [
                    const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: DesignColors.health,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // 2. Multi-line Greeting
        GestureDetector(
          onLongPress: () => ref.read(voiceServiceProvider.notifier).startListening(),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 32,
                height: 1.2,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(text: 'Good $greeting,\n'),
                TextSpan(
                  text: name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Icon(Icons.workspace_premium_rounded, color: DesignColors.achievements, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 3. Daily Quote
        Center(
          child: Text(
            quote,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white38,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _AutonomousStatusIndicator extends ConsumerWidget {
  const _AutonomousStatusIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync = ref.watch(activeExecutionsProvider);

    return activeAsync.when(
      data: (states) {
        if (states.isEmpty) return const SizedBox.shrink();
        final state = states.first;

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ExecutionLogScreen(planId: state.planId),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: DesignColors.accentBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: DesignColors.accentBlue.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: DesignColors.accentBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'RUNNING...',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: DesignColors.accentBlue,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
