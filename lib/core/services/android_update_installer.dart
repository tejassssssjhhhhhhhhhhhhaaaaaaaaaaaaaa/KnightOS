import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';

class AndroidUpdateInstaller {
  const AndroidUpdateInstaller();

  Future<bool> launchApk(String filePath) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }

    final exists = await File(filePath).exists();
    if (!exists) {
      debugPrint(
        'APK installer skipped because the file does not exist: $filePath',
      );
      return false;
    }

    final fileSize = await File(filePath).length();
    if (fileSize < 4096) {
      debugPrint(
        'APK installer skipped because the file is too small: $fileSize bytes',
      );
      return false;
    }

    try {
      final result = await OpenFilex.open(
        filePath,
        type: 'application/vnd.android.package-archive',
      );
      final launched = result.type == ResultType.done;
      if (!launched) {
        debugPrint(
          'APK installer returned a non-success result: ${result.type}',
        );
      }
      return launched;
    } catch (error) {
      debugPrint('Unable to launch APK installer: $error');
      return false;
    }
  }

  Future<bool> installApk(String filePath) => launchApk(filePath);
}
