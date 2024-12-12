import 'dart:developer';

import 'package:flutter/services.dart';

class AppInfoHelper {
  static const MethodChannel _channel = MethodChannel('com.expressErp.appInfo');

  static Future<String?> getAppInfo() async {
    try {
      final result = await _channel.invokeMethod<String>('getAppInfo');
      return result;
    } catch (e) {
      log("Error fetching app info: $e");
      return null;
    }
  }
}
