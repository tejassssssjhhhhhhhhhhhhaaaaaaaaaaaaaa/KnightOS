import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

class DiagnosticsEngine {
  final String workbookPath;
  late Excel excel;

  DiagnosticsEngine(this.workbookPath) {
    var bytes = File(workbookPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
  }

  void runFullHealthCheck() {
    print('[DIAGNOSTICS] Starting System-Wide Health Audit...');
    
    _checkWorkbookIntegrity();
    _checkSsotIntegrity();
    _checkBrainIntegrity();
    _checkProvenanceIntegrity();
    _checkConfigurationIntegrity();
    _updateHealthDashboards();

    _save();
    print('[DIAGNOSTICS] Health Audit Complete.');
  }

  void _checkWorkbookIntegrity() {
    List<String> requiredSheets = [
      '00_COMMAND_CENTER', '01_DATA_HUB', '10_SSOT_STORE', 
      '20_RAW_INTAKE', '30_NORMALIZED_DATA', '40_KNIGHT_BRAIN', 
      '90_DIAGNOSTICS', '99_CONFIG', 'SYNC_LOG', 'PROVENANCE'
    ];
    
    for (var sheet in requiredSheets) {
      if (!excel.tables.containsKey(sheet)) {
        _logDiagnostic('WORKBOOK', 'CRITICAL', 'Missing mandatory sheet: $sheet', 'Create sheet manually or re-run Phase 1.');
      }
    }
  }

  void _checkSsotIntegrity() {
    var ssot = excel['10_SSOT_STORE'];
    Set<String> ids = {};
    int duplicates = 0;

    for (int i = 1; i < ssot.maxRows; i++) {
      var row = ssot.rows[i];
      if (row.isEmpty || row[0] == null) continue;
      String id = row[0]!.value.toString();
      if (ids.contains(id)) {
        duplicates++;
      } else {
        ids.add(id);
      }
    }

    if (duplicates > 0) {
      _logDiagnostic('SSoT', 'ERROR', 'Detected $duplicates duplicate primary records in SSoT.', 'Run SSoT Deduplication utility.');
    } else {
      _logDiagnostic('SSoT', 'INFO', 'SSoT primary key integrity verified.', 'NONE');
    }
  }

  void _checkBrainIntegrity() {
    var brain = excel['40_KNIGHT_BRAIN'];
    var ssot = excel['10_SSOT_STORE'];
    
    // Check for orphan memories (missing from SSoT if they are OBSERVED)
    // Simplified for Phase 6: Just check table exists
    if (brain.maxRows < 1) {
      _logDiagnostic('BRAIN', 'WARNING', 'Knight Brain is empty.', 'Perform a sync to generate memories.');
    }
  }

  void _checkProvenanceIntegrity() {
    var prov = excel['PROVENANCE'];
    var ssot = excel['10_SSOT_STORE'];
    
    if (prov.maxRows - 1 < ssot.maxRows - 1) {
       _logDiagnostic('PROVENANCE', 'ERROR', 'SSoT records found without corresponding Provenance entries.', 'Rebuild Provenance chain.');
    }
  }

  void _checkConfigurationIntegrity() {
    var config = excel['99_CONFIG'];
    if (config.maxRows < 3) {
      _logDiagnostic('CONFIG', 'ERROR', 'Configuration parameters missing.', 'Check 99_CONFIG table.');
    }
  }

  void _updateHealthDashboards() {
    // 1. Update Command Center Health
    var home = excel['00_COMMAND_CENTER'];
    home.cell(CellIndex.indexByString("A10")).value = TextCellValue("SYSTEM HEALTH:");
    home.cell(CellIndex.indexByString("B10")).setFormula("IF(COUNTIF('90_DIAGNOSTICS'!C:C,\"CRITICAL\")>0,\"🔴 CRITICAL\",IF(COUNTIF('90_DIAGNOSTICS'!C:C,\"ERROR\")>0,\"🔴 ERROR\",IF(COUNTIF('90_DIAGNOSTICS'!C:C,\"WARNING\")>0,\"🟡 WARNING\",\"🟢 HEALTHY\"))) ");

    // 2. Update Data Hub Global Health
    var hub = excel['01_DATA_HUB'];
    hub.cell(CellIndex.indexByString("B2")).setFormula("'00_COMMAND_CENTER'!B10");
  }

  void _logDiagnostic(String subsystem, String level, String msg, String action) {
    var sheet = excel['90_DIAGNOSTICS'];
    int row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(subsystem);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(level);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(msg);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(action);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue('NO');
  }

  void _save() {
    var bytes = excel.save();
    if (bytes != null) {
      File(workbookPath).writeAsBytesSync(bytes);
    }
  }
}
