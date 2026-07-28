import 'dart:convert';
import 'package:drift/drift.dart';

/// Converts a List of Strings to a single JSON string for SQLite storage.
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    return List<String>.from(jsonDecode(fromDb) as List);
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}
