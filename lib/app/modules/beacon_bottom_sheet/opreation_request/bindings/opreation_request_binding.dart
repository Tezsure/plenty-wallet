import 'package:get/get.dart';

import '../controllers/opreation_request_controller.dart';

class OpreationRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpreationRequestController>(
      () => OpreationRequestController(),
    );
  }
}
