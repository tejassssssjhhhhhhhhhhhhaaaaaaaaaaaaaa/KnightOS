import 'dart:async';
import '../../services/google_auth_service.dart';
import '../engines/memory_engine.dart';
import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../../internal/utils/knight_logger.dart';

class UserIdentityService {
  UserIdentityService({
    required this.authService,
    required this.memoryEngine,
  }) {
    _init();
  }

  final GoogleAuthService authService;
  final MemoryEngine memoryEngine;
  StreamSubscription? _authSubscription;

  void _init() {
    _authSubscription = authService.onCurrentUserChanged.listen((user) {
      if (user != null) {
        _syncUserIdentity();
      }
    });
    
    // Initial check
    if (authService.currentUser != null) {
      _syncUserIdentity();
    }
  }

  void dispose() {
    _authSubscription?.cancel();
  }

  Future<void> _syncUserIdentity() async {
    final user = authService.currentUser;
    if (user == null) return;

    KnightLogger.info('[IDENTITY] Syncing user identity memory for ${user.email}');

    final existing = await memoryEngine.getLatest('user-profile-identity');
    
    final content = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'lastActive': DateTime.now().toIso8601String(),
    };

    if (existing == null) {
      await memoryEngine.save(KnightMemory.create(
        memoryId: 'user-profile-identity',
        category: BookCategory.identity,
        domain: MemoryDomain.identity,
        source: MemorySource.imported,
        content: content,
        summary: 'Primary user identity for ${user.displayName ?? user.email}',
        importance: 1.0,
      ));
    } else {
      // Future: Update if changed significantly
    }
  }
}
