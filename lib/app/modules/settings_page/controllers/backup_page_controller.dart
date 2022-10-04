import 'dart:async';

import 'package:get/get.dart';

class BackupPageController extends GetxController {
  Timer timer = Timer(const Duration(seconds: 30), Get.back);

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
