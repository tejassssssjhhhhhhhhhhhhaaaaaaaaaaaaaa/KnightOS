import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/theme/app_theme.dart';

class KnightOsApp extends StatefulWidget {
  const KnightOsApp({super.key, this.theme});

  final ThemeData? theme;

  @override
  State<KnightOsApp> createState() => _KnightOsAppState();
}

class _KnightOsAppState extends State<KnightOsApp> with WidgetsBindingObserver {
  String _lastRoute = AppRoutes.dashboard;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final router = AppRouter.router;
    final currentLocation = router.routerDelegate.currentConfiguration.fullPath;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (currentLocation.isNotEmpty && currentLocation != '/') {
        _lastRoute = currentLocation;
      }
      return;
    }

    if (state == AppLifecycleState.resumed) {
      final targetRoute = _lastRoute.isNotEmpty && _lastRoute != '/'
          ? _lastRoute
          : AppRoutes.dashboard;
      if (currentLocation != targetRoute) {
        router.go(targetRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: 'KnightOS',
        debugShowCheckedModeBanner: false,
        theme: widget.theme ?? AppTheme.lightTheme(),
        darkTheme: widget.theme ?? AppTheme.darkTheme(),
        themeMode: widget.theme != null ? ThemeMode.light : ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
