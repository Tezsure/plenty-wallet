import 'package:get/get.dart';

import '../controllers/splash_page_controller.dart';

class SplashPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashPageController>(
      () => SplashPageController(),
    );
  }
}
