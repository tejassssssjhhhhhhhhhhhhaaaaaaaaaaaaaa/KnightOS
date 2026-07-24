import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:knight_os/core/storage/local_database.dart';

const MethodChannel _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
late Directory _tempDirectory;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    _tempDirectory = await Directory.systemTemp.createTemp('knight_os_local_database_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      _pathProviderChannel,
      (call) async {
        if (call.method == 'getApplicationSupportDirectory' || call.method == 'getApplicationDocumentsDirectory') {
          return _tempDirectory.path;
        }
        return null;
      },
    );
  });

  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(_pathProviderChannel, null);
    if (await _tempDirectory.exists()) {
      await _tempDirectory.delete(recursive: true);
    }
  });

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
