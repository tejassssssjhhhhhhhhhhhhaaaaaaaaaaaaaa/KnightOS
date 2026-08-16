import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var path = '../KNIGHTOS_V6_EXCEL_EDITION_FINAL.xlsx';
  if (!File(path).existsSync()) {
    print('Error: $path not found.');
    return;
  }
  
  var bytes = File(path).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('--- WORKBOOK FORENSIC AUDIT (OLD FILE) ---');
  print('Total Sheets: ${excel.tables.length}');
  
  int totalCells = 0;
  int totalFormulas = 0;

  excel.tables.forEach((name, table) {
    int sheetCells = 0;
    int sheetFormulas = 0;
    
    for (var row in table.rows) {
      for (var cell in row) {
        if (cell != null && cell.value != null) {
          sheetCells++;
        }
      }
    }
    
    print('Sheet: $name | Max Rows: ${table.maxRows} | Max Cols: ${table.maxCols} | Non-empty Cells: $sheetCells');
    totalCells += sheetCells;
  });

  print('Total Non-empty Cells: $totalCells');
  print('Total Workbook Size: ${File(path).lengthSync()} bytes');
}
