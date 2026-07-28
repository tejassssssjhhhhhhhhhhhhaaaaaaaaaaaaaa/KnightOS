import 'package:shared_preferences/shared_preferences.dart';

class LaunchExperienceService {
  static const String _storageKey = 'launch_experience_last_seen_date';

  Future<bool> shouldPlayFullExperience() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSeenDate = prefs.getString(_storageKey);
    final today = _todayKey();

    if (lastSeenDate == null || lastSeenDate.isEmpty) {
      return true;
    }

    return lastSeenDate != today;
  }

  Future<void> markLaunchSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, _todayKey());
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
