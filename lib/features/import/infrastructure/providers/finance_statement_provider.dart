import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/import_models.dart';
import '../../domain/import_provider.dart';
import '../../../../core/design_system/design_constants.dart';

class FinanceStatementProvider implements ImportProvider {
  @override
  String get id => 'finance_statement';

  @override
  String get displayName => 'Bank Statements';

  @override
  String get description =>
      'Extract transactions from CSV or PDF bank and credit card statements.';

  @override
  IconData get icon => Icons.account_balance_rounded;

  @override
  Color get accentColor => DesignColors.finance;

  @override
  bool canHandle(File file) =>
      file.path.endsWith('.csv') || file.path.endsWith('.pdf');

  @override
  Future<ImportResult> parse(File file, {required String jobId}) async {
    return const ImportResult(
      success: true,
      message: 'Transactions extracted (Placeholder)',
    );
  }
}
