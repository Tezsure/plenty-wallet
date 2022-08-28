import 'package:get/get.dart';

import '../controllers/contact_page_controller.dart';

class ContactPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactPageController>(
      () => ContactPageController(),
    );
  }
}
