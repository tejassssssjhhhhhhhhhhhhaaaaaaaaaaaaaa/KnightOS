import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/internal/utils/knight_logger.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class KnightOsApp extends StatefulWidget {
  const KnightOsApp({super.key, this.theme});

  final ThemeData? theme;

  @override
  State<KnightOsApp> createState() => _KnightOsAppState();
}

class _KnightOsAppState extends State<KnightOsApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    KnightLogger.info('[SYSTEM] KnightOsApp.initState()');
  }

  @override
  Widget build(BuildContext context) {
    KnightLogger.info('[SYSTEM] KnightOsApp.build() starting');
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          KnightLogger.info('[SYSTEM] KnightOsApp.build() inner');
          return MaterialApp.router(
            title: 'KnightOS',
            debugShowCheckedModeBanner: false,
            theme: widget.theme ?? AppTheme.lightTheme(),
            darkTheme: widget.theme ?? AppTheme.darkTheme(),
            themeMode: widget.theme != null ? ThemeMode.light : ThemeMode.system,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
