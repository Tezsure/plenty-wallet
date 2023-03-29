import 'package:get/get.dart';

import '../controllers/backup_wallet_controller.dart';

class BackupWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BackupWalletController>(
      () => BackupWalletController(),
    );
  }
}
