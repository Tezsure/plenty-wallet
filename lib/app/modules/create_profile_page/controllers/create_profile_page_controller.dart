import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/create_profile_page/views/profile_success_animation_view.dart';

class CreateProfilePageController extends GetxController {
  final isWalletCreated = false.obs;

  /// To show wallet success animation and redirect to backup wallet page
  void onWalletSuccess() {
    isWalletCreated.value = true;
    Future.delayed(const Duration(milliseconds: 3500),
        () => Get.to(() => const ProfileSuccessAnimationView())).whenComplete(
      () => isWalletCreated.value = false,
    );
  }
}
