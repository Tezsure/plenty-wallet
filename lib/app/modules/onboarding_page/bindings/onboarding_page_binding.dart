import 'package:get/get.dart';

import '../controllers/onboarding_page_controller.dart';

class OnboardingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingPageController>(
      () => OnboardingPageController(),
    );
  }
}
