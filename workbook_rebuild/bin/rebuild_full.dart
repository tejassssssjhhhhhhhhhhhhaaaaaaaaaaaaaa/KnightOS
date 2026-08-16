import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:crypto/crypto.dart';

void main() {
  print('[REBUILD] Starting complete workbook reconstruction...');
  var excel = Excel.createExcel();

  // Define Design Colors (Dark Theme)
  const String colorBg = "#1A1A1A"; // Graphite
  const String colorHeader = "#2D2D2D"; // Dark Steel
  const String colorText = "#FFFFFF"; // White
  const String colorAccent = "#0078D4"; // Blue
  const String colorGreen = "#00FF00";
  const String colorAmber = "#FFBF00";
  const String colorRed = "#FF0000";

  // 0. Cleanup default sheet
  if (excel.tables.containsKey('Sheet1')) excel.delete('Sheet1');

  // 1. CONFIGURATION (Foundation)
  _buildConfig(excel);

  // 2. COMMAND CENTER (Dashboard)
  _buildCommandCenter(excel, colorBg, colorHeader, colorText, colorAccent);

  // 3. DATA HUB (Engine)
  _buildDataHub(excel, colorBg, colorHeader, colorText);

  // 4. DATA LAYERS (Tables)
  _buildDataLayers(excel);

  // 5. BRAIN & INTELLIGENCE
  _buildBrain(excel, colorBg, colorHeader, colorText);

  // 6. LOGS & DIAGNOSTICS
  _buildUtilitySheets(excel);

  // 7. DEMO DATA (Proof of Concept)
  _injectDemoData(excel);

  // 8. NAVIGATION (Final Polish)
  _applyGlobalNavigation(excel);

  // Save
  var fileBytes = excel.save();
  if (fileBytes != null) {
    File('../KNIGHTOS_V6_EXCEL_EDITION_FINAL_REBUILT.xlsx').writeAsBytesSync(fileBytes);
    print('[SUCCESS] KNIGHTOS v6.0 REBUILT successfully.');
  }
}

void _buildConfig(Excel excel) {
  var s = excel['99_CONFIG'];
  _setHeader(s, ["PARAMETER", "VALUE", "DESCRIPTION"]);
  _writeData(s, 1, ["VERSION", "6.0.0-REBUILT", "Current OS version"]);
  _writeData(s, 2, ["STATUS", "RELEASE_CANDIDATE", "System deployment state"]);
  _writeData(s, 3, ["DESIGN", "FUTURISTIC_DARK", "Active theme"]);
}

void _buildCommandCenter(Excel excel, String bg, String header, String text, String accent) {
  var s = excel['00_COMMAND_CENTER'];
  
  // Title
  _setStyled(s, "A1", "KNIGHTOS v6.0 — COMMAND CENTER", bold: true, fontSize: 24, fontColor: text, bgColor: bg);
  
  // Health Monitor Card
  _setStyled(s, "A3", "SYSTEM HEALTH MONITOR", bold: true, fontSize: 14, bgColor: header);
  _writeData(s, 3, ["SYSTEM:", ""], colOffset: 0);
  s.cell(CellIndex.indexByString("B4")).setFormula("IF(COUNTIF('90_DIAGNOSTICS'!C:C,\"CRITICAL\")>0,\"🔴 CRITICAL\", \"🟢 HEALTHY\")");
  
  _writeData(s, 4, ["DATA HUB:", ""], colOffset: 0);
  s.cell(CellIndex.indexByString("B5")).setFormula("IF(COUNTIF('01_DATA_HUB'!E6:E11,\"● RED\")>0,\"🔴 ERROR\",\"🟢 OPTIMAL\")");

  _writeData(s, 5, ["BRAIN:", ""], colOffset: 0);
  s.cell(CellIndex.indexByString("B6")).setFormula("'43_BRAIN_HEALTH'!B6");

  // Summary Metrics Card
  _setStyled(s, "D3", "DATA SUMMARY", bold: true, fontSize: 14, bgColor: header);
  _writeData(s, 3, ["TOTAL RECORDS:", ""], colOffset: 3);
  s.cell(CellIndex.indexByString("E4")).setFormula("COUNTA('10_SSOT_STORE'!A:A)-1");
  
  _writeData(s, 4, ["NEEDS REVIEW:", ""], colOffset: 3);
  s.cell(CellIndex.indexByString("E5")).setFormula("COUNTIF('10_SSOT_STORE'!F:F, \"NEEDS_REVIEW\")");

  // Quick Actions Card
  _setStyled(s, "G3", "QUICK ACTIONS", bold: true, fontSize: 14, bgColor: header);
  _setNav(s, "G4", "⚡ SYNC DATA HUB", "01_DATA_HUB");
  _setNav(s, "G5", "🧠 EXPLORE BRAIN", "40_KNIGHT_BRAIN");
  _setNav(s, "G6", "⚙️ DIAGNOSTICS", "90_DIAGNOSTICS");
}

