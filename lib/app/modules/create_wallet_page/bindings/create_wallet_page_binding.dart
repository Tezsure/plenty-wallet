import 'package:get/get.dart';

import '../controllers/create_wallet_page_controller.dart';

class CreateWalletPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateWalletPageController>(
      () => CreateWalletPageController(),
    );
  }
}
