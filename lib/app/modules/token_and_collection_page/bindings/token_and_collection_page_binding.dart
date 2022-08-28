import 'package:get/get.dart';

import '../controllers/token_and_collection_page_controller.dart';

class TokenAndCollectionPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenAndCollectionPageController>(
      () => TokenAndCollectionPageController(),
    );
  }
}
