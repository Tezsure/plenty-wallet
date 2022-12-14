import 'dart:async';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';

class BackupPageController extends GetxController {
  // static final operation = () {};
  static final operation = Get.back;
  Timer timer = Timer(const Duration(seconds: 30), operation);
  RxInt timeLeft = 30.obs;
  @override
  void onInit() async {
    /// TODO : Harsh
    // final screts = UserStorageService().readAccountSecrets(pkHash);
    // TODO: implement onInit
    super.onInit();
  }

  void setup() {
    timeLeft = 30.obs;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (timeLeft.value == 0) {
        timer.cancel();
        operation();
      } else {
        timeLeft.value = timeLeft.value - 1;
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
