import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/models/account_model.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';

class ImportWalletPageController extends GetxController {
  //? VARIABLES
  Rx<bool> showSuccessAnimation = false.obs; // to show success animation
  Rx<TextEditingController> phraseTextController = TextEditingController().obs;
  Rx<String> phraseText = "".obs; // to store phrase text
  RxList<AccountModel> accounts = List.generate(
      4, (index) => AccountModel(address: "tezdnenfjeb", balance: 60)).obs;
  // accounts imported;
  RxList<AccountModel> selectedAccounts =
      <AccountModel>[].obs; // accounts selected;
  RxBool isExpanded = false.obs;

  //? FUNCTION

  /// To paste the phrase from clipboard
  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      phraseTextController.value.text = cdata.text!;
      phraseText.value = cdata.text!;
    }
  }

  /// To show wallet success animation and redirect to backup wallet page
  void showAnimation() {
    showSuccessAnimation.value = true;
    Get.back();
    Future.delayed(const Duration(milliseconds: 3500), () {
      showSuccessAnimation.value = false;
      Get.offAllNamed(Routes.HOME_PAGE, arguments: [true]);
    });
  }

  /// To assign the phrase text to the phrase text variable
  void onTextChange(String value) => phraseText.value = value;

  /// load acounts
  void showMoreAccounts() {
    if (accounts.length + 4 < 100) {
      for (var i = 0; i < 4; i++) {
        accounts.add(
          AccountModel(address: "tezdnenfjeb", balance: 60),
        );
      }
    } else if (accounts.length < 100) {
      for (var i = 0; i < 2; i++) {
        accounts.add(
          AccountModel(address: "tezdnenfjeb", balance: 60),
        );
      }
    }
  }

  

  @override
  void dispose() {
    phraseTextController.value.dispose();
    super.dispose();
  }
}
