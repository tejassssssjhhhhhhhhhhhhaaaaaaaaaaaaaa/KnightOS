import 'dart:io';
import 'package:flutter/material.dart';
import 'import_models.dart';

/// Contract for every data source plugin in KnightOS.
abstract class ImportProvider {
  /// Unique identifier for the provider (e.g. 'google_timeline').
  String get id;

  /// User-friendly name.
  String get displayName;

  /// Icon representing the source.
  IconData get icon;

  /// Description of what this provider imports.
  String get description;

  /// Primary color associated with this source.
  Color get accentColor;

  /// Returns true if this provider can handle the given file.
  bool canHandle(File file);

  /// Parses the file and returns structured canonical data.
  /// Implementations should use isolates for large files.
  Future<ImportResult> parse(File file, {required String jobId});
}
