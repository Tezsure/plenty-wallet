import 'package:get/get.dart';

import '../controllers/pair_request_controller.dart';

class PairRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PairRequestController>(
      () => PairRequestController(),
    );
  }
}
