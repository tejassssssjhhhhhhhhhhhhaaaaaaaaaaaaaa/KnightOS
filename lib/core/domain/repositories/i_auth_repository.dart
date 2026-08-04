import '../entities/auth_user.dart';
import '../entities/identity.dart';

/// Interface for authentication operations.
abstract class IAuthRepository {
  /// Stream of the current identity.
  Stream<Identity> get onIdentityChanged;

  /// Current authenticated identity.
  Identity get currentIdentity;

  /// Signs in with the specified provider ID.
  Future<Identity> signIn(String providerId);

  /// Signs in silently with available providers.
  Future<Identity> signInSilently();

  /// Signs out of all providers.
  Future<void> signOut();

  /// Links a new provider to the current identity.
  Future<Identity> linkProvider(String providerId);
}

/// Interface for individual authentication providers (Google, Apple, etc.).
abstract class IAuthProvider {
  /// The unique identifier for this provider (e.g., 'google.com').
  String get providerId;

  /// Signs in with this provider.
  Future<AuthUser?> signIn();

  /// Signs in silently if possible.
  Future<AuthUser?> signInSilently();

  /// Signs out of this provider.
  Future<void> signOut();

  /// Returns the current authenticated user for this provider.
  AuthUser? get currentUser;
}
