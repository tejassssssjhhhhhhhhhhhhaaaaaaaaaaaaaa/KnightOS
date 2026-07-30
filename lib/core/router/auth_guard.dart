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
      // Version 4: Guests can access most routes.
      // We only redirect if we explicitly want to force auth for a specific action.
      return authenticated;
    } catch (error) {
      debugPrint('Auth guard failed: $error');
      return false;
    }
  }
}
