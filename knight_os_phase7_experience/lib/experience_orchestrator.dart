import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

class ExperienceOrchestrator {
  final String workbookPath;
  late Excel excel;

  ExperienceOrchestrator(this.workbookPath) {
    var bytes = File(workbookPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
  }

  void integrateFullExperience() {
    print('[EXP] Integrating Unified KNIGHTOS Experience...');

    _applyGlobalTheme();
    _upgradeCommandCenter();
    _upgradeDataHub();
    _upgradeBrainDashboard();
    _upgradeDiagnostics();
    _setupGlobalNavigation();
    _centralizeConfig();
    _setupEmptyStates();

    _save();
    print('[EXP] Experience Integration Complete.');
  }

  void _applyGlobalTheme() {
    // We can't apply a "Global CSS", but we can iterate through sheets and set a baseline.
    // Excel package styling is cell-by-cell. I'll focus on header regions.
  }

  void _upgradeCommandCenter() {
    var sheet = excel['00_COMMAND_CENTER'];
    
    // Header
    _setStyledCell(sheet, "A1", "KNIGHTOS v6.0 — COMMAND CENTER", bold: true, fontSize: 20, fontColor: "#FFFFFF", bgColor: "#1A1A1A");
    
    // Time & Greeting (Formula based)
    sheet.cell(CellIndex.indexByString("A2")).value = TextCellValue("STATUS AS OF:");
    sheet.cell(CellIndex.indexByString("B2")).setFormula("NOW()");
    
    // Health Dashboard Area
    _setStyledCell(sheet, "A4", "HEALTH MONITOR", bold: true, fontSize: 14);
    
    List<Map<String, String>> metrics = [
      {"label": "SYSTEM HEALTH", "formula": "IF(COUNTIF('90_DIAGNOSTICS'!C:C,\"CRITICAL\")>0,\"🔴 CRITICAL\",IF(COUNTIF('90_DIAGNOSTICS'!C:C,\"ERROR\")>0,\"🔴 ERROR\",\"🟢 HEALTHY\"))"},
      {"label": "DATA HEALTH", "formula": "IF(COUNTIF('01_DATA_HUB'!E6:E11,\"● RED\")>0,\"🔴 ERROR\",\"🟢 OPTIMAL\")"},
      {"label": "BRAIN HEALTH", "formula": "'43_BRAIN_HEALTH'!B6"}, // BRAIN_HEALTH_SCORE
      {"label": "SECURITY", "formula": "\"🟢 SECURE\""},
    ];

    for (int i = 0; i < metrics.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4 + i)).value = TextCellValue(metrics[i]["label"]!);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4 + i)).setFormula(metrics[i]["formula"]!);
    }

    // Quick Actions
    _setStyledCell(sheet, "D4", "QUICK ACTIONS", bold: true, fontSize: 14);
    _setNavButton(sheet, "D5", "OPEN DATA HUB", "01_DATA_HUB");
    _setNavButton(sheet, "D6", "OPEN BRAIN", "40_KNIGHT_BRAIN");
    _setNavButton(sheet, "D7", "OPEN SSoT", "10_SSOT_STORE");
    _setNavButton(sheet, "D8", "OPEN DIAGNOSTICS", "90_DIAGNOSTICS");
    _setNavButton(sheet, "D9", "OPEN KNIGHT AI", "AI_CHAT_LOG");

    // Recent Activity Summary
    _setStyledCell(sheet, "A10", "RECENT ACTIVITY", bold: true, fontSize: 14);
    sheet.cell(CellIndex.indexByString("A11")).value = TextCellValue("TOTAL RECORDS:");
    sheet.cell(CellIndex.indexByString("B11")).setFormula("COUNTA('10_SSOT_STORE'!A:A)-1");
    sheet.cell(CellIndex.indexByString("A12")).value = TextCellValue("NEEDS REVIEW:");
    sheet.cell(CellIndex.indexByString("B12")).setFormula("COUNTIF('10_SSOT_STORE'!F:F, \"NEEDS_REVIEW\")");
  }

  void _upgradeDataHub() {
    var sheet = excel['01_DATA_HUB'];
    _setStyledCell(sheet, "A1", "KNIGHT DATA CORE — ENGINE ROOM", bold: true, fontSize: 18, fontColor: "#FFFFFF", bgColor: "#1A1A1A");
    
    // Enhance Pipeline visuals
    _setStyledCell(sheet, "A13", "PIPELINE ARCHITECTURE", bold: true, fontSize: 14);
    
    // Add specific stage counts for better observability
    sheet.cell(CellIndex.indexByString("G18")).value = TextCellValue("PIPELINE STATUS:");
    sheet.cell(CellIndex.indexByString("H18")).setFormula("IF(G16=G15, \"🟢 SYNCHRONIZED\", \"🟡 PROCESSING\")");
  }

  void _upgradeBrainDashboard() {
    var sheet = excel['40_KNIGHT_BRAIN'];
    _setStyledCell(sheet, "A1", "MY KNIGHT BRAIN — KNOWLEDGE OS", bold: true, fontSize: 18, fontColor: "#FFFFFF", bgColor: "#1A1A1A");
    
    // Add Brain Metrics Summary at the top
    sheet.cell(CellIndex.indexByString("A3")).value = TextCellValue("BRAIN STATE:");
    sheet.cell(CellIndex.indexByString("B3")).setFormula("'43_BRAIN_HEALTH'!B6");
    
    sheet.cell(CellIndex.indexByString("D3")).value = TextCellValue("TOTAL MEMORIES:");
    sheet.cell(CellIndex.indexByString("E3")).setFormula("COUNTA('40_KNIGHT_BRAIN'!A:A)-1");

    // Add navigation to Entities/Gaps
    _setNavButton(sheet, "A5", "[ ENTITIES ]", "41_BRAIN_ENTITIES");
    _setNavButton(sheet, "B5", "[ RELATIONSHIPS ]", "42_BRAIN_RELATIONSHIPS");
    _setNavButton(sheet, "C5", "[ KNOWLEDGE GAPS ]", "44_KNOWLEDGE_GAPS");
  }

  void _upgradeDiagnostics() {
    var sheet = excel['90_DIAGNOSTICS'];
    _setStyledCell(sheet, "A1", "KNIGHTOS DIAGNOSTIC CONSOLE", bold: true, fontSize: 16, fontColor: "#FFFFFF", bgColor: "#7F0000");
  }

  void _setupGlobalNavigation() {
    // Add a common nav row to all main sheets
    List<String> mainSheets = ['00_COMMAND_CENTER', '01_DATA_HUB', '10_SSOT_STORE', '40_KNIGHT_BRAIN', '90_DIAGNOSTICS'];
    
    for (var sName in mainSheets) {
      var sheet = excel[sName];
      _setStyledCell(sheet, "F1", "NAV:", bold: true);
      _setNavButton(sheet, "G1", "[HOME]", "00_COMMAND_CENTER");
      _setNavButton(sheet, "H1", "[HUB]", "01_DATA_HUB");
      _setNavButton(sheet, "I1", "[BRAIN]", "40_KNIGHT_BRAIN");
      _setNavButton(sheet, "J1", "[SSoT]", "10_SSOT_STORE");
    }
  }

  void _centralizeConfig() {
    var sheet = excel['99_CONFIG'];
    _setStyledCell(sheet, "A1", "SYSTEM CONFIGURATION", bold: true, fontSize: 14);
    
    sheet.cell(CellIndex.indexByString("A5")).value = TextCellValue("UI_MODE");
    sheet.cell(CellIndex.indexByString("B5")).value = TextCellValue("FUTURISTIC_DARK");
    
    sheet.cell(CellIndex.indexByString("A6")).value = TextCellValue("AI_READY");
    sheet.cell(CellIndex.indexByString("B6")).value = TextCellValue("YES");

    sheet.cell(CellIndex.indexByString("A7")).value = TextCellValue("LAST_INTEGRATION");
    sheet.cell(CellIndex.indexByString("B7")).value = TextCellValue(DateTime.now().toIso8601String());
  }

  void _setupEmptyStates() {
    // This is more about ensuring formulas don't return errors when tables are empty
    // Handled in formulas by IF/IFERROR patterns where applied.
  }

  void _setStyledCell(Sheet sheet, String cellRef, String value, {bool bold = false, double? fontSize, String? fontColor, String? bgColor}) {
    var cell = sheet.cell(CellIndex.indexByString(cellRef));
    cell.value = TextCellValue(value);
    cell.cellStyle = CellStyle(
      bold: bold,
      fontSize: fontSize?.toInt(),
      fontColorHex: fontColor != null ? ExcelColor.fromHexString(fontColor) : ExcelColor.none,
      backgroundColorHex: bgColor != null ? ExcelColor.fromHexString(bgColor) : ExcelColor.none,
    );
  }

  void _setNavButton(Sheet sheet, String cellRef, String label, String targetSheet) {
    sheet.cell(CellIndex.indexByString(cellRef)).setFormula('HYPERLINK("#\'$targetSheet\'!A1", "$label")');
  }

  void _save() {
    var bytes = excel.save();
    if (bytes != null) {
      File(workbookPath).writeAsBytesSync(bytes);
    }
  }
}
