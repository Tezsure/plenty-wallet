import 'dart:io';
import 'package:safe_device/safe_device.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ios_security_suite/flutter_ios_security_suite.dart';

class ReService {
  Future<bool> checkIfDeviceRunningSercure() async {
    if (kDebugMode) return true;

    if (Platform.isIOS) {
      final FlutterIosSecuritySuite iosSecuritySuite =
          FlutterIosSecuritySuite();

      bool isJailbroken = (await iosSecuritySuite.amIJailbroken()) ?? false;
      bool amIDebugged = (await iosSecuritySuite.amIDebugged()) ?? false;
      bool amIReverseEngineered =
          (await iosSecuritySuite.amIReverseEngineered()) ?? false;

      if (isJailbroken || amIDebugged || amIReverseEngineered) {
        return false;
      }
    }

    if (Platform.isAndroid) {
      bool isJailbroken = await SafeDevice.isJailBroken;

      if (isJailbroken) {
        return false;
      }
    }

    return true;
  }
}
