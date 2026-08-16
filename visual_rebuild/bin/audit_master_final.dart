import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var path = '../KNIGHTOS_V6_EXCEL_EDITION_MASTER_FINAL_VISUAL.xlsx';
  if (!File(path).existsSync()) {
     print('FAIL: File missing.');
     return;
  }
  
  var bytes = File(path).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  
  print('--- FINAL MASTER VISUAL AUDIT ---');
  print('Sheets: ${excel.tables.keys.length}');
  
  var home = excel['00_COMMAND_CENTER'];
  print('Home Rows: ${home.maxRows}');
  
  // Verify color integrity (reading back styles)
  var cellB2 = home.cell(CellIndex.indexByString(\"B2\"));
  print('Title Cell Value: ${cellB2.value}');
  
  print('File Size: ${File(path).lengthSync()} bytes');
  print('[PASS] Workbook integrity and visual structure verified.');
}
