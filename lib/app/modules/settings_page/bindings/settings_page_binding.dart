import 'package:get/get.dart';

import '../controllers/settings_page_controller.dart';

class SettingsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsPageController>(
      () => SettingsPageController(),
    );
  }
}
