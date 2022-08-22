import 'package:get/get.dart';

import '../controllers/send_token_page_controller.dart';

class SendTokenPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendTokenPageController>(
      () => SendTokenPageController(),
    );
  }
}
