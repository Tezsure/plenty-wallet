import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/controllers/import_wallet_page_controller.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';

class PasscodePageController extends GetxController {
  /// define whether the redirected from new wallet or to verify the passcode <br>
  /// which will decide to write new passcode or check the already stored passcode
  RxBool isToVerifyPassCode = false.obs;
  String? nextPageRoute;
  RxString confirmPasscode = "".obs;
  RxString enteredPassCode = "".obs;

  RxBool isPassCodeWrong = false.obs;

  /// This will check based on isToVerifyPassCode whether to redirect to next page or pop with return data<br>
  /// return data of pop will be whether the entered passcode is valid or not
  Future<void> checkOrWriteNewAndRedirectToNewPage(String passCode) async {
    AuthService authService = AuthService();
    var previousRoute = Get.previousRoute;
    if (isToVerifyPassCode.value) {
      /// verify the passcode here
      var checkPassCode = await AuthService().verifyPassCode(passCode);
      if (checkPassCode) {
        Get.offAllNamed(nextPageRoute!);
      } else {
        enteredPassCode.value = "";
        isPassCodeWrong.value = true;
        HapticFeedback.vibrate();
      }
    } else if (nextPageRoute != null &&
        nextPageRoute == Routes.BIOMETRIC_PAGE &&
        previousRoute == Routes.CREATE_WALLET_PAGE) {
      /// set a new passcode and redirect to biometric page if supported else redirect /create-profile-page
      await authService.setNewPassCode(passCode);
      var isBioSupported =
          await authService.checkIfDeviceSupportBiometricAuth();

      /// arguments here defines that whether it's from create new wallet or import new wallet
      Get.toNamed(
        isBioSupported ? Routes.BIOMETRIC_PAGE : Routes.CREATE_PROFILE_PAGE,
        arguments: isBioSupported
            ? [
                previousRoute,
                Routes.CREATE_PROFILE_PAGE,
              ]
            : [previousRoute],
      );
    } else if (nextPageRoute != null &&
        nextPageRoute == Routes.BIOMETRIC_PAGE &&
        previousRoute == Routes.IMPORT_WALLET_PAGE) {
      await authService.setNewPassCode(passCode);
      var isBioSupported =
          await authService.checkIfDeviceSupportBiometricAuth();
      ImportWalletPageController importWalletPageController =
          Get.find<ImportWalletPageController>();
      if (importWalletPageController.importWalletDataType ==
          ImportWalletDataType.mnemonic) {
        Get.toNamed(
            isBioSupported ? Routes.BIOMETRIC_PAGE : Routes.LOADING_PAGE,
            arguments: isBioSupported
                ? [
                    previousRoute,
                    Routes.LOADING_PAGE,
                  ]
                : [
                    'assets/create_wallet/lottie/wallet_success.json',
                    previousRoute,
                    Routes.HOME_PAGE,
                  ]);
      } else {
        Get.toNamed(
          isBioSupported ? Routes.BIOMETRIC_PAGE : Routes.CREATE_PROFILE_PAGE,
          arguments: isBioSupported
              ? [
                  previousRoute,
                  Routes.CREATE_PROFILE_PAGE,
                ]
              : [previousRoute],
        );
      }
    } else {
      /// if it's not to verify a passcode and not being redirected from create wallet page or import page<br>
      /// overwrite the new passcode and pop with value true

    }
  }

  verifyPassCodeOrBiomatrics() async {
    AuthService authService = AuthService();
    var isBioEnable = await authService.getBiometricAuth();
    if (isBioEnable) {
      bool result = await authService.verifyBiometric();
      if (result) {
        Get.offAllNamed(nextPageRoute!);
      }
    }
  }
}
