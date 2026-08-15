import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/floating_nav_bar.dart';
import 'widgets/knight_companion.dart';
import '../core/router/router_providers.dart';
import '../core/router/app_routes.dart';

class KnightShell extends ConsumerWidget {
  const KnightShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String location = '';
    try {
      location = GoRouterState.of(context).matchedLocation;
      // P0: Update global location provider for context awareness
      Future.microtask(() {
        if (ref.read(currentLocationProvider) != location) {
          ref.read(currentLocationProvider.notifier).setLocation(location);
        }
      });
    } catch (_) {}

    final bool showNavBar = location != AppRoutes.knight;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          child,
          const KnightCompanion(),
          if (showNavBar)
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingNavBar(currentLocation: location),
            ),
        ],
      ),
    );
  }
}
