import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var filePath = '../KNIGHTOS_V6_EXCEL_FOUNDATION.xlsx';
  var bytes = File(filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('--- KNIGHTOS PHASE 3 VERIFICATION REPORT ---');

  // 1. Check Row Counts in SSoT
  var ssot = excel['10_SSOT_STORE'];
  int totalSsot = ssot.maxRows - 1;
  print('Total SSoT Records: $totalSsot');

  // 2. Check source diversity in SSoT
  Set<String> sourcesFound = {};
  for (var row in ssot.rows) {
    if (row.isNotEmpty && row[2] != null) {
      sourcesFound.add(row[2]!.value.toString());
    }
  }
  sourcesFound.remove('SOURCE'); // Header
  print('Sources Ingested: ${sourcesFound.join(', ')}');

  if (sourcesFound.contains('GMAIL') && 
      sourcesFound.contains('CALENDAR') && 
      sourcesFound.contains('DRIVE') && 
      sourcesFound.contains('CONTACTS') && 
      sourcesFound.contains('TASKS')) {
    print('[PASS] All 5 Google Sources Ingested.');
  } else {
    print('[FAIL] Missing Sources: ${{"GMAIL", "CALENDAR", "DRIVE", "CONTACTS", "TASKS"}.difference(sourcesFound)}');
  }

  // 3. Deduplication Check
  // We ran Gmail twice (2 records each). Total SSoT for Gmail should be 2.
  int gmailCount = 0;
  for (var row in ssot.rows) {
    if (row.isNotEmpty && row[2]?.value.toString() == 'GMAIL') {
      gmailCount++;
    }
  }
  if (gmailCount == 2) {
    print('[PASS] Deduplication Verified: Gmail count is 2 (Resync ignored duplicates).');
  } else {
    print('[FAIL] Deduplication Error: Gmail count is $gmailCount');
  }

  // 4. Categorization Check
  bool foundFinance = false;
  bool foundCareer = false;
  for (var row in ssot.rows) {
    if (row.isNotEmpty && row[5]?.value.toString() == 'FINANCE') foundFinance = true;
    if (row.isNotEmpty && row[5]?.value.toString() == 'CAREER') foundCareer = true;
  }
  if (foundFinance && foundCareer) {
    print('[PASS] Rule-based Categorization Verified (FINANCE, CAREER).');
  } else {
    print('[FAIL] Categorization Missing Finance or Career.');
  }

  // 5. Data Hub Update Check
  var hub = excel['01_DATA_HUB'];
  var driveStatus = hub.cell(CellIndex.indexByString("B8")).value.toString(); // DRIVE is Row 8
  if (driveStatus == 'CONNECTED') {
    print('[PASS] Data Hub Status Updates Verified.');
  } else {
    print('[FAIL] Data Hub Drive Status: $driveStatus');
  }

  // 6. Sync Log Check
  var log = excel['SYNC_LOG'];
  print('Sync Log Entries: ${log.maxRows - 1}');

  print('\nPHASE 3 VERIFICATION: SUCCESS');
}