void _buildDataHub(Excel excel, String bg, String header, String text) {
  var s = excel['01_DATA_HUB'];
  _setStyled(s, "A1", "KNIGHT DATA CORE — ENGINE ROOM", bold: true, fontSize: 18, fontColor: text, bgColor: bg);
  
  // Source Health
  _setStyled(s, "A4", "SOURCE HEALTH", bold: true, fontSize: 12, bgColor: header);
  _setHeader(s, ["SOURCE", "STATUS", "LAST_SYNC", "LATENCY", "HEALTH"], row: 4);
  
  List<String> sources = ["GMAIL", "CALENDAR", "DRIVE", "CONTACTS", "TASKS", "LOCAL"];
  for (var i = 0; i < sources.length; i++) {
    _writeData(s, 5 + i, [sources[i], "NOT_CONFIGURED", "---", "---", "● GREY"]);
  }

  // Pipeline
  _setStyled(s, "A13", "PIPELINE STAGES", bold: true, fontSize: 12, bgColor: header);
  _setHeader(s, ["STAGE", "COUNT", "STATUS", "LAST_UPDATE", "ERRORS"], row: 13);
  List<String> stages = ["RECEIVED", "CHECKED", "NORMALIZED", "DEDUPLICATED", "CATEGORIZED", "SSOT", "AVAILABLE"];
  for (var i = 0; i < stages.length; i++) {
     _writeData(s, 14 + i, [stages[i], "0", "IDLE", "---", "0"]);
  }
}

void _buildDataLayers(Excel excel) {
  _setHeader(excel['20_RAW_INTAKE'], ["RECORD_ID", "SOURCE", "SOURCE_ID", "IMPORT_TIMESTAMP", "SESSION_ID", "RAW_PAYLOAD", "ORIGIN_HASH", "STATUS"]);
  _setHeader(excel['30_NORMALIZED_DATA'], ["RECORD_ID", "SOURCE", "DATE", "TITLE", "SUMMARY", "CATEGORY", "IMPORTANCE", "CONFIDENCE", "KNIGHT_HASH", "STATUS", "PROVENANCE_ID"]);
  _setHeader(excel['10_SSOT_STORE'], ["KNIGHT_ID", "DATE", "TYPE", "TITLE", "CONTENT", "CATEGORY", "IMPORTANCE", "CONFIDENCE", "PROVENANCE_ID"]);
  _setHeader(excel['PROVENANCE'], ["PROVENANCE_ID", "SOURCE", "RAW_REF", "NORM_REF", "SSOT_REF", "SESSION_ID", "METHOD", "TIMESTAMP"]);
}

void _buildBrain(Excel excel, String bg, String header, String text) {
  var s = excel['40_KNIGHT_BRAIN'];
  _setStyled(s, "A1", "MY KNIGHT BRAIN — KNOWLEDGE OS", bold: true, fontSize: 18, fontColor: text, bgColor: bg);
  
  _setStyled(s, "A3", "BRAIN HEALTH", bold: true, fontSize: 12, bgColor: header);
  _setHeader(excel['43_BRAIN_HEALTH'], ["METRIC", "VALUE", "STATUS", "LAST_CALCULATED"]);
  _writeData(excel['43_BRAIN_HEALTH'], 5, ["BRAIN_HEALTH_SCORE", "100%", "OPTIMAL", "NOW()"]);

  _setHeader(excel['41_BRAIN_ENTITIES'], ["ENTITY_ID", "NAME", "TYPE", "DOMAIN", "CONFIDENCE"]);
  _setHeader(excel['42_BRAIN_RELATIONSHIPS'], ["ENTITY_A", "RELATIONSHIP", "ENTITY_B", "CONFIDENCE", "SOURCE"]);
  _setHeader(excel['44_KNOWLEDGE_GAPS'], ["GAP_ID", "DOMAIN", "SUBJECT", "REASON", "PRIORITY"]);
}

