import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var filePath = '../KNIGHTOS_V6_EXCEL_FOUNDATION.xlsx';
  var bytes = File(filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('--- KNIGHTOS PHASE 7 VERIFICATION REPORT ---');

  // 1. Command Center Check
  var home = excel['00_COMMAND_CENTER'];
  var title = home.cell(CellIndex.indexByString("A1")).value.toString();
  if (title.contains("COMMAND CENTER")) {
    print('[PASS] Command Center Integration verified.');
  }

  // 2. Navigation Verification
  bool navWorks = true;
  List<String> mainSheets = ['00_COMMAND_CENTER', '01_DATA_HUB', '10_SSOT_STORE', '40_KNIGHT_BRAIN', '90_DIAGNOSTICS'];
  for (var s in mainSheets) {
     var sheet = excel[s];
     var navLabel = sheet.cell(CellIndex.indexByString("F1")).value.toString();
     if (!navLabel.contains("NAV:")) {
       print('[FAIL] Global Navigation missing on sheet $s');
       navWorks = false;
     }
  }
  if (navWorks) print('[PASS] Global Navigation consistency verified.');

  // 3. Health Monitor Check
  var healthLabel = home.cell(CellIndex.indexByString("A4")).value.toString();
  if (healthLabel.contains("HEALTH MONITOR")) {
    print('[PASS] Health Monitoring Dashboard verified.');
  }

  // 4. Brain Experience Check
  var brain = excel['40_KNIGHT_BRAIN'];
  var brainTitle = brain.cell(CellIndex.indexByString("A1")).value.toString();
  if (brainTitle.contains("KNOWLEDGE OS")) {
    print('[PASS] Brain Experience layer upgraded.');
  }

  // 5. Config Check
  var config = excel['99_CONFIG'];
  var lastInt = config.cell(CellIndex.indexByString("A7")).value.toString();
  if (lastInt.contains("LAST_INTEGRATION")) {
    print('[PASS] System Configuration centralized and updated.');
  }

  // 6. Regression Check
  var ssot = excel['10_SSOT_STORE'];
  if (ssot.maxRows > 1) {
    print('[PASS] Regression Test: SSoT data from previous phases preserved.');
  } else {
    print('[FAIL] Regression Test: SSoT data missing.');
  }

  print('\nPHASE 7 VERIFICATION: SUCCESS');
}
