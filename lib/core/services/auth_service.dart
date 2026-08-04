import 'dart:async';
import '../domain/entities/auth_user.dart';
import '../domain/entities/identity.dart';
import '../domain/repositories/i_auth_repository.dart';
import '../internal/utils/knight_logger.dart';
import 'google_auth_service.dart';

/// Central service for authentication, orchestrating multiple providers.
class AuthService implements IAuthRepository {
  AuthService._({
    List<IAuthProvider>? providers,
  }) : _providers = providers ?? [GoogleAuthService.instance] {
    _init();
  }

  static final AuthService instance = AuthService._();

  final List<IAuthProvider> _providers;
  final StreamController<Identity> _identityController = StreamController<Identity>.broadcast();
  Identity _currentIdentity = Identity.empty;

  void _init() {
    // In a real app, we might check local storage to rebuild the identity from previous sessions.
    // For now, we listen to providers or wait for manual sign-ins.
  }

  @override
  Stream<Identity> get onIdentityChanged => _identityController.stream;

  @override
  Identity get currentIdentity => _currentIdentity;

  @override
  Future<Identity> signIn(String providerId) async {
    final provider = _providers.firstWhere(
      (p) => p.providerId == providerId,
      orElse: () => throw Exception('Provider $providerId not found'),
    );

    final authUser = await provider.signIn();
    if (authUser != null) {
      _updateIdentity(authUser);
    }
    return _currentIdentity;
  }

  @override
  Future<Identity> signInSilently() async {
    for (final provider in _providers) {
      final authUser = await provider.signInSilently();
      if (authUser != null) {
        _updateIdentity(authUser);
        return _currentIdentity;
      }
    }
    return _currentIdentity;
  }

  @override
  Future<void> signOut() async {
    for (final provider in _providers) {
      await provider.signOut();
    }
    _currentIdentity = Identity.empty;
    _identityController.add(_currentIdentity);
    KnightLogger.info('[AUTH] Signed out of all providers');
  }

  @override
  Future<Identity> linkProvider(String providerId) async {
    if (_currentIdentity.isEmpty) {
      throw Exception('Must be signed in to link a provider');
    }

    final provider = _providers.firstWhere(
      (p) => p.providerId == providerId,
      orElse: () => throw Exception('Provider $providerId not found'),
    );

    final authUser = await provider.signIn();
    if (authUser != null) {
      _updateIdentity(authUser);
    }
    return _currentIdentity;
  }

  void _updateIdentity(AuthUser authUser) {
    // If identity is empty, start a new one.
    if (_currentIdentity.isEmpty) {
      _currentIdentity = Identity(
        id: authUser.uid, // In production, this would be a KnightOS internal ID
        primaryEmail: authUser.email,
        displayName: authUser.displayName,
        photoUrl: authUser.photoUrl,
        authProviders: [authUser],
      );
    } else {
      // Add or update provider in the list
      final providers = List<AuthUser>.from(_currentIdentity.authProviders);
      final index = providers.indexWhere((p) => p.providerId == authUser.providerId);
      if (index != -1) {
        providers[index] = authUser;
      } else {
        providers.add(authUser);
      }
      _currentIdentity = _currentIdentity.copyWith(authProviders: providers);
    }
    _identityController.add(_currentIdentity);
    KnightLogger.info('[AUTH] Identity updated: ${_currentIdentity.primaryEmail}');
  }
}
