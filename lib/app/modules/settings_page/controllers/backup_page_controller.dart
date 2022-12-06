import 'dart:async';

import 'package:get/get.dart';

class BackupPageController extends GetxController {
  static final operation = () {};
  // static final operation=Get.back;
  Timer timer = Timer(const Duration(seconds: 30), operation);

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
