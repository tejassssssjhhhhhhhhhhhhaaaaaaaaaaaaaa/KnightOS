import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:knight_os/core/services/launch_experience_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LaunchExperienceService', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test(
      'returns true for a first launch of the day and false for repeat launches',
      () async {
        final service = LaunchExperienceService();

        expect(await service.shouldPlayFullExperience(), isTrue);
        await service.markLaunchSeen();
        expect(await service.shouldPlayFullExperience(), isFalse);
      },
    );
  });
}
