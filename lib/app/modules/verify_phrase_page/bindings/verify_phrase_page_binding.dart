import 'package:get/get.dart';

import '../controllers/verify_phrase_page_controller.dart';

class VerifyPhrasePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyPhrasePageController>(
      () => VerifyPhrasePageController(),
    );
  }
}
