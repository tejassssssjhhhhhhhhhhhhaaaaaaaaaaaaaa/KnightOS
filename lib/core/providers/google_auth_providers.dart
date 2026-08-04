import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/google_auth_service.dart';
import '../services/google_api_connectivity_service.dart';
import '../storage/secure_storage.dart';

/// Provider for the Secure Storage service.
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return const SecureStorage();
});

/// Provider for the Google Auth service.
final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService.instance;
});

/// Provider for the Google API Connectivity service.
final googleApiConnectivityServiceProvider =
    Provider<GoogleApiConnectivityService>((ref) {
  return GoogleApiConnectivityService.instance;
});

/// StreamProvider for the current Google account.
final googleAccountProvider = StreamProvider((ref) {
  final authService = ref.watch(googleAuthServiceProvider);
  return authService.onCurrentUserChanged;
});
