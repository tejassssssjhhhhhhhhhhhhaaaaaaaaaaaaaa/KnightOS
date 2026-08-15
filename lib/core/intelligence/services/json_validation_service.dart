import 'dart:convert';
import 'package:flutter/services.dart';
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

  final String schemaDirectory;
  final Map<int, JsonSchema> _schemaCache = {};

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
    final assetPath = '$schemaDirectory/$fileName';

    try {
      final schemaJson = await rootBundle.loadString(assetPath);
      final schema = JsonSchema.create(jsonDecode(schemaJson));
      _schemaCache[domain.id] = schema;
      return schema;
    } catch (e) {
       // If schema asset missing, fall back to open object schema
       return JsonSchema.create({'type': 'object'}); 
    }
  }

  String _getFileName(MemoryDomain domain) {
    final index = domain.id.toString().padLeft(2, '0');
    final name = domain.name
        .replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), '_')
        .toLowerCase();
    return '${index}_$name.schema.json';
  }
}
