import 'package:get/get.dart';

import '../controllers/create_profile_page_controller.dart';

class CreateProfilePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateProfilePageController>(
      () => CreateProfilePageController(),
    );
  }
}
