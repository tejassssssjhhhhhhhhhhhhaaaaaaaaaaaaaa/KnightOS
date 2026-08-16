import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var path = '../KNIGHTOS_V6_EXCEL_EDITION_VISUAL_FINAL.xlsx';
  var bytes = File(path).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('Workbook Sheets: ${excel.tables.keys.join(", ")}');
}
