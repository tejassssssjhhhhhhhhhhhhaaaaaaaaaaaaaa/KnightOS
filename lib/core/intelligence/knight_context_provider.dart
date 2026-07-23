import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'knight_context_service.dart';

final knightContextServiceProvider = Provider<KnightContextService>((ref) {
  return KnightContextService();
});
