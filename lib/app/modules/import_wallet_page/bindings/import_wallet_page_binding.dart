import 'package:get/get.dart';

import '../controllers/import_wallet_page_controller.dart';

class ImportWalletPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportWalletPageController>(
      () => ImportWalletPageController(),
    );
  }
}
