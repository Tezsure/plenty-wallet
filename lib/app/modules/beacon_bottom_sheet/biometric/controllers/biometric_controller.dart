import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';

class BiometricController extends GetxController {
  var isBiometric = false.obs;
  AuthService authService = AuthService();
  @override
  void onInit() async {
    isBiometric.value = Get.arguments;
    if (isBiometric.value) {
      var isValid = await authService.verifyBiometric();
      if (isValid) {
        Get.back(result: true);
      }
    }
    super.onInit();
  }

  void usePasscode() async {
    isBiometric.value = false;
    var isValid = await Get.toNamed('/passcode-page', arguments: [
      true,
    ]);
    if (isValid == null) {
      return;
    }
    if (isValid) {
      Get.back(result: true);
    }
  }
}
