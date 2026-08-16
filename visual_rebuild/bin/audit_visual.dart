import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var path = '../KNIGHTOS_V6_EXCEL_EDITION_VISUAL_FINAL.xlsx';
  var bytes = File(path).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('--- FINAL VISUAL AUDIT ---');
  print('File: $path');
  print('Total Sheets: ${excel.tables.length}');

  var home = excel['00_COMMAND_CENTER'];
  int styled = 0;
  for (var row in home.rows) {
    for (var cell in row) {
      if (cell != null && cell.cellStyle != null && cell.cellStyle!.backgroundColorHex != null) {
        styled++;
      }
    }
  }
  print('Styled Cells on Home: $styled');
  
  if (styled > 100) {
    print('[PASS] Visual Transformation verified (extensive styling detected).');
  } else {
    print('[FAIL] Visual Transformation failed (minimal styling detected).');
  }

  print('Total Size: ${File(path).lengthSync()} bytes');
}
