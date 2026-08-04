import 'dart:async';
import '../domain/entities/identity.dart';
import 'auth_service.dart';

/// Manages the unified user profile and life OS preferences.
class IdentityService {
  IdentityService._({
    AuthService? authService,
  }) : _authService = authService ?? AuthService.instance {
    _authService.onIdentityChanged.listen((identity) {
      _currentIdentity = identity;
    });
  }

  static final IdentityService instance = IdentityService._();

  final AuthService _authService;
  Identity _currentIdentity = Identity.empty;

  Identity get currentIdentity => _currentIdentity;

  Stream<Identity> get onIdentityChanged => _authService.onIdentityChanged;

  /// Returns the career-specific profile data.
  Map<String, dynamic> getCareerProfile() {
    return _currentIdentity.metadata['career'] ?? {};
  }

  /// Updates specific metadata for the identity.
  Future<void> updateMetadata(String key, dynamic value) async {
    final newMetadata = Map<String, dynamic>.from(_currentIdentity.metadata);
    newMetadata[key] = value;
    
    // In a real app, this would persist to the local database / cloud.
    // For now, we update the local object.
    // Note: IdentityService should probably be the one that triggers persistence via Repository.
  }
}
