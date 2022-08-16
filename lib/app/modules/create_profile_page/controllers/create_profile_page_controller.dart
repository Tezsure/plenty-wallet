import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class CreateProfilePageController extends GetxController {
  final isWalletCreated = false.obs;

  /// To show wallet success animation and redirect to backup wallet page
  void onWalletSuccess() {
    isWalletCreated.value = true;
    Future.delayed(const Duration(milliseconds: 3500),
            () => Get.offAllNamed(Routes.HOME_PAGE, arguments: [true]))
        .whenComplete(
      () => isWalletCreated.value = false,
    );
  }
}
