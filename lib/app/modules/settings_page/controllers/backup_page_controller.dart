import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackupPageController extends GetxController {
  Timer? timer;
  RxInt timeLeft = 30.obs;

  void setup(BuildContext context) {
    timeLeft = 30.obs;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value == 0) {
        timer.cancel();
        Navigator.pop(context);
      } else {
        timeLeft.value = timeLeft.value - 1;
      }
    });
  }

  @override
  void dispose() async {
    timer?.cancel();
    debugPrint("BackupPageController dispose enabling ss");
    super.dispose();
  }
}
