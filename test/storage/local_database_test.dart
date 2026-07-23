import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:knight_os/core/storage/local_database.dart';

void main() {
  group('LocalDatabase', () {
    test('uses a platform app data directory instead of the working directory', () async {
      final database = LocalDatabase();
      final file = await database.fileFor('auth_session.json');

      final supportDirectory = await getApplicationSupportDirectory();
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final isInAppDataDirectory = file.path.startsWith(supportDirectory.path) || file.path.startsWith(documentsDirectory.path);

      expect(isInAppDataDirectory, isTrue, reason: 'Storage should target an app data directory, not the current working directory.');
      expect(file.path, contains('knight_os'));
    });
  });
}
