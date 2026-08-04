import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../domain/repositories/i_auth_repository.dart';
import '../domain/entities/auth_user.dart';
import '../internal/utils/knight_logger.dart';
import '../storage/secure_storage.dart';

class GoogleAuthService implements IAuthProvider {
  GoogleAuthService._({SecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const SecureStorage();

  static final GoogleAuthService instance = GoogleAuthService._();

  final SecureStorage _secureStorage;

  @override
  String get providerId => 'google.com';

  @override
  AuthUser? get currentUser {
    final account = _googleSignIn.currentUser;
    if (account == null) return null;
    return _mapToAuthUser(account);
  }

  GoogleSignInAccount? get googleAccount => _googleSignIn.currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/calendar.readonly',
      'https://www.googleapis.com/auth/calendar.events',
      'https://www.googleapis.com/auth/gmail.readonly',
      'https://www.googleapis.com/auth/gmail.modify',
      'https://www.googleapis.com/auth/drive.readonly',
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/tasks.readonly',
    ],
  );

  Stream<GoogleSignInAccount?> get onCurrentUserChanged =>
      _googleSignIn.onCurrentUserChanged;

  @override
  Future<AuthUser?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        KnightLogger.info('[AUTH] Google Sign-In successful: ${account.email}');
        await _persistTokens(account);
        return _mapToAuthUser(account);
      }
      return null;
    } catch (e) {
      KnightLogger.error('[AUTH] Google Sign-In failed', error: e);
      rethrow;
    }
  }

  @override
  Future<AuthUser?> signInSilently() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        KnightLogger.info('[AUTH] Google Silent Sign-In successful: ${account.email}');
        await _persistTokens(account);
        return _mapToAuthUser(account);
      }
      return null;
    } catch (e) {
      KnightLogger.error('[AUTH] Google Silent Sign-In failed', error: e);
      return null;
    }
  }

  AuthUser _mapToAuthUser(GoogleSignInAccount account) {
    return AuthUser(
      uid: account.id,
      email: account.email,
      displayName: account.displayName,
      photoUrl: account.photoUrl,
      providerId: providerId,
    );
  }

  Future<void> _persistTokens(GoogleSignInAccount account) async {
    final auth = await account.authentication;
    if (auth.accessToken != null) {
      await _secureStorage.write(SecureStorage.googleAccessTokenKey, auth.accessToken!);
    }
    if (auth.idToken != null) {
      await _secureStorage.write(SecureStorage.googleIdTokenKey, auth.idToken!);
    }
    // Refresh token is usually not provided by google_sign_in on mobile for security reasons.
    // It's managed internally by the plugin.
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _secureStorage.delete(SecureStorage.googleAccessTokenKey);
    await _secureStorage.delete(SecureStorage.googleIdTokenKey);
    KnightLogger.info('[AUTH] Google signed out');
  }

  Future<bool> requestScopes(List<String> scopes) async {
    try {
      final bool success = await _googleSignIn.requestScopes(scopes);
      if (success) {
        KnightLogger.info('[AUTH] Scopes granted: $scopes');
        if (_googleSignIn.currentUser != null) {
          await _persistTokens(_googleSignIn.currentUser!);
        }
      } else {
        KnightLogger.warn('[AUTH] Scopes denied: $scopes');
      }
      return success;
    } catch (e) {
      KnightLogger.error('[AUTH] Failed to request scopes', error: e);
      return false;
    }
  }

  Future<Map<String, String>> getAuthHeaders() async {
    var account = _googleSignIn.currentUser;
    if (account == null) {
      // Try silent sign in if currentUser is null
      await signInSilently();
      account = _googleSignIn.currentUser;
      if (account == null) throw Exception('No user signed in');
      return await account.authHeaders;
    }
    return await account.authHeaders;
  }

  Future<http.Client> getAuthenticatedClient() async {
    final headers = await getAuthHeaders();
    return _AuthenticatedClient(headers, http.Client());
  }

  Future<bool> hasScopes(List<String> requiredScopes) async {
    final account = _googleSignIn.currentUser;
    if (account == null) return false;

    return await _googleSignIn.canAccessScopes(requiredScopes);
  }
}

class _AuthenticatedClient extends http.BaseClient {
  _AuthenticatedClient(this.headers, this.innerClient);

  final Map<String, String> headers;
  final http.Client innerClient;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(headers);
    return innerClient.send(request);
  }

  @override
  void close() {
    innerClient.close();
    super.close();
  }
}
