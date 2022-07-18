import 'package:get/get.dart';

import '../controllers/biometric_page_controller.dart';

class BiometricPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiometricPageController>(
      () => BiometricPageController(),
    );
  }
}
