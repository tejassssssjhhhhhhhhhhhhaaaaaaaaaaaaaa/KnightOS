import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class IntakeOrchestrator {
  final String workbookPath;
  late Excel excel;
  late String currentSessionId;

  IntakeOrchestrator(this.workbookPath) {
    var bytes = File(workbookPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
    currentSessionId = 'SESS-${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> syncSource(String source, List<Map<String, dynamic>> data) async {
    final startTime = DateTime.now();
    int discovered = data.length;
    int received = 0;
    int normalizedCount = 0;
    int duplicatesCount = 0;
    int ssotCount = 0;
    int failedCount = 0;

    print('[$source] Starting Sync Session: $currentSessionId');

    for (var record in data) {
      try {
        received++;
        final originId = record['id'] ?? record['message_id'] ?? record['event_id'] ?? 'unknown';
        
        // 1. RAW INTAKE
        final rawId = _writeToRaw(source, originId, record);
        
        // 2. DEDUPLICATION
        final knightHash = _generateHash('$source-$originId');
        final isDuplicate = _checkDuplicate(knightHash);

        if (isDuplicate) {
          _markDuplicate(knightHash, rawId);
          duplicatesCount++;
          continue;
        }

        // 3. NORMALIZATION
        _writeToNormalized(knightHash, rawId, source, record);
        normalizedCount++;

        // 4. CATEGORIZATION & IMPORTANCE (Rule-based)
        final category = _categorize(source, record);
        final importance = _calculateImportance(source, record);

        // 5. SSoT & PROVENANCE
        _writeToSSoT(knightHash, source, originId, record, category, importance);
        ssotCount++;

      } catch (e) {
        failedCount++;
        _logDiagnostic(source, 'INGESTION_ERROR', e.toString(), record.toString());
      }
    }

    _updateSyncLog(source, startTime, DateTime.now(), discovered, ssotCount, failedCount);
    _updateDataHub(source, ssotCount, duplicatesCount, failedCount);
    
    _save();
    print('[$source] Sync Complete. SSoT: $ssotCount, Duplicates: $duplicatesCount, Failed: $failedCount');
  }

  String _writeToRaw(String source, String originId, Map<String, dynamic> data) {
    var sheet = excel['20_RAW_INTAKE'];
    final row = sheet.maxRows;
    final rawId = 'RAW-$source-${DateTime.now().microsecondsSinceEpoch}';
    
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(rawId);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(source);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(originId);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(jsonEncode(data));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue(currentSessionId);
    
    return rawId;
  }

  void _writeToNormalized(String hash, String rawId, String source, Map<String, dynamic> data) {
    var sheet = excel['30_NORMALIZED_DATA'];
    final row = sheet.maxRows;
    
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(hash);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(rawId);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(source);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(_mapType(source, data));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(_extractDate(source, data));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue(_extractTitle(source, data));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = TextCellValue(_extractSnippet(source, data));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row)).value = TextCellValue('PENDING');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row)).value = TextCellValue('SUCCESS');
  }

  void _writeToSSoT(String hash, String source, String originId, Map<String, dynamic> data, String category, String importance) {
    var sheet = excel['10_SSOT_STORE'];
    final row = sheet.maxRows;
    final provId = 'PROV-$hash';

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(hash);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(_extractDate(source, data));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(source);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(_extractTitle(source, data));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(_extractSnippet(source, data));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue(category);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = TextCellValue(importance);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row)).value = DoubleCellValue(1.0);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row)).value = TextCellValue(provId);

    // Provenance
    var pSheet = excel['PROVENANCE'];
    final pRow = pSheet.maxRows;
    pSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: pRow)).value = TextCellValue(provId);
    pSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: pRow)).value = TextCellValue(hash);
    pSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: pRow)).value = TextCellValue('$source -> RAW -> NORM -> SSOT');
    pSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: pRow)).value = TextCellValue(DateTime.now().toIso8601String());
  }

  void _markDuplicate(String hash, String rawId) {
    var sheet = excel['30_NORMALIZED_DATA'];
    final row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(hash);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(rawId);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row)).value = TextCellValue('DUPLICATE');
  }

  bool _checkDuplicate(String hash) {
    var sheet = excel['10_SSOT_STORE'];
    for (var row in sheet.rows) {
      if (row.isNotEmpty && row[0]?.value.toString() == hash) return true;
    }
    return false;
  }

  String _generateHash(String input) {
    return sha256.convert(utf8.encode(input)).toString().substring(0, 16);
  }

  String _mapType(String source, Map data) {
    if (source == 'GMAIL') return 'COMMUNICATION';
    if (source == 'CALENDAR') return 'EVENT';
    if (source == 'DRIVE') return 'FILE';
    if (source == 'CONTACTS') return 'PEOPLE';
    if (source == 'TASKS') return 'TASK';
    return 'DATA';
  }

  String _extractDate(String source, Map data) {
    if (source == 'GMAIL') return data['date'] ?? '';
    if (source == 'CALENDAR') return data['start'] ?? '';
    if (source == 'DRIVE') return data['modifiedTime'] ?? '';
    if (source == 'TASKS') return data['due'] ?? '';
    return DateTime.now().toIso8601String();
  }

  String _extractTitle(String source, Map data) {
    if (source == 'GMAIL') return data['subject'] ?? 'No Subject';
    if (source == 'CALENDAR') return data['summary'] ?? 'No Title';
    if (source == 'DRIVE') return data['name'] ?? 'Untitled';
    if (source == 'CONTACTS') return data['displayName'] ?? 'Unknown';
    if (source == 'TASKS') return data['title'] ?? 'Task';
    return 'Item';
  }

  String _extractSnippet(String source, Map data) {
    if (source == 'GMAIL') return data['snippet'] ?? '';
    if (source == 'DRIVE') return data['mimeType'] ?? '';
    if (source == 'TASKS') return data['notes'] ?? '';
    return '';
  }

  String _categorize(String source, Map data) {
    final text = (data.toString()).toLowerCase();
    if (text.contains('invoice') || text.contains('bank') || text.contains('payment')) return 'FINANCE';
    if (text.contains('meeting') || text.contains('scrum') || text.contains('interview')) return 'CAREER';
    if (text.contains('flight') || text.contains('hotel') || text.contains('travel')) return 'TRAVEL';
    if (text.contains('health') || text.contains('doctor') || text.contains('gym')) return 'HEALTH';
    return 'OTHER';
  }

  String _calculateImportance(String source, Map data) {
    final text = (data.toString()).toLowerCase();
    if (text.contains('urgent') || text.contains('important') || text.contains('deadline')) return 'IMPORTANT';
    if (source == 'GMAIL' && data['starred'] == true) return 'IMPORTANT';
    return 'NORMAL';
  }

  void _updateSyncLog(String source, DateTime start, DateTime end, int disc, int ssot, int fail) {
    var sheet = excel['SYNC_LOG'];
    final row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(currentSessionId);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(start.toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(end.toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(source);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = IntCellValue(disc);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = IntCellValue(ssot);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = TextCellValue(fail > 0 ? 'PARTIAL' : 'COMPLETED');
  }

  void _updateDataHub(String source, int ssot, int dupe, int fail) {
    var sheet = excel['01_DATA_HUB'];
    // Logic for Source Health Rows based on index
    final List<String> sources = ["GMAIL", "CALENDAR", "DRIVE", "CONTACTS", "TASKS"];
    int rowIdx = sources.indexOf(source);
    if (rowIdx != -1) {
      int excelRow = 6 + rowIdx; // Row 6 is Gmail
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: excelRow - 1)).value = TextCellValue('CONNECTED');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: excelRow - 1)).value = TextCellValue(DateTime.now().toIso8601String());
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: excelRow - 1)).value = TextCellValue(fail > 0 ? '● AMBER' : '● GREEN');
    }
    
    // Update Engine status
    sheet.cell(CellIndex.indexByString("B2")).value = TextCellValue("IDLE");
  }

  void _logDiagnostic(String source, String type, String msg, String detail) {
    var sheet = excel['90_DIAGNOSTICS'];
    final row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(source);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(type);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(msg);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(detail);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue('NO');
  }

  void _save() {
    var bytes = excel.save();
    if (bytes != null) {
      File(workbookPath).writeAsBytesSync(bytes);
    }
  }
}
