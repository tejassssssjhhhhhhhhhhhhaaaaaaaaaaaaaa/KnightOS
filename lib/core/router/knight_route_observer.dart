import 'package:flutter/widgets.dart';
import '../internal/utils/knight_logger.dart';

class KnightRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _log('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _log('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _log('REPLACE', newRoute, oldRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _log('REMOVE', route, previousRoute);
  }

  void _log(String action, Route<dynamic> route, Route<dynamic>? previousRoute) {
    final now = DateTime.now().toIso8601String().split('T').last;
    final prevName = previousRoute?.settings.name ?? 'none';
    final nextName = route.settings.name ?? route.toString();
    
    KnightLogger.info(
      '[$now] [NAV] $action: $prevName -> $nextName',
      category: KnightLogCategory.ui,
    );
  }
}
