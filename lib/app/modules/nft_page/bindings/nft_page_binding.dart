import 'package:get/get.dart';

import '../controllers/nft_page_controller.dart';

class NftPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NftPageController>(
      () => NftPageController(),
    );
  }
}
