import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/google_auth_providers.dart';
import 'app_routes.dart';

/// Notifier that manages the router state and redirects.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(
      googleAccountProvider,
      (_, _) => notifyListeners(),
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(googleAccountProvider);
    
    // P0: Don't redirect while auth is initializing to avoid flickering or false-positives
    if (authState.isLoading) return null;

    final account = authState.value;
    final location = state.matchedLocation;

    // Public routes that don't require auth (Guest Mode / Onboarding)
    final isPublicRoute = location == AppRoutes.splash ||
                         location == AppRoutes.welcome ||
                         location == AppRoutes.auth ||
                         location == AppRoutes.onboarding ||
                         location == AppRoutes.home;

    if (account == null) {
      // If not logged in and trying to access a private route, go to welcome
      return isPublicRoute ? null : AppRoutes.welcome;
    }

    // If logged in and on a landing/auth screen, go to home
    final isLandingRoute = location == AppRoutes.auth || 
                          location == AppRoutes.splash ||
                          location == AppRoutes.welcome;
                          
    if (isLandingRoute) {
      return AppRoutes.home;
    }

    return null;
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});
