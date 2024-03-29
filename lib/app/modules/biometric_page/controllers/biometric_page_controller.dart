import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:plenty_wallet/app/modules/import_wallet_page/controllers/import_wallet_page_controller.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/common_functions.dart';

import '../../home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';

class BiometricPageController extends GetxController {
  /// define whether the redirected from new wallet or to verify the biometric <br>
  /// which will decide to write new biometric or check the already stored biometric
  String? nextPageRoute;
  String? previousRoute;

  /// This will check based on isToVerifyBiometric whether to redirect to next page or pop with return data<br>
  /// return data of pop will be whether the entered biometric is valid or not
  Future<void> checkOrWriteNewAndRedirectToNewPage(bool isEnable) async {
    /// require biometric here if isEnable
    AuthService authService = AuthService();
    if (isEnable) {
      NaanAnalytics.logEvent(NaanAnalyticsEvents.BIOMETRIC_ENABLE);
      var isValid = await authService.verifyBiometric();
      if (!isValid) return;
    }
    NaanAnalytics.logEvent(NaanAnalyticsEvents.BIOMETRIC_SKIP);
    await authService.setBiometricAuth(isEnable);

    /// if biometric verified then redirect and set bio enable disable
    if (nextPageRoute != null &&
        nextPageRoute == Routes.CREATE_PROFILE_PAGE &&
        previousRoute == Routes.CREATE_WALLET_PAGE) {
      /// arguments here defines that whether it's from create new wallet or import new wallet
      Get.toNamed(
        Routes.CREATE_PROFILE_PAGE,
        arguments: [previousRoute],
      );
    } else if (nextPageRoute != null &&
        (nextPageRoute == Routes.CREATE_PROFILE_PAGE ||
            nextPageRoute == Routes.LOADING_PAGE) &&
        previousRoute == Routes.IMPORT_WALLET_PAGE) {
      ImportWalletPageController importWalletPageController =
          Get.find<ImportWalletPageController>();
      if (importWalletPageController.importWalletDataType ==
          ImportWalletDataType.mnemonic) {
        Get.toNamed(Routes.LOADING_PAGE, arguments: [
          'assets/create_wallet/lottie/loading_animation.json',
          previousRoute,
          Routes.HOME_PAGE,
        ]);
      } else {
        Get.toNamed(
          Routes.CREATE_PROFILE_PAGE,
          arguments: [previousRoute],
        );
      }
    } else if (nextPageRoute != null &&
        nextPageRoute == Routes.ADD_NEW_WALLET) {
      Get.back();
      CommonFunctions.bottomSheet(AddNewAccountBottomSheet(), fullscreen: true)
          .whenComplete(() {
        Get.find<AccountsWidgetController>().resetCreateNewWallet();
      });
    } else {
      if (Get.previousRoute == Routes.PASSCODE_PAGE &&
          nextPageRoute == Routes.HOME_PAGE) {
        Get.offAllNamed(Routes.HOME_PAGE);
      }

      /// if it's not to verify a biometric and not being redirected from create wallet page or import page<br>
      /// overwrite the new biometric and pop with value true
    }
  }
}
