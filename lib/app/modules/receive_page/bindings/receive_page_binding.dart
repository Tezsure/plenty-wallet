import 'package:get/get.dart';

import '../controllers/receive_page_controller.dart';

class ReceivePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceivePageController>(
      () => ReceivePageController(),
    );
  }
}
