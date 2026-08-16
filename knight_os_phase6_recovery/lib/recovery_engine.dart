import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

enum RecoveryState { healthy, processing, failed, recoverable, recovering, recovered, recoveryFailed, requiresUserAction }

class RecoveryEngine {
  final String workbookPath;
  late Excel excel;

  RecoveryEngine(this.workbookPath) {
    var bytes = File(workbookPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
  }

  void initializeRecoverySheets() {
    _createTable('RECOVERY_LOG', [
      "ACTION_ID", "TIMESTAMP", "SOURCE", "PREVIOUS_STATE", "ACTION", "RESULT", "ERROR_DETAILS"
    ]);
    _save();
  }

  Future<void> runSyncWithRetry(String source, List<Map<String, dynamic>> data, {bool simulateFailure = false, String? failureType}) async {
    int maxAttempts = 3;
    int attempt = 0;
    bool success = false;
    String lastError = "";

    final sessionId = 'SESS-REC-${DateTime.now().millisecondsSinceEpoch}';
    _logSyncStart(sessionId, source);

    while (attempt < maxAttempts && !success) {
      attempt++;
      print('[$source] Sync Attempt $attempt/$maxAttempts...');

      try {
        if (simulateFailure && attempt == 1) {
          if (failureType == 'NETWORK') throw Exception('Simulated Network Timeout');
          if (failureType == 'AUTH') throw Exception('Simulated Authentication Expired');
        }

        await _processInBatch(source, data, sessionId);
        success = true;
        _logRecoveryAction(source, 'SYNC', 'SUCCESS', '');
      } catch (e) {
        lastError = e.toString();
        print('[$source] Attempt $attempt failed: $lastError');

        if (lastError.contains('Authentication')) {
          _updateSourceStatus(source, RecoveryState.requiresUserAction, lastError);
          _logRecoveryAction(source, 'SYNC', 'BLOCKED', 'Requires Re-authentication');
          break; // Don't retry auth errors
        }

        if (attempt < maxAttempts) {
          _updateSourceStatus(source, RecoveryState.recoverable, lastError);
          _logRecoveryAction(source, 'RETRY', 'PENDING', lastError);
          // Simulate backoff
          await Future.delayed(Duration(milliseconds: 100));
        } else {
          _updateSourceStatus(source, RecoveryState.recoveryFailed, lastError);
          _logRecoveryAction(source, 'RETRY', 'FAILED', 'Max attempts reached: $lastError');
        }
      }
    }

    if (success) {
      _updateSourceStatus(source, RecoveryState.recovered, "All records processed");
      _verifyIntegrity(source);
    }
    
    _save();
  }

  Future<void> _processInBatch(String source, List<Map<String, dynamic>> data, String sessionId) async {
    // Reusing logic from Phase 3 but ensuring idempotency
    var ssot = excel['10_SSOT_STORE'];
    int added = 0;

    for (var record in data) {
      final originId = record['id'] ?? 'unknown';
      final identityHash = _generateHash('$source-$originId');
      
      if (!_checkDuplicate(identityHash)) {
        _writeToSSoT(identityHash, source, originId, record);
        added++;
      }
    }
    print('[$source] Processed ${data.length} records. Added to SSoT: $added');
  }

  void _updateSourceStatus(String source, RecoveryState state, String msg) {
    var diag = excel['90_DIAGNOSTICS'];
    int row = diag.maxRows;
    diag.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    diag.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(source);
    diag.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(state.name.toUpperCase());
    diag.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(msg);
    
    // Update Data Hub visual
    var hub = excel['01_DATA_HUB'];
    final sources = ["GMAIL", "CALENDAR", "DRIVE", "CONTACTS", "TASKS"];
    int rowIdx = sources.indexOf(source);
    if (rowIdx != -1) {
       String color = (state == RecoveryState.healthy || state == RecoveryState.recovered) ? "● GREEN" : 
                      (state == RecoveryState.recoverable || state == RecoveryState.recovering) ? "● AMBER" : "● RED";
       hub.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 5 + rowIdx)).value = TextCellValue(color);
       hub.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 5 + rowIdx)).value = TextCellValue(state.name.toUpperCase());
    }
  }

  void _verifyIntegrity(String source) {
    print('[$source] Running Post-Recovery Verification...');
    // Check for duplicates in SSoT
    var ssot = excel['10_SSOT_STORE'];
    Set<String> ids = {};
    bool corrupted = false;
    for (int i = 1; i < ssot.maxRows; i++) {
      var id = ssot.rows[i][0]?.value.toString();
      if (id != null) {
        if (ids.contains(id)) corrupted = true;
        ids.add(id);
      }
    }
    
    if (!corrupted) {
      _updateSourceStatus(source, RecoveryState.healthy, "Integrity Verified Post-Recovery");
    } else {
      _updateSourceStatus(source, RecoveryState.failed, "SSoT Corruption Detected during Recovery!");
    }
  }

  void _logRecoveryAction(String source, String action, String result, String error) {
    var sheet = excel['RECOVERY_LOG'];
    int row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue('ACT-${DateTime.now().microsecondsSinceEpoch}');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(source);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(action);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue(result);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = TextCellValue(error);
  }

  void _logSyncStart(String sid, String source) {
    var log = excel['SYNC_LOG'];
    int row = log.maxRows;
    log.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(sid);
    log.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    log.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(source);
    log.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = TextCellValue('STARTED');
  }

  bool _checkDuplicate(String hash) {
    var sheet = excel['10_SSOT_STORE'];
    for (var row in sheet.rows) {
      if (row.isNotEmpty && row[0]?.value.toString() == hash) return true;
    }
    return false;
  }

  void _writeToSSoT(String hash, String source, String originId, Map<String, dynamic> data) {
    var sheet = excel['10_SSOT_STORE'];
    int row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(hash);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(source);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(data['summary'] ?? 'Item');
  }

  String _generateHash(String input) {
    return sha256.convert(utf8.encode(input)).toString().substring(0, 16);
  }

  void _createTable(String name, List<String> headers) {
    var sheet = excel[name];
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(headers[i]);
    }
  }

  void _save() {
    var bytes = excel.save();
    if (bytes != null) {
      File(workbookPath).writeAsBytesSync(bytes);
    }
  }
}
