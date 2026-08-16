import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var filePath = '../KNIGHTOS_V6_EXCEL_FOUNDATION.xlsx';
  if (!File(filePath).existsSync()) {
    print('FAIL: Workbook not found.');
    exit(1);
  }

  var bytes = File(filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  List<String> requiredSheets = [
    '00_COMMAND_CENTER',
    '01_DATA_HUB',
    '10_SSOT_STORE',
    '20_RAW_INTAKE',
    '30_NORMALIZED_DATA',
    '40_KNIGHT_BRAIN',
    '90_DIAGNOSTICS',
    '99_CONFIG',
    'SYNC_LOG',
    'PROVENANCE'
  ];

  print('--- PHASE 1 TEST REPORT ---');
  bool allSheetsExist = true;
  for (var name in requiredSheets) {
    if (excel.tables.containsKey(name)) {
      print('[PASS] Sheet: $name');
    } else {
      print('[FAIL] Sheet: $name');
      allSheetsExist = false;
    }
  }

  // Check specific columns in Normalized Data
  var normSheet = excel['30_NORMALIZED_DATA'];
  var headers = [
    normSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value.toString(),
    normSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value.toString()
  ];
  if (headers.contains('KNIGHT_HASH') && headers.contains('RAW_ID')) {
    print('[PASS] Normalized Data Structure Verified.');
  } else {
    print('[FAIL] Normalized Data Structure Mismatch: $headers');
  }

  if (allSheetsExist) {
    print('PHASE 1 VERIFICATION: SUCCESS');
  } else {
    print('PHASE 1 VERIFICATION: FAILED');
    exit(1);
  }
}
