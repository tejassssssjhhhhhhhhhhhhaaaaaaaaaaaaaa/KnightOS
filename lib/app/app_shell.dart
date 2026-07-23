import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_routes.dart';

class KnightShell extends StatelessWidget {
  const KnightShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);
    final destinations = <NavigationDestination>[
      const NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
      const NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome_rounded), label: 'Knight'),
      const NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school_rounded), label: 'Learning'),
      const NavigationDestination(icon: Icon(Icons.memory_outlined), selectedIcon: Icon(Icons.memory_rounded), label: 'Memory'),
      const NavigationDestination(icon: Icon(Icons.book_outlined), selectedIcon: Icon(Icons.book_rounded), label: 'Journal'),
      const NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet_rounded), label: 'Finance'),
      const NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: 'Settings'),
    ];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 840) {
              return Column(
                children: [
                  Expanded(child: child),
                  NavigationBar(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (index) => _handleTap(context, index),
                    destinations: destinations,
                  ),
                ],
              );
            }

            return Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => _handleTap(context, index),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: Text('Dashboard')),
                    NavigationRailDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome_rounded), label: Text('Knight')),
                    NavigationRailDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school_rounded), label: Text('Learning')),
                    NavigationRailDestination(icon: Icon(Icons.memory_outlined), selectedIcon: Icon(Icons.memory_rounded), label: Text('Memory')),
                    NavigationRailDestination(icon: Icon(Icons.book_outlined), selectedIcon: Icon(Icons.book_rounded), label: Text('Journal')),
                    NavigationRailDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet_rounded), label: Text('Finance')),
                    NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: Text('Settings')),
                  ],
                ),
                Expanded(child: child),
              ],
            );
          },
        ),
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.knight)) return 1;
    if (location.startsWith(AppRoutes.learning)) return 2;
    if (location.startsWith(AppRoutes.memory)) return 3;
    if (location.startsWith(AppRoutes.journal)) return 4;
    if (location.startsWith(AppRoutes.finance)) return 5;
    if (location.startsWith(AppRoutes.settings)) return 6;
    return 0;
  }

  void _handleTap(BuildContext context, int index) {
    switch (index) {
      case 1:
        context.go(AppRoutes.knight);
        break;
      case 2:
        context.go(AppRoutes.learning);
        break;
      case 3:
        context.go(AppRoutes.memory);
        break;
      case 4:
        context.go(AppRoutes.journal);
        break;
      case 5:
        context.go(AppRoutes.finance);
        break;
      case 6:
        context.go(AppRoutes.settings);
        break;
      case 0:
      default:
        context.go(AppRoutes.dashboard);
        break;
    }
  }
}
