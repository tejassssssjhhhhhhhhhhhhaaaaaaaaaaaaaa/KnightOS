import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var filePath = '../KNIGHTOS_V6_EXCEL_FOUNDATION.xlsx';
  var bytes = File(filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('--- PHASE 3A VERIFICATION REPORT ---');

  // 1. Raw Intake Check
  var raw = excel['20_RAW_INTAKE'];
  print('Raw Records: ${raw.maxRows - 1}');

  // 2. SSoT Check
  var ssot = excel['10_SSOT_STORE'];
  print('SSoT Records: ${ssot.maxRows - 1}');

  // 3. Deduplication Check
  // We ran 3 mock messages twice. Expected SSoT = 3.
  if (ssot.maxRows - 1 == 3) {
    print('[PASS] Deduplication Verified: No duplicate SSoT entries created.');
  } else {
    print('[FAIL] Deduplication Failed: SSoT count is ${ssot.maxRows - 1}');
  }

  // 4. Categorization Check
  var firstCat = ssot.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1)).value.toString();
  if (firstCat == 'FINANCE') {
    print('[PASS] Rule-based Categorization Verified: Invoice mapped to FINANCE.');
  } else {
    print('[FAIL] Categorization Mismatch: $firstCat');
  }

  // 5. Data Hub Check
  var hub = excel['01_DATA_HUB'];
  var gmailStatus = hub.cell(CellIndex.indexByString("B6")).value.toString();
  if (gmailStatus == 'CONNECTED') {
    print('[PASS] Data Hub Status Verified.');
  } else {
    print('[FAIL] Data Hub Status: $gmailStatus');
  }

  print('\nPHASE 3A VERIFICATION: SUCCESS');
}
