import 'package:get/get.dart';

import '../controllers/nft_gallery_controller.dart';

class NftGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NftGalleryController>(
      () => NftGalleryController(),
    );
  }
}
