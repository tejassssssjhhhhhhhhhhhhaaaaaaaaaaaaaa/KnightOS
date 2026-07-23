import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../repositories/authentication_repository.dart';
import 'app_routes.dart';

class AuthGuard {
  const AuthGuard._();

  static Future<bool> canAccessProtectedRoute(BuildContext context) async {
    try {
      final repository = AuthenticationRepository();
      final authenticated = await repository.isAuthenticated();
      if (!authenticated) {
        if (context.mounted) {
          context.go(AppRoutes.auth);
        }
        return false;
      }
      return true;
    } catch (error) {
      debugPrint('Auth guard failed: $error');
      if (context.mounted) {
        context.go(AppRoutes.auth);
      }
      return false;
    }
  }
}
