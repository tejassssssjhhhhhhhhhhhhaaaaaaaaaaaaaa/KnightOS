import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/import_models.dart';
import '../../domain/import_provider.dart';
import '../../../../core/design_system/design_constants.dart';

class PdfDocumentProvider implements ImportProvider {
  @override
  String get id => 'pdf_document';

  @override
  String get displayName => 'PDF Documents';

  @override
  String get description =>
      'Import and organize PDF files, certificates, and reports.';

  @override
  IconData get icon => Icons.picture_as_pdf_rounded;

  @override
  Color get accentColor => DesignColors.health;

  @override
  bool canHandle(File file) => file.path.endsWith('.pdf');

  @override
  Future<ImportResult> parse(File file, {required String jobId}) async {
    return const ImportResult(
      success: true,
      message: 'Document ingested (Placeholder)',
    );
  }
}
