import 'package:get/get.dart';

import '../controllers/story_page_controller.dart';

class StoryPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoryPageController>(
      () => StoryPageController(),
    );
  }
}
