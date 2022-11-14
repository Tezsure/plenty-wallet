import 'package:get/get.dart';

import '../controllers/dapp_browser_controller.dart';

class DappBrowserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DappBrowserController>(
      () => DappBrowserController(),
    );
  }
}
