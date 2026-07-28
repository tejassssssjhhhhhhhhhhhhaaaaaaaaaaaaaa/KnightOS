import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NonWebStorage {
  const NonWebStorage();

  Future<File> getFile(String fileName) async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}${Platform.pathSeparator}$fileName');
  }
}
