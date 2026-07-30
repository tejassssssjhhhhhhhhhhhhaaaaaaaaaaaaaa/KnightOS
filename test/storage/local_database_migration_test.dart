import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/storage/local_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path/path.dart' as p;

import '../test_utils/mock_path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late Directory documentsDir;
  late Directory supportDir;
  late LocalDatabase database;

  setUp(() async {
    final mock = MockPathProvider();
    PathProviderPlatform.instance = mock;
    
    documentsDir = await getApplicationDocumentsDirectory();
    supportDir = await getApplicationSupportDirectory();
    
    // Ensure clean state
    if (documentsDir.existsSync()) documentsDir.deleteSync(recursive: true);
    if (supportDir.existsSync()) supportDir.deleteSync(recursive: true);
    
    documentsDir.createSync(recursive: true);
    supportDir.createSync(recursive: true);
    
    database = const LocalDatabase();
  });

  group('LocalDatabase Migration', () {
    test('should find file in documents if missing in support and migrate it', () async {
      const fileName = 'test_migrate.json';
      const content = '{"key": "value"}';
      
      // 1. Place file in "Legacy" location (Documents)
      final legacyFile = File(p.join(documentsDir.path, fileName));
      await legacyFile.writeAsString(content);
      
      // 2. Read string - should trigger migration
      final result = await database.readString(fileName);
      
      expect(result, equals(content));
      
      // 3. Verify file moved to Support
      final newFile = File(p.join(supportDir.path, fileName));
      expect(await newFile.exists(), isTrue);
      expect(await newFile.readAsString(), equals(content));
      
      // 4. Verify legacy file is gone (or preserved? usually better to move to avoid confusion)
      // For safety in this app, we'll move it.
      expect(await legacyFile.exists(), isFalse);
    });

    test('should prefer support directory if file exists in both', () async {
      const fileName = 'overlap.json';
      const oldContent = 'old';
      const newContent = 'new';
      
      await File(p.join(documentsDir.path, fileName)).writeAsString(oldContent);
      await File(p.join(supportDir.path, fileName)).writeAsString(newContent);
      
      final result = await database.readString(fileName);
      expect(result, equals(newContent));
    });
  });
}
