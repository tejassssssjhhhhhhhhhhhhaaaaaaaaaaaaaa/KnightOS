import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  print('[VISUAL] Starting Final Visual OS Transformation...');
  var path = '../KNIGHTOS_V6_EXCEL_EDITION_REPAIRED.xlsx';
  var bytes = File(path).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  const String cBg = "#0A0A0A"; 
  const String cPanel = "#1A1A1A";
  const String cCard = "#262626";
  const String cAccent = "#C5A059"; 
  const String cText = "#FFFFFF";
  const String cDim = "#888888";

  _transformHome(excel, cBg, cPanel, cCard, cAccent, cText, cDim);
  _transformHub(excel, cBg, cPanel, cCard, cAccent, cText);
  _transformBrain(excel, cBg, cPanel, cAccent, cText);

  var fileBytes = excel.save();
  if (fileBytes != null) {
    File('../KNIGHTOS_V6_EXCEL_EDITION_MASTER_FINAL_VISUAL.xlsx').writeAsBytesSync(fileBytes);
    print('[SUCCESS] Visual Transformation complete.');
  }
}

void _transformHome(Excel excel, String bg, String panel, String card, String accent, String text, String dim) {
  var s = excel['00_COMMAND_CENTER'];
  _canvas(s, 40, 80, bg);

  // Layout sizing
  s.setColumnWidth(0, 4);
  for (int i = 1; i < 20; i++) s.setColumnWidth(i, 16);

  // Header Panel
  _rect(s, 0, 0, 30, 2, "#121212");
  _txt(s, "B2", " KNIGHTOS", bold: true, size: 36, color: accent);
  _txt(s, "R2", "DATA OPERATING SYSTEM v6.0", color: dim, size: 10);

  // Navigation Bar
  _rect(s, 0, 4, 30, 5, "#181818");
  _nav(s, "B5", " HOME", "00_COMMAND_CENTER", color: accent, bg: "#181818");
  _nav(s, "D5", " DATA HUB", "01_DATA_HUB", color: text, bg: "#181818");
  _nav(s, "F5", " BRAIN", "40_KNIGHT_BRAIN", color: text, bg: "#181818");
  _nav(s, "H5", " SSOT", "10_SSOT_STORE", color: text, bg: "#181818");
  _nav(s, "J5", " HEALTH", "90_DIAGNOSTICS", color: text, bg: "#181818");

  // Greeting
  _txt(s, "B8", "Good morning, Commander", size: 24, color: text);
  _txt(s, "B9", "Your systems are optimal. No critical alerts detected.", color: dim);

  // Cards
  _card(s, 1, 12, 5, 18, "SYSTEM HEALTH", "98%", "HEALTHY", card, accent, text);
  _card(s, 7, 12, 11, 18, "DATA ASSETS", "12.4k", "RECORDS", card, accent, text);
  _card(s, 13, 12, 17, 18, "BRAIN MEMORY", "847", "FACTS", card, accent, text);

  // Pulse
  _txt(s, "B22", "DATA PULSE", bold: true, size: 14, color: text);
  var sources = ["GMAIL", "CALENDAR", "DRIVE", "TASKS"];
  for (int i = 0; i < sources.length; i++) {
    _txt(s, "B${24+i}", " ●", color: "#00FF00");
    _txt(s, "C${24+i}", sources[i], color: text);
  }

  // Quick Actions
  _rect(s, 13, 22, 17, 30, card);
  _txt(s, "N23", "QUICK ACTIONS", bold: true, color: accent, bg: card);
  _nav(s, "N25", "⚡ SYNC ALL", "01_DATA_HUB", color: text, bg: card);
  _nav(s, "N26", "🧠 ANALYZE", "40_KNIGHT_BRAIN", color: text, bg: card);
}

void _transformHub(Excel excel, String bg, String panel, String card, String accent, String text) {
  var s = excel['01_DATA_HUB'];
  _canvas(s, 40, 80, bg);
  _rect(s, 0, 0, 30, 2, panel);
  _txt(s, "B2", "KNIGHT DATA HUB — ENGINE ROOM", bold: true, size: 18, color: text);
  
  _txt(s, "B5", "SOURCE HEALTH MONITOR", bold: true, color: accent);
  _txt(s, "H5", "DATA JOURNEY PIPELINE", bold: true, color: accent);
}

void _transformBrain(Excel excel, String bg, String panel, String accent, String text) {
  var s = excel['40_KNIGHT_BRAIN'];
  _canvas(s, 40, 80, bg);
  _rect(s, 0, 0, 30, 2, panel);
  _txt(s, "B2", "MY KNIGHT BRAIN — KNOWLEDGE OS", bold: true, size: 18, color: text);
}

// Visual OS Primitives
void _canvas(Sheet s, int cols, int rows, String color) {
  var style = CellStyle(backgroundColorHex: ExcelColor.fromHexString(color));
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      s.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r)).cellStyle = style;
    }
  }
}

void _rect(Sheet s, int sc, int sr, int ec, int er, String color) {
  var style = CellStyle(backgroundColorHex: ExcelColor.fromHexString(color));
  for (int r = sr; r <= er; r++) {
    for (int c = sc; c <= ec; c++) {
      s.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r)).cellStyle = style;
    }
  }
}

void _txt(Sheet s, String ref, String val, {bool bold = false, double? size, String? color, String? bg}) {
  var cell = s.cell(CellIndex.indexByString(ref));
  cell.value = TextCellValue(val);
  cell.cellStyle = CellStyle(
    bold: bold, 
    fontSize: size?.toInt(),
    fontColorHex: color != null ? ExcelColor.fromHexString(color) : ExcelColor.none,
    backgroundColorHex: bg != null ? ExcelColor.fromHexString(bg) : cell.cellStyle?.backgroundColorHex ?? ExcelColor.none,
  );
}

void _nav(Sheet s, String ref, String label, String target, {String? color, String? bg}) {
  var cell = s.cell(CellIndex.indexByString(ref));
  cell.setFormula('HYPERLINK(\"#\'$target\'!A1\", \"$label\")');
  cell.cellStyle = CellStyle(
    bold: true,
    fontColorHex: color != null ? ExcelColor.fromHexString(color) : ExcelColor.none,
    backgroundColorHex: bg != null ? ExcelColor.fromHexString(bg) : ExcelColor.none,
    underline: Underline.Single,
  );
}

void _card(Sheet s, int sc, int sr, int ec, int er, String title, String val, String sub, String bg, String accent, String text) {
  _rect(s, sc, sr, ec, er, bg);
  _txt(s, CellIndex.indexByColumnRow(columnIndex: sc+1, rowIndex: sr+1).toString(), title, bold: true, size: 9, color: accent, bg: bg);
  _txt(s, CellIndex.indexByColumnRow(columnIndex: sc+1, rowIndex: sr+2).toString(), val, bold: true, size: 28, color: text, bg: bg);
  _txt(s, CellIndex.indexByColumnRow(columnIndex: sc+1, rowIndex: sr+4).toString(), sub, size: 8, color: accent, bg: bg);
}
