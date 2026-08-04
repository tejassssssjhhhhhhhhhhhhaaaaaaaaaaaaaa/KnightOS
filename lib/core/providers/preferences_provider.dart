import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in main.dart to provide the real instance.
/// In tests, this must also be overridden.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  // We avoid throwing UnimplementedError here to prevent some tool/analysis crashes,
  // but it remains a P0 requirement to override this.
  throw StateError('sharedPreferencesProvider was not overridden. Ensure ProviderScope(overrides: [...]) is used.');
});
