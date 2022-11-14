import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/data/services/wallet_service/wallet_service.dart';
import 'package:naan_wallet/app/data/services/web3auth_services/web3AuthController.dart';
import 'package:naan_wallet/app/modules/create_profile_page/controllers/create_profile_page_controller.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/controllers/import_wallet_page_controller.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';

class LoadingPageController extends GetxController {
  /// loading process will be dynamic function which will be define from the args
  // ignore: prefer_typing_uninitialized_variables
  String? fromRoute;
  String? nextRoute;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var args = Get.arguments as List<dynamic>;
    fromRoute = args[1] as String;
    nextRoute = args[2] as String?;
    startLodingProcess();
  }

  Future<void> startLodingProcess() async {
    String mnemonic = "";
    if (fromRoute == Routes.CREATE_WALLET_PAGE) {
      CreateProfilePageController createWalletPageController =
          Get.find<CreateProfilePageController>();
      Web3AuthController? web3authController;
      try {
        web3authController = Get.find<Web3AuthController>();
      } catch (e) {}
      if (web3authController != null && web3authController.privateKey != null) {
        await Future.wait([
          WalletService().importWalletUsingPrivateKey(
            web3authController.privateKey!,
            createWalletPageController.accountNameController.text,
            createWalletPageController.currentSelectedType,
            createWalletPageController.selectedImagePath.value,
          ),
          Future.delayed(const Duration(seconds: 3))
        ]);
      } else {
        var createWalletResult = await Future.wait([
          WalletService().createNewAccount(
            createWalletPageController.accountNameController.text,
            createWalletPageController.currentSelectedType,
            createWalletPageController.selectedImagePath.value,
          ),
          Future.delayed(const Duration(seconds: 3))
        ]);
        mnemonic = (createWalletResult[0] as AccountModel)
            .accountSecretModel!
            .seedPhrase!;
      }
    } else if (fromRoute == Routes.IMPORT_WALLET_PAGE) {
      ImportWalletPageController importWalletPageController =
          Get.find<ImportWalletPageController>();

      if (importWalletPageController.importWalletDataType ==
          ImportWalletDataType.privateKey) {
        CreateProfilePageController createWalletPageController =
            Get.find<CreateProfilePageController>();
        // import wallet using private key
        await Future.wait([
          WalletService().importWalletUsingPrivateKey(
            importWalletPageController.phraseText.value.trim(),
            createWalletPageController.accountNameController.text,
            createWalletPageController.currentSelectedType,
            createWalletPageController.selectedImagePath.value,
          ),
          Future.delayed(const Duration(seconds: 3))
        ]);
      } else if (importWalletPageController.importWalletDataType ==
          ImportWalletDataType.mnemonic) {
        // mnemonic accounts
        await Future.wait([
          UserStorageService().writeNewAccount(
            [
              ...importWalletPageController.selectedAccountsTz1,
              ...importWalletPageController.selectedAccountsTz2
            ],
            false,
            true,
          ),
          Future.delayed(const Duration(seconds: 3)),
        ]);
      } else {
        // watch account
        CreateProfilePageController createWalletPageController =
            Get.find<CreateProfilePageController>();
        await Future.wait([
          WalletService().importWatchAddress(
            importWalletPageController.phraseText.value.trim(),
            createWalletPageController.accountNameController.text,
            createWalletPageController.currentSelectedType,
            createWalletPageController.selectedImagePath.value,
          ),
          Future.delayed(const Duration(seconds: 3))
        ]);
      }
    }

    /// once the animation and loadingProcess get finished redirected to next route based on if it's home page or something else
    if (nextRoute == Routes.HOME_PAGE) {
      // DataHandlerService().forcedUpdateData();
      Get.offAllNamed(
        Routes.HOME_PAGE,
        arguments: mnemonic.isNotEmpty
            ? [
                true,
                mnemonic,
              ]
            : [
                false,
              ],
      );
    } else if (nextRoute == null && fromRoute == Routes.IMPORT_WALLET_PAGE) {
      // close loading, create profile, import wallet
      Get
        ..back()
        ..back()
        ..back();
    } else {
      Get.toNamed(nextRoute!);
    }
  }
}
