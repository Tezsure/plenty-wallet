import 'package:get/get.dart';

import '../controllers/passcode_page_controller.dart';

class PasscodePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasscodePageController>(
      () => PasscodePageController(),
    );
  }
}
