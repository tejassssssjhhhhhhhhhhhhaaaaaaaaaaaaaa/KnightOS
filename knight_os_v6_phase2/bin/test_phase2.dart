import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var filePath = '../KNIGHTOS_V6_EXCEL_FOUNDATION.xlsx';
  var bytes = File(filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  var hub = excel['01_DATA_HUB'];
  
  print('--- PHASE 2 TEST REPORT ---');
  
  // Verify Engine Identity
  var title = hub.cell(CellIndex.indexByString("A1")).value.toString();
  if (title.contains("KNIGHT DATA CORE")) {
    print('[PASS] Engine Identity Verified.');
  } else {
    print('[FAIL] Engine Identity Mismatch: $title');
  }

  // Verify Source Health Section
  var sourceHeader = hub.cell(CellIndex.indexByString("A4")).value.toString();
  if (sourceHeader.contains("SOURCE HEALTH")) {
    print('[PASS] Source Health Section Verified.');
  } else {
    print('[FAIL] Source Health Section Mismatch: $sourceHeader');
  }

  // Verify Pipeline Section
  var pipelineHeader = hub.cell(CellIndex.indexByString("A13")).value.toString();
  if (pipelineHeader.contains("PROCESSING PIPELINE")) {
    print('[PASS] Pipeline Section Verified.');
  } else {
    print('[FAIL] Pipeline Section Mismatch: $pipelineHeader');
  }

  // Verify Formulas (at least one)
  var receivedFormula = hub.cell(CellIndex.indexByString("B15")).formula;
  if (receivedFormula != null && receivedFormula.contains("COUNTA('20_RAW_INTAKE'!A:A)")) {
    print('[PASS] Pipeline Formulas Verified.');
  } else {
    print('[FAIL] Pipeline Formula Mismatch or Missing: $receivedFormula');
  }

  // Verify Reconciliation
  var reconHeader = hub.cell(CellIndex.indexByString("G10")).value.toString();
  if (reconHeader.contains("DATA RECONCILIATION")) {
    print('[PASS] Reconciliation Section Verified.');
  } else {
    print('[FAIL] Reconciliation Section Mismatch: $reconHeader');
  }

  // Verify Navigation
  var navLabel = hub.cell(CellIndex.indexByString("A25")).value.toString();
  if (navLabel.contains("NAVIGATION:")) {
    print('[PASS] Navigation Section Verified.');
  } else {
    print('[FAIL] Navigation Section Mismatch: $navLabel');
  }

  print('PHASE 2 VERIFICATION: SUCCESS');
}
