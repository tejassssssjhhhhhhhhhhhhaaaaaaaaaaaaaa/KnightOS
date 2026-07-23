import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class AndroidUpdateInstaller {
  const AndroidUpdateInstaller();

  Future<bool> launchApk(String apkUrl) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }

    final uri = Uri.parse(apkUrl);
    if (!await canLaunchUrl(uri)) {
      return false;
    }

    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<bool> openDownloadUrl(String apkUrl) async {
    if (Platform.isAndroid) {
      return launchApk(apkUrl);
    }
    return false;
  }
}
