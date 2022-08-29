import 'package:get/get.dart';

import '../controllers/loading_page_controller.dart';

class LoadingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadingPageController>(
      () => LoadingPageController(),
    );
  }
}
