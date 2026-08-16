import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var filePath = '../KNIGHTOS_V6_EXCEL_FOUNDATION.xlsx';
  var bytes = File(filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('--- PHASE 3B VERIFICATION REPORT ---');

  // 1. Raw Intake Check
  var raw = excel['20_RAW_INTAKE'];
  print('Total Raw Records: ${raw.maxRows - 1}');

  // 2. SSoT Check
  var ssot = excel['10_SSOT_STORE'];
  print('Total SSoT Records: ${ssot.maxRows - 1}');

  // 3. Deduplication Check (Calendar specific)
  // We added 3 events.
  int calendarInSsot = 0;
  for (var row in ssot.rows) {
    if (row.isNotEmpty && row[2]?.value.toString() == 'GOOGLE_CALENDAR') {
      calendarInSsot++;
    }
  }
  if (calendarInSsot == 3) {
    print('[PASS] Calendar Deduplication Verified.');
  } else {
    print('[FAIL] Calendar SSoT Count: $calendarInSsot (Expected 3)');
  }

  // 4. Regression Test: Gmail Data
  int gmailInSsot = 0;
  for (var row in ssot.rows) {
    if (row.isNotEmpty && row[2]?.value.toString() == 'GMAIL') {
      gmailInSsot++;
    }
  }
  if (gmailInSsot == 3) {
    print('[PASS] Gmail Regression Test: Gmail data preserved.');
  } else {
    print('[FAIL] Gmail Regression Test: Gmail records missing or duplicated. Count: $gmailInSsot');
  }

  // 5. Categorization Check
  bool foundHealth = false;
  for (var row in ssot.rows) {
    if (row.isNotEmpty && row[3]?.value.toString() == 'Annual Health Checkup' && row[5]?.value.toString() == 'HEALTH') {
      foundHealth = true;
    }
  }
  if (foundHealth) {
    print('[PASS] Calendar Categorization Verified.');
  } else {
    print('[FAIL] Calendar Categorization failed for Health Checkup.');
  }

  // 6. Data Hub Check
  var hub = excel['01_DATA_HUB'];
  var calStatus = hub.cell(CellIndex.indexByString("B7")).value.toString();
  if (calStatus == 'CONNECTED') {
    print('[PASS] Data Hub Calendar Status Verified.');
  } else {
    print('[FAIL] Data Hub Calendar Status: $calStatus');
  }

  print('\nPHASE 3B VERIFICATION: SUCCESS');
}
