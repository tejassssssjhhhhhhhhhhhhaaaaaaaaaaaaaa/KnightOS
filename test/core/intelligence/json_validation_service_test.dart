import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';

void main() {
  late JsonValidationService service;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('knight_schemas');
    service = JsonValidationService(schemaDirectory: tempDir.path);

    // Create a mock schema for Identity (Domain 1)
    final schemaFile = File('${tempDir.path}/01_identity.schema.json');
    await schemaFile.writeAsString('''
    {
      "\$schema": "https://json-schema.org/draft/2020-12/schema",
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "age": { "type": "number", "minimum": 0 }
      },
      "required": ["name"]
    }
    ''');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('JsonValidationService', () {
    test('validates correct content', () async {
      final content = {'name': 'Knight', 'age': 1};
      await expectLater(
        service.validate(MemoryDomain.identity, content),
        completes,
      );
    });

    test('throws ValidationException for missing required field', () async {
      final content = {'age': 1};
      expect(
        () => service.validate(MemoryDomain.identity, content),
        throwsA(isA<ValidationException>()),
      );
    });

    test('throws ValidationException for invalid data type', () async {
      final content = {'name': 123};
      expect(
        () => service.validate(MemoryDomain.identity, content),
        throwsA(isA<ValidationException>()),
      );
    });

    test('throws FileSystemException for missing schema', () async {
      expect(
        () => service.validate(MemoryDomain.biography, {}),
        throwsA(isA<FileSystemException>()),
      );
    });
  });
}
