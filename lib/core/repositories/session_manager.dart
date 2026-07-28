import 'authentication_repository.dart';

class SessionManager {
  SessionManager({AuthenticationRepository? authenticationRepository})
    : _authenticationRepository =
          authenticationRepository ?? AuthenticationRepository();

  final AuthenticationRepository _authenticationRepository;

  Future<String?> currentUserId() async {
    final session = await _authenticationRepository.getCurrentSession();
    return session?.userId;
  }

  Future<bool> hasActiveSession() async {
    return _authenticationRepository.isAuthenticated();
  }
}
