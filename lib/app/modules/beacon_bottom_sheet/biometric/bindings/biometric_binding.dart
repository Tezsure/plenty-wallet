import 'package:get/get.dart';

import '../controllers/biometric_controller.dart';

class BiometricBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiometricController>(
      () => BiometricController(),
    );
  }
}
