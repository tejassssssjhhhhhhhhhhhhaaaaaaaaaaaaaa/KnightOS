import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  print('[CONSOLIDATE] Starting Master Assembly of KNIGHTOS v6.0...');
  var excel = Excel.createExcel();

  _createCommandCenter(excel);
  _createDataHub(excel);
  _createSsot(excel);
  _createIntake(excel);
  _createBrain(excel);
  _createDiagnostics(excel);
  _createLogs(excel);
  _createConfig(excel);

  if (excel.tables.containsKey('Sheet1')) excel.delete('Sheet1');

  var bytes = excel.save();
  if (bytes != null) {
    File('../KNIGHTOS_V6_EXCEL_EDITION_FINAL.xlsx').writeAsBytesSync(bytes);
    print('[SUCCESS] Consolidated Master Workbook Created.');
  }
}

void _createCommandCenter(Excel excel) {
  var s = excel['00_COMMAND_CENTER'];
  _style(s, "A1", "KNIGHTOS v6.0 — COMMAND CENTER", bold: true, fontSize: 22, fontColor: "#FFFFFF", bgColor: "#1A1A1A");
  s.cell(CellIndex.indexByString("A3")).value = TextCellValue("SYSTEM HEALTH:");
  s.cell(CellIndex.indexByString("B3")).setFormula("IF(COUNTIF('90_DIAGNOSTICS'!C:C,\"CRITICAL\")>0,\"🔴 CRITICAL\", \"🟢 HEALTHY\")");
  
  s.cell(CellIndex.indexByString("F1")).value = TextCellValue("NAV:");
  s.cell(CellIndex.indexByString("G1")).setFormula('HYPERLINK("#\'01_DATA_HUB\'!A1\", \"[HUB]\")');
  s.cell(CellIndex.indexByString("H1")).setFormula('HYPERLINK("#\'40_KNIGHT_BRAIN\'!A1\", \"[BRAIN]\")');
  
  s.cell(CellIndex.indexByString("A10")).value = TextCellValue("SYSTEM HEALTH MONITOR");
}

void _createDataHub(Excel excel) {
  var s = excel['01_DATA_HUB'];
  _style(s, "A1", "KNIGHT DATA HUB — ENGINE ROOM", bold: true, fontSize: 18, fontColor: "#FFFFFF", bgColor: "#1A1A1A");
  List<String> h = ["SOURCE", "STATUS", "LAST_SYNC", "LATENCY", "HEALTH"];
  for (var i = 0; i < h.length; i++) s.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 4)).value = TextCellValue(h[i]);
}

void _createSsot(Excel excel) {
  _table(excel, '10_SSOT_STORE', ["KNIGHT_ID", "DATE", "TYPE", "TITLE", "CONTENT", "CATEGORY", "IMPORTANCE", "CONFIDENCE", "PROVENANCE_ID"]);
  _table(excel, '30_NORMALIZED_DATA', ["KNIGHT_HASH", "RAW_ID", "SOURCE", "TYPE", "DATE", "TITLE", "CONTENT", "CATEGORY", "NORM_TIMESTAMP", "STATUS"]);
}

void _createIntake(Excel excel) {
  _table(excel, '20_RAW_INTAKE', ["RAW_ID", "SOURCE", "ORIGIN_RESOURCE_ID", "PAYLOAD_JSON", "IMPORT_TIMESTAMP", "SESSION_ID"]);
}

void _createBrain(Excel excel) {
  _table(excel, '40_KNIGHT_BRAIN', ["MEMORY_ID", "SUBJECT", "MEMORY_TYPE", "CONTENT", "STATE", "CONFIDENCE", "CONFIDENCE_REASON", "FRESHNESS", "CONFLICT_STATUS", "FIRST_OBSERVED", "LAST_OBSERVED", "PROVENANCE_ID"]);
  _table(excel, '41_BRAIN_ENTITIES', ["ENTITY_ID", "NAME", "TYPE", "DOMAIN", "CONFIDENCE"]);
  _table(excel, '43_BRAIN_HEALTH', ["METRIC", "VALUE", "STATUS", "LAST_CALCULATED"]);
  excel['43_BRAIN_HEALTH'].cell(CellIndex.indexByString("A6")).value = TextCellValue("BRAIN_HEALTH_SCORE");
  excel['43_BRAIN_HEALTH'].cell(CellIndex.indexByString("B6")).value = TextCellValue("100%");
}

void _createDiagnostics(Excel excel) {
  _table(excel, '90_DIAGNOSTICS', ["TIMESTAMP", "SUBSYSTEM", "LEVEL", "MESSAGE", "TECHNICAL_DETAIL", "RESOLVED"]);
}

void _createLogs(Excel excel) {
  _table(excel, 'SYNC_LOG', ["SESSION_ID", "START_TIME", "END_TIME", "SOURCE", "DISCOVERED", "IMPORTED", "STATUS"]);
  _table(excel, 'PROVENANCE', ["PROVENANCE_ID", "KNIGHT_ID", "SOURCE_FLOW", "TIMESTAMP"]);
  _table(excel, 'AI_CHAT_LOG', ["MESSAGE_ID", "TIMESTAMP", "SENDER", "TEXT", "INTENT", "EVIDENCE_ID"]);
  _table(excel, 'RECOVERY_LOG', ["ACTION_ID", "TIMESTAMP", "SOURCE", "ACTION", "RESULT"]);
}

void _createConfig(Excel excel) {
  var s = excel['99_CONFIG'];
  s.cell(CellIndex.indexByString("A1")).value = TextCellValue("PARAMETER");
  s.cell(CellIndex.indexByString("B1")).value = TextCellValue("VALUE");
  s.cell(CellIndex.indexByString("A2")).value = TextCellValue("VERSION");
  s.cell(CellIndex.indexByString("B2")).value = TextCellValue("6.0.0-FINAL");
}

void _table(Excel excel, String name, List<String> heads) {
  var s = excel[name];
  for (int i = 0; i < heads.length; i++) s.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(heads[i]);
}

void _style(Sheet sheet, String ref, String val, {bool bold = false, double? fontSize, String? fontColor, String? bgColor}) {
  var cell = sheet.cell(CellIndex.indexByString(ref));
  cell.value = TextCellValue(val);
  cell.cellStyle = CellStyle(
    bold: bold, fontSize: fontSize?.toInt(),
    fontColorHex: fontColor != null ? ExcelColor.fromHexString(fontColor) : ExcelColor.none,
    backgroundColorHex: bgColor != null ? ExcelColor.fromHexString(bgColor) : ExcelColor.none,
  );
}
