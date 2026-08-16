import 'dart:io';
import 'package:excel/excel.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class GmailSyncService {
  final String workbookPath;
  late Excel excel;

  GmailSyncService(this.workbookPath) {
    var bytes = File(workbookPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
  }

  Future<void> runSync(List<Map<String, dynamic>> mockMessages) async {
    final sessionId = 'SYNC-${DateTime.now().millisecondsSinceEpoch}';
    final startTime = DateTime.now();
    int discovered = mockMessages.length;
    int received = 0;
    int normalizedCount = 0;
    int duplicatesCount = 0;
    int ssotCount = 0;

    print('[GMAIL] Starting Sync Session: $sessionId');

    for (var msg in mockMessages) {
      received++;
      
      // 1. RAW INTAKE
      final rawId = _writeToRawIntake(msg, sessionId);
      
      // 2. NORMALIZATION & DEDUPLICATION
      final knightHash = _generateHash(msg['message_id']);
      final isDuplicate = _checkDuplicate(knightHash);

      if (!isDuplicate) {
        _writeToNormalized(knightHash, rawId, msg, sessionId);
        normalizedCount++;

        // 3. CATEGORIZATION & IMPORTANCE (Rule-based)
        final category = _categorize(msg);
        final importance = _calculateImportance(msg);

        // 4. SSoT
        _writeToSSoT(knightHash, msg, category, importance, sessionId);
        ssotCount++;
      } else {
        _markAsDuplicate(knightHash, rawId, sessionId);
        duplicatesCount++;
      }
    }

    // 5. UPDATE SYNC LOG
    _updateSyncLog(sessionId, startTime, DateTime.now(), discovered, received, normalizedCount, ssotCount);

    // 6. UPDATE DATA HUB
    _updateDataHub(sessionId, ssotCount, duplicatesCount);

    // Save
    var fileBytes = excel.save();
    if (fileBytes != null) {
      File(workbookPath).writeAsBytesSync(fileBytes);
    }
    print('[GMAIL] Sync Session Completed: $ssotCount new records added to SSoT.');
  }

  String _writeToRawIntake(Map<String, dynamic> msg, String sessionId) {
    var sheet = excel['20_RAW_INTAKE'];
    int lastRow = sheet.maxRows;
    final rawId = 'RAW-${msg['message_id']}';
    
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: lastRow)).value = TextCellValue(rawId);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: lastRow)).value = TextCellValue('GMAIL');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: lastRow)).value = TextCellValue(msg['message_id']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: lastRow)).value = TextCellValue(jsonEncode(msg));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: lastRow)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: lastRow)).value = TextCellValue(sessionId);
    
    return rawId;
  }

  void _writeToNormalized(String hash, String rawId, Map<String, dynamic> msg, String sessionId) {
    var sheet = excel['30_NORMALIZED_DATA'];
    int lastRow = sheet.maxRows;
    
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: lastRow)).value = TextCellValue(hash);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: lastRow)).value = TextCellValue(rawId);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: lastRow)).value = TextCellValue('GMAIL');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: lastRow)).value = TextCellValue('COMMUNICATION');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: lastRow)).value = TextCellValue(msg['date']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: lastRow)).value = TextCellValue(msg['subject']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: lastRow)).value = TextCellValue(msg['snippet']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: lastRow)).value = TextCellValue('PENDING');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: lastRow)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: lastRow)).value = TextCellValue('SUCCESS');
  }

  void _writeToSSoT(String hash, Map<String, dynamic> msg, String category, String importance, String sessionId) {
    var sheet = excel['10_SSOT_STORE'];
    int lastRow = sheet.maxRows;
    
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: lastRow)).value = TextCellValue(hash);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: lastRow)).value = TextCellValue(msg['date']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: lastRow)).value = TextCellValue('GMAIL');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: lastRow)).value = TextCellValue(msg['subject']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: lastRow)).value = TextCellValue(msg['snippet']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: lastRow)).value = TextCellValue(category);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: lastRow)).value = TextCellValue(importance);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: lastRow)).value = DoubleCellValue(1.0); // Rule-based is 100% confident in its rule
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: lastRow)).value = TextCellValue('PROV-${hash}');
    
    // Also write to Provenance
    var provSheet = excel['PROVENANCE'];
    int pRow = provSheet.maxRows;
    provSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: pRow)).value = TextCellValue('PROV-${hash}');
    provSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: pRow)).value = TextCellValue(hash);
    provSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: pRow)).value = TextCellValue('GMAIL -> RAW -> NORM -> SSOT');
    provSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: pRow)).value = TextCellValue(DateTime.now().toIso8601String());
  }

  void _markAsDuplicate(String hash, String rawId, String sessionId) {
     var sheet = excel['30_NORMALIZED_DATA'];
     int lastRow = sheet.maxRows;
     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: lastRow)).value = TextCellValue(hash);
     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: lastRow)).value = TextCellValue(rawId);
     sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: lastRow)).value = TextCellValue('DUPLICATE');
  }

  bool _checkDuplicate(String hash) {
    var ssot = excel['10_SSOT_STORE'];
    for (var row in ssot.rows) {
      if (row.isNotEmpty && row[0]?.value.toString() == hash) return true;
    }
    return false;
  }

  String _generateHash(String input) {
    return sha256.convert(utf8.encode(input)).toString().substring(0, 12);
  }

  String _categorize(Map<String, dynamic> msg) {
    final sub = msg['subject'].toString().toLowerCase();
    if (sub.contains('invoice') || sub.contains('payment') || sub.contains('bank')) return 'FINANCE';
    if (sub.contains('trip') || sub.contains('flight') || sub.contains('hotel')) return 'TRAVEL';
    if (sub.contains('meeting') || sub.contains('zoom') || sub.contains('calendar')) return 'CALENDAR';
    return 'OTHER';
  }

  String _calculateImportance(Map<String, dynamic> msg) {
    if (msg['starred'] == true) return 'IMPORTANT';
    final sub = msg['subject'].toString().toLowerCase();
    if (sub.contains('urgent') || sub.contains('action required')) return 'IMPORTANT';
    return 'NORMAL';
  }

  void _updateSyncLog(String sid, DateTime start, DateTime end, int discovered, int received, int norm, int ssot) {
    var sheet = excel['SYNC_LOG'];
    int row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(sid);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(start.toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(end.toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue('GMAIL');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = IntCellValue(discovered);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = IntCellValue(ssot);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = TextCellValue('COMPLETED');
  }

  void _updateDataHub(String sid, int ssot, int duplicates) {
    var sheet = excel['01_DATA_HUB'];
    // Update Gmail Status
    sheet.cell(CellIndex.indexByString("B6")).value = TextCellValue("CONNECTED");
    sheet.cell(CellIndex.indexByString("C6")).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByString("E6")).value = TextCellValue("● GREEN");

    // Update Engine Status
    sheet.cell(CellIndex.indexByString("B2")).value = TextCellValue("COMPLETED");
    sheet.cell(CellIndex.indexByString("H5")).value = TextCellValue("GMAIL_SYNC");
    sheet.cell(CellIndex.indexByString("H7")).value = TextCellValue("100%");
  }
}
