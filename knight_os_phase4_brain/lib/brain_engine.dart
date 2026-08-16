import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class BrainEngine {
  final String workbookPath;
  late Excel excel;

  BrainEngine(this.workbookPath) {
    var bytes = File(workbookPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
  }

  void initializeBrainTables() {
    _createTable('40_KNIGHT_BRAIN', [
      "MEMORY_ID", "SUBJECT", "MEMORY_TYPE", "CONTENT", "STATE", 
      "CONFIDENCE", "CONFIDENCE_REASON", "FRESHNESS", "CONFLICT_STATUS",
      "FIRST_OBSERVED", "LAST_OBSERVED", "LAST_VALIDATED", "PROVENANCE_ID", "UPDATED_AT"
    ]);
    
    _createTable('41_BRAIN_ENTITIES', [
      "ENTITY_ID", "NAME", "TYPE", "DOMAIN", "CONFIDENCE", "CREATED_AT"
    ]);

    _createTable('42_BRAIN_RELATIONSHIPS', [
      "RELATIONSHIP_ID", "FROM_ENTITY", "TYPE", "TO_ENTITY", "CONFIDENCE", "EVIDENCE_ID"
    ]);

    _createTable('43_BRAIN_HEALTH', [
      "METRIC", "VALUE", "STATUS", "LAST_CALCULATED"
    ]);

    _createTable('44_KNOWLEDGE_GAPS', [
      "GAP_ID", "DOMAIN", "SUBJECT", "REASON", "PRIORITY"
    ]);
    
    _save();
  }

  Future<void> processMemories() async {
    // 1. Scan SSoT for new knowledge
    var ssot = excel['10_SSOT_STORE'];
    
    for (int i = 1; i < ssot.maxRows; i++) {
      var row = ssot.rows[i];
      if (row.isEmpty || row[0] == null) continue;

      final knightId = row[0]!.value.toString();
      final date = row[1]!.value.toString();
      final source = row[2]!.value.toString();
      final title = row[3]!.value.toString();
      final content = row[4]!.value.toString();
      final category = row[5]!.value.toString();
      final importance = row[6]!.value.toString();

      // Create a memory for each SSoT record (Observed state)
      _upsertMemory(
        subject: title,
        type: 'FACT',
        value: content,
        state: 'OBSERVED',
        sourceRef: knightId,
        confidence: 0.9,
        reason: 'Directly observed from $source',
        firstObs: date,
        lastObs: date,
      );
    }

    _calculateBrainHealth();
    _detectKnowledgeGaps();
    _save();
  }

  void _upsertMemory({
    required String subject,
    required String type,
    required String value,
    required String state,
    required String sourceRef,
    required double confidence,
    required String reason,
    required String firstObs,
    required String lastObs,
  }) {
    var sheet = excel['40_KNIGHT_BRAIN'];
    final memoryId = _generateHash('$subject-$type');
    
    int existingIdx = -1;
    for (int i = 1; i < sheet.maxRows; i++) {
      if (sheet.rows[i].isNotEmpty && sheet.rows[i][0]?.value.toString() == memoryId) {
        existingIdx = i;
        break;
      }
    }

    if (existingIdx != -1) {
      // Update logic: Check for conflicts
      var existingValue = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: existingIdx)).value.toString();
      if (existingValue != value) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: existingIdx)).value = TextCellValue('POSSIBLE_CONFLICT');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: existingIdx)).value = TextCellValue('NEEDS_REVIEW');
      }
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: existingIdx)).value = TextCellValue(lastObs);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: existingIdx)).value = TextCellValue(DateTime.now().toIso8601String());
    } else {
      // New memory
      int row = sheet.maxRows;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(memoryId);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(subject);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(type);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(value);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(state);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = DoubleCellValue(confidence);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = TextCellValue(reason);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row)).value = TextCellValue('FRESH');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row)).value = TextCellValue('NONE');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row)).value = TextCellValue(firstObs);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: row)).value = TextCellValue(lastObs);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: row)).value = TextCellValue('PROV-$memoryId');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    }
  }

  void _calculateBrainHealth() {
    var brain = excel['40_KNIGHT_BRAIN'];
    var health = excel['43_BRAIN_HEALTH'];
    
    int total = brain.maxRows - 1;
    int observed = 0;
    int conflicts = 0;
    int needsReview = 0;

    for (int i = 1; i < brain.maxRows; i++) {
      var row = brain.rows[i];
      if (row.isEmpty) continue;
      if (row[4]?.value.toString() == 'OBSERVED') observed++;
      if (row[4]?.value.toString() == 'NEEDS_REVIEW') needsReview++;
      if (row[8]?.value.toString() == 'POSSIBLE_CONFLICT') conflicts++;
    }

    _setHealthMetric(health, 0, "TOTAL_MEMORIES", total.toString());
    _setHealthMetric(health, 1, "OBSERVED_RATIO", total > 0 ? (observed/total).toStringAsFixed(2) : "0");
    _setHealthMetric(health, 2, "CONFLICTS", conflicts.toString());
    _setHealthMetric(health, 3, "NEEDS_REVIEW", needsReview.toString());
    
    double score = total > 0 ? ((observed - conflicts - needsReview) / total) * 100 : 100;
    _setHealthMetric(health, 4, "BRAIN_HEALTH_SCORE", "${score.clamp(0, 100).toInt()}%");
  }

  void _detectKnowledgeGaps() {
    var ssot = excel['10_SSOT_STORE'];
    var gaps = excel['44_KNOWLEDGE_GAPS'];
    
    Set<String> domainsFound = {};
    for (int i = 1; i < ssot.maxRows; i++) {
      if (ssot.rows[i].isNotEmpty && ssot.rows[i][2] != null) {
        domainsFound.add(ssot.rows[i][2]!.value.toString());
      }
    }

    List<String> required = ["GMAIL", "CALENDAR", "DRIVE", "CONTACTS", "TASKS"];
    int row = 1;
    for (var r in required) {
      if (!domainsFound.contains(r)) {
        gaps.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue('GAP-${DateTime.now().millisecondsSinceEpoch}-$r');
        gaps.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(r);
        gaps.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue('SOURCE_MISSING');
        gaps.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue('No data has been ingested from $r');
        gaps.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue('HIGH');
        row++;
      }
    }
  }

  void _setHealthMetric(Sheet sheet, int rowIdx, String name, String value) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIdx + 1)).value = TextCellValue(name);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIdx + 1)).value = TextCellValue(value);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIdx + 1)).value = TextCellValue(DateTime.now().toIso8601String());
  }

  void _createTable(String name, List<String> headers) {
    var sheet = excel[name];
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(headers[i]);
    }
  }

  String _generateHash(String input) {
    return sha256.convert(utf8.encode(input)).toString().substring(0, 12);
  }

  void _save() {
    var bytes = excel.save();
    if (bytes != null) {
      File(workbookPath).writeAsBytesSync(bytes);
    }
  }
}
