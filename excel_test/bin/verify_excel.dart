import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var file = '../KNIGHTOS_EXCEL_CAPABILITY_TEST.xlsx';
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  print('Workbook sheets: ${excel.tables.keys.join(', ')}');
  
  var homeSheet = excel['TEST_HOME'];
  print('Sheet 1 A1: ${homeSheet.cell(CellIndex.indexByString(\"A1\")).value}');
  
  var dataSheet = excel['TEST_DATA'];
  print('Sheet 2 A2 (ID 1): ${dataSheet.cell(CellIndex.indexByString(\"A2\")).value}');
  print('Sheet 2 B2 (Name): ${dataSheet.cell(CellIndex.indexByString(\"B2\")).value}');
  
  // Modification test
  homeSheet.cell(CellIndex.indexByString(\"A10\")).value = TextCellValue(\"Verification Success at ${DateTime.now()}\");
  var updatedBytes = excel.save();
  if (updatedBytes != null) {
    File(file).writeAsBytesSync(updatedBytes);
    print('Excel file updated successfully.');
  }
}
