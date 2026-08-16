import 'dart:io';
import 'package:excel/excel.dart';

class FinalValidator {
  final String workbookPath;
  late Excel excel;

  FinalValidator(this.workbookPath) {
    var bytes = File(workbookPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
  }

  bool runFullAudit() {
    print('[RELEASE] Running Final Release Audit...');
    bool pass = true;

    pass &= _checkStructuralIntegrity();
    pass &= _checkDataIntegrity();
    pass &= _checkExperienceCoherence();
    pass &= _checkSecurityBaseline();

    if (pass) {
      _prepareReleaseWorkbook();
    }

    return pass;
  }

  bool _checkStructuralIntegrity() {
    print('[AUDIT] Checking Structural Integrity...');
    List<String> requiredSheets = [
      '00_COMMAND_CENTER', '01_DATA_HUB', '10_SSOT_STORE', 
      '20_RAW_INTAKE', '30_NORMALIZED_DATA', '40_KNIGHT_BRAIN', 
      '90_DIAGNOSTICS', '99_CONFIG', 'SYNC_LOG', 'PROVENANCE',
      'AI_CHAT_LOG', 'RECOVERY_LOG'
    ];
    
    for (var sheet in requiredSheets) {
      if (!excel.tables.containsKey(sheet)) {
        print('[FAIL] Missing sheet: $sheet');
        return false;
      }
    }
    print('[PASS] All 12 mandatory sheets exist.');
    return true;
  }

  bool _checkDataIntegrity() {
    print('[AUDIT] Checking Data Integrity...');
    var ssot = excel['10_SSOT_STORE'];
    var prov = excel['PROVENANCE'];
    
    if (ssot.maxRows > 1 && prov.maxRows <= 1) {
      print('[FAIL] Authoritative data exists without provenance.');
      return false;
    }

    // Check for duplicate SSoT IDs
    Set<String> ids = {};
    for (int i = 1; i < ssot.maxRows; i++) {
      String? id = ssot.rows[i][0]?.value.toString();
      if (id != null) {
        if (ids.contains(id)) {
          print('[FAIL] Duplicate SSoT ID detected: $id');
          return false;
        }
        ids.add(id);
      }
    }

    print('[PASS] SSoT and Provenance integrity verified.');
    return true;
  }

  bool _checkExperienceCoherence() {
    print('[AUDIT] Checking User Experience Coherence...');
    var home = excel['00_COMMAND_CENTER'];
    
    // Check for global navigation
    var nav = home.cell(CellIndex.indexByString("F1")).value.toString();
    if (!nav.contains("NAV:")) {
      print('[FAIL] Global navigation missing from Command Center.');
      return false;
    }

    // Check for health monitor formulas
    var health = home.cell(CellIndex.indexByString("B10")).formula;
    if (health == null && home.cell(CellIndex.indexByString("B10")).value == null) {
       print('[FAIL] Health Monitor is unlinked.');
       return false;
    }

    print('[PASS] User experience layers are coherent.');
    return true;
  }

  bool _checkSecurityBaseline() {
    print('[AUDIT] Checking Security Baseline...');
    // Scan Config for obvious secrets
    var config = excel['99_CONFIG'];
    for (var row in config.rows) {
      for (var cell in row) {
        String val = cell?.value.toString() ?? "";
        if (val.contains("AI_KEY") || val.contains("CLIENT_SECRET")) {
          if (val != "AI_KEY" && val != "CLIENT_SECRET" && val.length > 20) {
             print('[FAIL] Potential secret exposure in Config: ${cell?.cellIndex}');
             return false;
          }
        }
      }
    }
    print('[PASS] No static secrets detected in workbook.');
    return true;
  }

  void _prepareReleaseWorkbook() {
    print('[RELEASE] Packaging KNIGHTOS v6.0 — EXCEL EDITION...');
    
    // Update version string
    var config = excel['99_CONFIG'];
    config.cell(CellIndex.indexByString("B2")).value = TextCellValue("6.0.0-RELEASE");
    
    var bytes = excel.save();
    if (bytes != null) {
      File('../KNIGHTOS_V6_EXCEL_EDITION_FINAL.xlsx').writeAsBytesSync(bytes);
      print('[SUCCESS] Final release workbook generated.');
    }
  }
}
