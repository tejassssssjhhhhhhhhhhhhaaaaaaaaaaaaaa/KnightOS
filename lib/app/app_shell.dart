import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/floating_nav_bar.dart';

class KnightShell extends StatelessWidget {
  const KnightShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    String location = '';
    try {
      location = GoRouterState.of(context).matchedLocation;
    } catch (_) {}

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          child,
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingNavBar(currentLocation: location),
          ),
        ],
      ),
    );
  }
}
