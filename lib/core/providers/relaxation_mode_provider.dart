import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'preferences_provider.dart';

/// Notifier for the manual Relaxation Mode override.
/// Persists the state to SharedPreferences.
class RelaxationModeNotifier extends Notifier<bool> {
  static const _key = 'knight_relaxation_mode_active';

  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_key) ?? false;
  }

  Future<void> toggle() async {
    final newValue = !state;
    state = newValue;
    await ref.read(sharedPreferencesProvider).setBool(_key, newValue);
  }

  Future<void> set(bool value) async {
    state = value;
    await ref.read(sharedPreferencesProvider).setBool(_key, value);
  }
}

final relaxationModeProvider = NotifierProvider<RelaxationModeNotifier, bool>(RelaxationModeNotifier.new);
