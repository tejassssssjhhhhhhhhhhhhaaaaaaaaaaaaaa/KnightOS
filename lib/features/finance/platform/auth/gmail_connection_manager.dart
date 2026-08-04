import '../../../../core/services/google_auth_service.dart';
import '../../../../core/internal/utils/knight_logger.dart';
import '../interfaces/finance_connector.dart';

class GmailConnectionManager implements IFinanceConnector {
  final GoogleAuthService _authService = GoogleAuthService.instance;

  static const List<String> _requiredScopes = [
    'https://www.googleapis.com/auth/gmail.readonly',
    'https://www.googleapis.com/auth/gmail.modify',
  ];

  @override
  Future<bool> connect() async {
    try {
      final account = await _authService.signIn();
      if (account == null) return false;

      final hasScopes = await _authService.hasScopes(_requiredScopes);
      if (!hasScopes) {
        return await _authService.requestScopes(_requiredScopes);
      }
      return true;
    } catch (e) {
      KnightLogger.error('[FINANCE] Gmail connection failed', error: e);
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    await _authService.signOut();
  }

  @override
  Future<bool> isConnected() async {
    final account = _authService.currentUser;
    if (account == null) return false;
    return await _authService.hasScopes(_requiredScopes);
  }

  @override
  Future<void> refreshConnection() async {
    await _authService.signInSilently();
  }

  @override
  Stream<List<Map<String, dynamic>>> fetchMessages({
    DateTime? start,
    DateTime? end,
    String? cursor,
  }) {
    // Logic for Module 2 and 5 will be implemented in historical_scanner_service.dart
    throw UnimplementedError('fetchMessages implementation reserved for Milestone 2');
  }

  @override
  Stream<Map<String, dynamic>> watchNewMessages() {
    // Logic for Module 9 will be implemented in real_time_sync_service.dart
    throw UnimplementedError('watchNewMessages implementation reserved for Milestone 5');
  }
  
  /// Checks connection health and authentication status.
  Future<Map<String, dynamic>> checkHealth() async {
    final connected = await isConnected();
    final user = _authService.currentUser;
    
    return {
      'connected': connected,
      'email': user?.email,
      'scopes_granted': connected,
      'last_checked': DateTime.now().toIso8601String(),
    };
  }
}
