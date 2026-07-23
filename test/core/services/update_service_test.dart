import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/services/update_service.dart';

void main() {
  group('MockUpdateService', () {
    test('returns a structured update result with mock metadata', () async {
      final service = MockUpdateService();

      final result = await service.checkForUpdates();

      expect(result.currentVersion, isNotEmpty);
      expect(result.buildNumber, isNotEmpty);
      expect(result.releaseDate, isNotEmpty);
      expect(result.status, isA<UpdateStatus>());
      expect(result.updateInfo, isNotNull);
      expect(result.updateInfo!.version, isNotEmpty);
      expect(result.updateInfo!.releaseNotes, isNotEmpty);
    });
  });
}
