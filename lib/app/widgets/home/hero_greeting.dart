import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/current_user_provider.dart';
import '../../../features/welcome/domain/time_period.dart';

/// The hero section of the Home screen providing a personalized greeting.
class HomeHeroGreeting extends ConsumerWidget {
  /// Creates a [HomeHeroGreeting].
  const HomeHeroGreeting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userContextAsync = ref.watch(currentUserProvider);
    final hour = DateTime.now().hour;
    final greeting = TimePeriod.fromHour(hour).greeting;

    return Semantics(
      header: true,
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userContextAsync.when(
            data: (user) {
              final name = user.displayName.split(' ').first;
              final fullGreeting = name.isNotEmpty
                  ? '$greeting, $name'
                  : greeting;
              return Text(
                fullGreeting,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.8,
                  height: 1.0,
                ),
              );
            },
            loading: () => Text(
              greeting,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1.8,
                height: 1.0,
              ),
            ),
            error: (_, _) => Text(
              greeting,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1.8,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Semantics(
            label: 'System status: everything is ready for today.',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Everything is ready for today.',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
