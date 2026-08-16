import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var path = '../KNIGHTOS_V6_EXCEL_EDITION_MASTER_FINAL.xlsx';
  var bytes = File(path).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('--- MASTER WORKBOOK AUDIT ---');
  print('Total Sheets: ${excel.tables.length}');
  
  int totalCells = 0;
  excel.tables.forEach((name, table) {
    int sheetCells = 0;
    for (var row in table.rows) {
      for (var cell in row) {
        if (cell != null && cell.value != null) sheetCells++;
      }
    }
    print('Sheet: $name | Cells: $sheetCells');
    totalCells += sheetCells;
  });

  print('Total Cells: $totalCells');
  print('File Size: ${File(path).lengthSync()} bytes');
}
