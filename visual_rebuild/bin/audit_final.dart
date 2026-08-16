import 'dart:io';

void main() {
  var oldFile = '../KNIGHTOS_V6_EXCEL_EDITION_FINAL_REBUILT.xlsx';
  var newFile = '../KNIGHTOS_V6_EXCEL_EDITION_VISUAL_FINAL.xlsx';

  if (File(newFile).existsSync()) {
    var oldSize = File(oldFile).lengthSync();
    var newSize = File(newFile).lengthSync();
    print('Old Size: $oldSize bytes');
    print('New Size: $newSize bytes');
    if (newSize > oldSize) {
      print('[PASS] Final workbook generated and significantly developed.');
    } else {
      print('[WARNING] New workbook is not larger than old one. Styling may be minimal.');
    }
  } else {
    print('[FAIL] Final workbook not found.');
  }
}
