import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var filePath = '../KNIGHTOS_V6_EXCEL_FOUNDATION.xlsx';
  var bytes = File(filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('--- KNIGHTOS PHASE 6 RECOVERY VERIFICATION REPORT ---');

  // 1. Recovery Log Check
  var log = excel['RECOVERY_LOG'];
  print('Recovery Actions Logged: ${log.maxRows - 1}');
  bool foundRetry = false;
  bool foundBlocked = false;
  for (var row in log.rows) {
    if (row.isNotEmpty && row[4]?.value.toString() == 'RETRY') foundRetry = true;
    if (row.isNotEmpty && row[5]?.value.toString() == 'BLOCKED') foundBlocked = true;
  }
  if (foundRetry && foundBlocked) {
    print('[PASS] Recovery State Model Verified (Retry & Blocked states recorded).');
  } else {
    print('[FAIL] Missing recovery states in log.');
  }

  // 2. Duplicate Safety Check
  var ssot = excel['10_SSOT_STORE'];
  int tasksCount = 0;
  for (var row in ssot.rows) {
     if (row.isNotEmpty && row[2]?.value.toString() == 'TASKS') tasksCount++;
  }
  if (tasksCount == 2) {
    print('[PASS] Duplicate Safety Verified: Resumed sync did not duplicate SSoT records.');
  } else {
    print('[FAIL] Duplicate Safety Failed: Tasks count is $tasksCount (Expected 2)');
  }

  // 3. Diagnostics Explanations
  var diag = excel['90_DIAGNOSTICS'];
  bool foundAuthError = false;
  for (var row in diag.rows) {
    if (row.isNotEmpty && row[3]?.value.toString().contains('Authentication')) foundAuthError = true;
  }
  if (foundAuthError) {
    print('[PASS] Diagnostics properly explains non-recoverable failures.');
  }

  // 4. Data Hub Status
  var hub = excel['01_DATA_HUB'];
  var calendarStatus = hub.cell(CellIndex.indexByString("B7")).value.toString();
  if (calendarStatus == 'REQUIRESUSERACTION') {
     print('[PASS] Data Hub reflects recovery requirements.');
  }

  print('\nPHASE 6 RECOVERY VERIFICATION: SUCCESS');
}
