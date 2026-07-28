import 'dart:convert';
import 'dart:io';
import 'package:json_schema/json_schema.dart';
import '../domain/memory_domain.dart';

/// Error thrown when a memory's content fails schema validation.
class ValidationException implements Exception {
  ValidationException(this.errors);
  final List<String> errors;
  @override
  String toString() => 'ValidationException: ${errors.join(", ")}';
}

/// Service for enforcing the Master Memory Specification via JSON Schemas.
class JsonValidationService {
  JsonValidationService({required this.schemaDirectory});

  /// Path to the 'knight_knowledge_base/schemas/master_memory' directory.
  final String schemaDirectory;

  final Map<int, JsonSchema> _schemaCache = {};

  /// Validates the [content] against the schema for the given [domain].
  /// Throws [ValidationException] if validation fails.
  Future<void> validate(
    MemoryDomain domain,
    Map<String, dynamic> content,
  ) async {
    final schema = await _getSchema(domain);
    final result = schema.validate(content);

    if (!result.isValid) {
      throw ValidationException(result.errors.map((e) => e.message).toList());
    }
  }

  Future<JsonSchema> _getSchema(MemoryDomain domain) async {
    if (_schemaCache.containsKey(domain.id)) {
      return _schemaCache[domain.id]!;
    }

    final fileName = _getFileName(domain);
    final file = File('$schemaDirectory/$fileName');

    if (!await file.exists()) {
      throw FileSystemException('Schema file not found', file.path);
    }

    final schemaJson = await file.readAsString();
    // In a real environment, we'd need to handle $ref resolution.
    // For Sprint 1, we assume the schemas are standalone or resolved by the library.
    final schema = JsonSchema.create(jsonDecode(schemaJson));
    _schemaCache[domain.id] = schema;
    return schema;
  }

  String _getFileName(MemoryDomain domain) {
    // Map domain IDs to the file names generated in Validation Core.
    final index = domain.id.toString().padLeft(2, '0');
    final name = domain.name
        .replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), '_')
        .toLowerCase();
    return '${index}_$name.schema.json';
  }
}
