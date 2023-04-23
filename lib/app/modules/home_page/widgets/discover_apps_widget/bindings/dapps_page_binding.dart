import 'package:get/get.dart';

import '../controllers/dapps_page_controller.dart';

class DappsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DappsPageController>(
      () => DappsPageController(),
    );
  }
}
