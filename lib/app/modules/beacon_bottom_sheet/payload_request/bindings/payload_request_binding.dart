import 'package:get/get.dart';

import '../controllers/payload_request_controller.dart';

class PayloadRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayloadRequestController>(
      () => PayloadRequestController(),
    );
  }
}
