import 'package:get/get.dart';

import '../controllers/safety_reset_page_controller.dart';

class SafetyResetPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SafetyResetPageController>(
      () => SafetyResetPageController(),
    );
  }
}
