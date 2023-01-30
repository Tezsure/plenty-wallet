import 'package:get/get.dart';

import '../controllers/home_page_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    // if (!Get.find<HomePageController>().initialized) {
    Get.lazyPut<HomePageController>(
      () => HomePageController(),
    );
    // }
  }
}
