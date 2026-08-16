import 'dart:io';
import 'package:excel/excel.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class CalendarSyncService {
  final String workbookPath;
  late Excel excel;

  CalendarSyncService(this.workbookPath) {
    var bytes = File(workbookPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
  }

  Future<void> runSync(List<Map<String, dynamic>> mockEvents) async {
    final sessionId = 'SYNC-CAL-${DateTime.now().millisecondsSinceEpoch}';
    final startTime = DateTime.now();
    int discovered = mockEvents.length;
    int received = 0;
    int normalizedCount = 0;
    int duplicatesCount = 0;
    int ssotCount = 0;

    print('[CALENDAR] Starting Sync Session: $sessionId');

    for (var event in mockEvents) {
      received++;
      
      // 1. RAW INTAKE
      final rawId = _writeToRawIntake(event, sessionId);
      
      // 2. NORMALIZATION & DEDUPLICATION
      final eventIdentifier = '${event['calendar_id']}_${event['event_id']}';
      final knightHash = _generateHash(eventIdentifier);
      final isDuplicate = _checkDuplicate(knightHash);

      if (!isDuplicate) {
        _writeToNormalized(knightHash, rawId, event, sessionId);
        normalizedCount++;

        // 3. CATEGORIZATION & IMPORTANCE (Rule-based)
        final category = _categorize(event);
        final importance = _calculateImportance(event);

        // 4. SSoT
        _writeToSSoT(knightHash, event, category, importance, sessionId);
        ssotCount++;
      } else {
        _markAsDuplicate(knightHash, rawId, sessionId);
        duplicatesCount++;
      }
    }

    // 5. UPDATE SYNC LOG
    _updateSyncLog(sessionId, startTime, DateTime.now(), discovered, received, ssotCount);

    // 6. UPDATE DATA HUB
    _updateDataHub(sessionId, ssotCount, duplicatesCount);

    // Save
    var fileBytes = excel.save();
    if (fileBytes != null) {
      File(workbookPath).writeAsBytesSync(fileBytes);
    }
    print('[CALENDAR] Sync Session Completed: $ssotCount new records added to SSoT.');
  }

  String _writeToRawIntake(Map<String, dynamic> event, String sessionId) {
    var sheet = excel['20_RAW_INTAKE'];
    int lastRow = sheet.maxRows;
    final rawId = 'RAW-CAL-${event['event_id']}';
    
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: lastRow)).value = TextCellValue(rawId);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: lastRow)).value = TextCellValue('GOOGLE_CALENDAR');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: lastRow)).value = TextCellValue(event['event_id']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: lastRow)).value = TextCellValue(jsonEncode(event));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: lastRow)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: lastRow)).value = TextCellValue(sessionId);
    
    return rawId;
  }

  void _writeToNormalized(String hash, String rawId, Map<String, dynamic> event, String sessionId) {
    var sheet = excel['30_NORMALIZED_DATA'];
    int lastRow = sheet.maxRows;
    
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: lastRow)).value = TextCellValue(hash);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: lastRow)).value = TextCellValue(rawId);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: lastRow)).value = TextCellValue('GOOGLE_CALENDAR');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: lastRow)).value = TextCellValue('CALENDAR');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: lastRow)).value = TextCellValue(event['start']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: lastRow)).value = TextCellValue(event['summary']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: lastRow)).value = TextCellValue(event['description'] ?? '');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: lastRow)).value = TextCellValue('PENDING');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: lastRow)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: lastRow)).value = TextCellValue('SUCCESS');
  }

  void _writeToSSoT(String hash, Map<String, dynamic> event, String category, String importance, String sessionId) {
    var sheet = excel['10_SSOT_STORE'];
    int lastRow = sheet.maxRows;
    
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: lastRow)).value = TextCellValue(hash);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: lastRow)).value = TextCellValue(event['start']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: lastRow)).value = TextCellValue('GOOGLE_CALENDAR');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: lastRow)).value = TextCellValue(event['summary']);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: lastRow)).value = TextCellValue(event['description'] ?? '');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: lastRow)).value = TextCellValue(category);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: lastRow)).value = TextCellValue(importance);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: lastRow)).value = DoubleCellValue(1.0);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: lastRow)).value = TextCellValue('PROV-${hash}');
    
    // Provenance
    var provSheet = excel['PROVENANCE'];
    int pRow = provSheet.maxRows;
    provSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: pRow)).value = TextCellValue('PROV-${hash}');
    provSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: pRow)).value = TextCellValue(hash);
    provSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: pRow)).value = TextCellValue('CALENDAR -> RAW -> NORM -> SSOT');
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

  String _categorize(Map<String, dynamic> event) {
    final title = event['summary'].toString().toLowerCase();
    if (title.contains('doctor') || title.contains('hospital') || title.contains('medical')) return 'HEALTH';
    if (title.contains('flight') || title.contains('travel') || title.contains('hotel')) return 'TRAVEL';
    if (title.contains('interview') || title.contains('work') || title.contains('scrum')) return 'CAREER';
    if (title.contains('gym') || title.contains('workout')) return 'HEALTH';
    return 'MEETING';
  }

  String _calculateImportance(Map<String, dynamic> event) {
    final title = event['summary'].toString().toLowerCase();
    if (title.contains('interview') || title.contains('urgent') || title.contains('deadline')) return 'IMPORTANT';
    if ((event['attendees'] as List?)?.length != null && (event['attendees'] as List).length > 5) return 'IMPORTANT';
    return 'NORMAL';
  }

  void _updateSyncLog(String sid, DateTime start, DateTime end, int discovered, int received, int ssot) {
    var sheet = excel['SYNC_LOG'];
    int row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(sid);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(start.toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(end.toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue('GOOGLE_CALENDAR');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = IntCellValue(discovered);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = IntCellValue(ssot);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = TextCellValue('COMPLETED');
  }

  void _updateDataHub(String sid, int ssot, int duplicates) {
    var sheet = excel['01_DATA_HUB'];
    // Update Calendar Status (Row 6 in Hub was Gmail, Row 7 is Calendar in the stage list, but in Source Health it's different)
    // Looking at my previous implementation of _createDataHub and _updateDataHub:
    // Sources are GMAIL, CALENDAR, DRIVE...
    // In Data Hub Sheet (01_DATA_HUB):
    // Source Health starts at Row 5. GMAIL is Row 5, CALENDAR is Row 6.
    // Wait, in my _updateDataHub for Gmail I used B6 and C6. 
    // Let's re-verify the layout.
    // Row 4: SOURCE HEALTH (Header)
    // Row 5: headers
    // Row 6: GMAIL (sources[0])
    // Row 7: CALENDAR (sources[1])
    
    sheet.cell(CellIndex.indexByString("B7")).value = TextCellValue("CONNECTED");
    sheet.cell(CellIndex.indexByString("C7")).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByString("E7")).value = TextCellValue("● GREEN");

    // Update Engine Status
    sheet.cell(CellIndex.indexByString("B2")).value = TextCellValue("COMPLETED");
    sheet.cell(CellIndex.indexByString("H5")).value = TextCellValue("CALENDAR_SYNC");
    sheet.cell(CellIndex.indexByString("H7")).value = TextCellValue("100%");
  }
}
