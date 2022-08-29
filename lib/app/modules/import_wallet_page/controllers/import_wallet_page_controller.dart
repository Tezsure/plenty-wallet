import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/data/services/wallet_service/wallet_service.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';

class ImportWalletPageController extends GetxController {
  //? VARIABLES
  Rx<bool> showSuccessAnimation = false.obs; // to show success animation
  Rx<TextEditingController> phraseTextController = TextEditingController().obs;
  Rx<String> phraseText = "".obs; // to store phrase text
  RxList<AccountModel> generatedAccounts = <AccountModel>[].obs;
  // accounts imported;
  RxList<AccountModel> selectedAccounts =
      <AccountModel>[].obs; // accounts selected;
  RxBool isExpanded = false.obs;

  ImportWalletDataType? importWalletDataType;

  //? FUNCTION

  /// To paste the phrase from clipboard
  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      checkImportType(cdata.text!);
      phraseTextController.value.text = cdata.text!;
      phraseText.value = cdata.text!;
    }
  }

  // /// To show wallet success animation and redirect to backup wallet page
  // void showAnimation() {
  //   showSuccessAnimation.value = true;
  //   Get.back();
  //   Future.delayed(const Duration(milliseconds: 3500), () {
  //     showSuccessAnimation.value = false;
  //     Get.offAllNamed(Routes.HOME_PAGE, arguments: [true]);
  //   });
  // }

  /// To assign the phrase text to the phrase text variable
  void onTextChange(String value) {
    checkImportType(value);
    phraseText.value = value;
  }

  /// define based on phraseText.value that if it's mnemonic, private key or watch address
  void checkImportType(value) => importWalletDataType = value.startsWith('edsk')
      ? ImportWalletDataType.privateKey
      : value.startsWith("tz1") ||
              value.startsWith("tz2") ||
              value.startsWith("tz3")
          ? ImportWalletDataType.watchAddress
          : value.split(" ").length == 12
              ? ImportWalletDataType.mnemonic
              : ImportWalletDataType.none;

  Future<void> redirectBasedOnImportWalletType() async {
    if (importWalletDataType == ImportWalletDataType.privateKey ||
        importWalletDataType == ImportWalletDataType.watchAddress) {
      Get.toNamed(
        Routes.PASSCODE_PAGE,
        arguments: [
          false,
          Routes.BIOMETRIC_PAGE,
        ],
      );
    } else if (importWalletDataType == ImportWalletDataType.mnemonic) {
      var accountLength = (await UserStorageService().getAllAccount()).length;

      for (var i = 0; i < selectedAccounts.length; i++) {
        selectedAccounts[i] = selectedAccounts[i]
          ..name = "Account ${accountLength + i}";
      }
      selectedAccounts.value = selectedAccounts.value;
      Get.back();
      Get.toNamed(
        Routes.PASSCODE_PAGE,
        arguments: [
          false,
          Routes.BIOMETRIC_PAGE,
        ],
      );
    }
  }

  Future<void> genAndLoadMoreAccounts(int startIndex, int size) async {
    if (startIndex == 0) generatedAccounts.value = <AccountModel>[];
    WalletService()
        .genAccountFromMnemonic(phraseText.value.trim(), startIndex, size)
        .then(generatedAccounts.addAll);
  }

  /// load acounts
  void showMoreAccounts() {
    if (generatedAccounts.length + 4 < 100) {
      for (var i = 0; i < 4; i++) {
        // accounts.add(
        //   AccountModel(address: "tezdnenfjeb", balance: 60),
        // );
      }
    } else if (generatedAccounts.length < 100) {
      for (var i = 0; i < 2; i++) {
        // accounts.add(
        //   AccountModel(address: "tezdnenfjeb", balance: 60),
        // );
      }
    }
  }

  @override
  void dispose() {
    phraseTextController.value.dispose();
    super.dispose();
  }
}