void _buildUtilitySheets(Excel excel) {
  _setHeader(excel['90_DIAGNOSTICS'], ["TIMESTAMP", "SUBSYSTEM", "LEVEL", "MESSAGE", "TECHNICAL_DETAIL", "RESOLVED"]);
  _setHeader(excel['SYNC_LOG'], ["SESSION_ID", "START_TIME", "END_TIME", "SOURCE", "DISCOVERED", "IMPORTED", "STATUS"]);
  _setHeader(excel['AI_CHAT_LOG'], ["CHAT_ID", "TIMESTAMP", "SENDER", "TEXT", "INTENT", "EVIDENCE_ID"]);
  _setHeader(excel['AI_USAGE_LOG'], ["REQUEST_ID", "TIMESTAMP", "INTENT", "STATUS", "TOKENS"]);
  _setHeader(excel['RECOVERY_LOG'], ["RECOVERY_ID", "TIMESTAMP", "SOURCE", "ACTION", "RESULT"]);
}

void _injectDemoData(Excel excel) {
  // Inject one record through the pipeline to demonstrate connectivity
  String date = \"2026-08-16\";
  String hash = \"DEMO_HASH_001\";
  
  _writeData(excel['10_SSOT_STORE'], 1, [\"KNIGHT_001\", date, \"GMAIL\", \"Demo Payment\", \"Gym membership paid\", \"FINANCE\", \"IMPORTANT\", \"1.0\", \"PROV_001\"]);
  _writeData(excel['40_KNIGHT_BRAIN'], 1, [\"MEM_001\", \"Gym Payment\", \"FACT\", \"Monthly subscription verified\", \"CONFIRMED\", \"1.0\", \"Rule matched\", \"FRESH\", \"NONE\", date, date, \"PROV_001\"]);
  _writeData(excel['90_DIAGNOSTICS'], 1, [DateTime.now().toIso8601String(), \"SYSTEM\", \"INFO\", \"System initialized successfully.\", \"Clean install\", \"YES\"]);
}

void _applyGlobalNavigation(Excel excel) {
  List<String> screens = ['00_COMMAND_CENTER', '01_DATA_HUB', '10_SSOT_STORE', '40_KNIGHT_BRAIN', '90_DIAGNOSTICS'];
  for (var name in screens) {
    var s = excel[name];
    _setStyled(s, "F1", "NAV:", bold: true);
    _setNav(s, "G1", "[ HOME ]", "00_COMMAND_CENTER");
    _setNav(s, "H1", "[ HUB ]", "01_DATA_HUB");
    _setNav(s, "I1", "[ BRAIN ]", "40_KNIGHT_BRAIN");
    _setNav(s, "J1", "[ SSoT ]", "10_SSOT_STORE");
  }
}

// Helpers
void _setHeader(Sheet sheet, List<String> headers, {int row = 0}) {
  for (int i = 0; i < headers.length; i++) {
    var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: row));
    cell.value = TextCellValue(headers[i]);
    cell.cellStyle = CellStyle(bold: true, backgroundColorHex: ExcelColor.fromHexString(\"#D3D3D3\"));
  }
}

void _writeData(Sheet sheet, int rowIdx, List<dynamic> data, {int colOffset = 0}) {
  for (int i = 0; i < data.length; i++) {
    var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i + colOffset, rowIndex: rowIdx));
    var val = data[i];
    if (val is int) cell.value = IntCellValue(val);
    else if (val is double) cell.value = DoubleCellValue(val);
    else cell.value = TextCellValue(val.toString());
  }
}

void _setStyled(Sheet sheet, String ref, String val, {bool bold = false, double? fontSize, String? fontColor, String? bgColor}) {
  var cell = sheet.cell(CellIndex.indexByString(ref));
  cell.value = TextCellValue(val);
  cell.cellStyle = CellStyle(
    bold: bold, fontSize: fontSize?.toInt(),
    fontColorHex: fontColor != null ? ExcelColor.fromHexString(fontColor) : ExcelColor.none,
    backgroundColorHex: bgColor != null ? ExcelColor.fromHexString(bgColor) : ExcelColor.none,
  );
}

void _setNav(Sheet sheet, String ref, String label, String target) {
  sheet.cell(CellIndex.indexByString(ref)).setFormula('HYPERLINK(\"#\'$target\'!A1\", \"$label\")');
}
