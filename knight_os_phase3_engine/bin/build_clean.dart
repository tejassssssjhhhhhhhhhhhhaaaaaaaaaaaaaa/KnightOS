import 'dart:io';
import 'package:excel/excel.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  var excel = Excel.createExcel();
  
  // Phase 1 Foundations
  _createSheet(excel, '00_COMMAND_CENTER', [\"A1:KNIGHTOS v6.0 — COMMAND CENTER\", \"A3:SYSTEM STATUS:\", \"B3:READY\", \"A5:TOTAL RECORDS:\", \"B5:0\"]);
  _createDataHub(excel);
  _createTable(excel, '10_SSOT_STORE', [\"KNIGHT_ID\", \"DATE\", \"TYPE\", \"TITLE\", \"CONTENT\", \"CATEGORY\", \"IMPORTANCE\", \"CONFIDENCE\", \"PROVENANCE_ID\"]);
  _createTable(excel, '20_RAW_INTAKE', [\"RAW_ID\", \"SOURCE\", \"ORIGIN_RESOURCE_ID\", \"PAYLOAD_JSON\", \"IMPORT_TIMESTAMP\", \"SESSION_ID\"]);
  _createTable(excel, '30_NORMALIZED_DATA', [\"KNIGHT_HASH\", \"RAW_ID\", \"SOURCE\", \"TYPE\", \"DATE\", \"TITLE\", \"CONTENT\", \"CATEGORY\", \"NORM_TIMESTAMP\", \"STATUS\"]);
  _createTable(excel, '40_KNIGHT_BRAIN', [\"MEMORY_ID\", \"FACT\", \"STATE\", \"CONFIDENCE\", \"PROVENANCE\", \"LAST_UPDATED\"]);
  _createTable(excel, '90_DIAGNOSTICS', [\"TIMESTAMP\", \"SUBSYSTEM\", \"LEVEL\", \"MESSAGE\", \"TECHNICAL_DETAIL\", \"RESOLVED\"]);
  _createSheet(excel, '99_CONFIG', [\"A1:PARAMETER\", \"B1:VALUE\", \"A2:VERSION\", \"B2:6.0.0\", \"A3:EDITION\", \"B3:EXCEL_DATA_OS\"]);
  _createTable(excel, 'SYNC_LOG', [\"SESSION_ID\", \"START_TIME\", \"END_TIME\", \"SOURCE\", \"DISCOVERED\", \"IMPORTED\", \"STATUS\"]);
  _createTable(excel, 'PROVENANCE', [\"PROVENANCE_ID\", \"KNIGHT_ID\", \"SOURCE_FLOW\", \"TIMESTAMP\"]);

  if (excel.tables.containsKey('Sheet1')) excel.delete('Sheet1');

  var bytes = excel.save();
  if (bytes != null) {
    File('../KNIGHTOS_V6_EXCEL_FOUNDATION.xlsx').writeAsBytesSync(bytes);
    print('Clean Foundation Built.');
  }
}

void _createSheet(Excel excel, String name, List<String> cells) {
  var sheet = excel[name];
  for (var c in cells) {
    var parts = c.split(':');
    sheet.cell(CellIndex.indexByString(parts[0])).value = TextCellValue(parts[1]);
  }
}

void _createTable(Excel excel, String name, List<String> headers) {
  var sheet = excel[name];
  for (var i = 0; i < headers.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(headers[i]);
  }
}

void _createDataHub(Excel excel) {
  var sheet = excel['01_DATA_HUB'];
  sheet.cell(CellIndex.indexByString(\"A1\")).value = TextCellValue(\"KNIGHT DATA CORE\");
  sheet.cell(CellIndex.indexByString(\"A2\")).value = TextCellValue(\"ENGINE STATUS:\");
  sheet.cell(CellIndex.indexByString(\"B2\")).value = TextCellValue(\"IDLE\");
  
  sheet.cell(CellIndex.indexByString(\"A4\")).value = TextCellValue(\"SOURCE HEALTH\");
  List<String> h = [\"SOURCE\", \"STATUS\", \"LAST_SYNC\", \"LATENCY\", \"HEALTH\"];
  for (var i = 0; i < h.length; i++) sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 4)).value = TextCellValue(h[i]);

  List<String> s = [\"GMAIL\", \"CALENDAR\", \"DRIVE\", \"CONTACTS\", \"TASKS\"];
  for (var i = 0; i < s.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 5+i)).value = TextCellValue(s[i]);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 5+i)).value = TextCellValue(\"NOT CONFIGURED\");
  }
}
