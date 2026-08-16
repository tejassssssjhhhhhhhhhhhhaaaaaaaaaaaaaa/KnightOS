import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  var bytes = File('../KNIGHTOS_V6_EXCEL_EDITION_MASTER_FINAL.xlsx').readAsBytesSync();
  var archive = ZipDecoder().decodeBytes(bytes);

  for (var file in archive) {
    if (file.name == 'xl/styles.xml') {
      var content = String.fromCharCodes(file.content);
      if (content.contains('rgb=\"none\"')) {
        print('[REPAIR] Found invalid color \"none\" in styles.xml. Repairing...');
        content = content.replaceAll('rgb=\"none\"', 'rgb=\"00000000\"');
        file.content = content.codeUnits;
      }
    }
  }

  var encoder = ZipEncoder();
  var newBytes = encoder.encode(archive);
  if (newBytes != null) {
    File('../KNIGHTOS_V6_EXCEL_EDITION_REPAIRED.xlsx').writeAsBytesSync(newBytes);
    print('[SUCCESS] XML integrity repair complete.');
  }
}
