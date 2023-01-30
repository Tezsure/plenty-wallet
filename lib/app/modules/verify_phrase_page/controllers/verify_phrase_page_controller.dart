import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/verify_phrase_page/widgets/verify_phrase_success_sheet.dart';

class VerifyPhrasePageController extends GetxController {
  List<String> phrase1 = <String>[];
  List<String> phrase2 = <String>[];
  List<String> phrase3 = <String>[];
  List<String> get phraseKeys => [
        'Which word is the #2 word\nof your secret phrase?',
        'Which word is the #5 word\nof your secret phrase?',
        'Which word is the #12 word\nof your secret phrase?',
      ];
  List<List<String>> phraseList = [];
  final RxInt keyIndex = 0.obs;
  final RxInt? phraseIndex = 0.obs;
  final RxBool isPhraseSelected = false.obs;
  final RxBool isPhraseVerified = false.obs;
  final RxString selectedPhrase = ''.obs;
  final RxBool showError = false.obs;

  final RxBool secondPhrase = false.obs;
  final RxBool thirdPhrase = false.obs;
  List<String> listSeeds = <String>[];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // listSeeds = Get.arguments.toString().split(" ");
  }

  @override
  void onReady() {
    // TODO: implement onReady

    super.onReady();
  }

  void selectSecretPhrase({required int index}) {
    phraseIndex?.value = index;
    isPhraseSelected.value = true;
    selectedPhrase.value = phraseList[keyIndex.value].elementAt(index);
    if (thirdPhrase.value == true) {
      isPhraseVerified.value = true;
    }
  }

  void verifySecretPhrase() {
    if (keyIndex.value == 0 && selectedPhrase.value == listSeeds[1]) {
      keyIndex.value = 1;
      selectedPhrase.value = '';
      isPhraseSelected.value = false;
      showError.value = false;
      // secondPhrase.value = true;
    } else if (keyIndex.value == 1 && selectedPhrase.value == listSeeds[4]) {
      keyIndex.value = 2;
      selectedPhrase.value = '';
      isPhraseSelected.value = false;
      showError.value = false;
    } else if (keyIndex.value == 2 && selectedPhrase.value == listSeeds[11]) {
      String seedPhrase = [...phraseList.map((e) => e.join(" "))].join(" ");
      if (Get.isRegistered<SettingsPageController>()) {
        final settingsPageController = Get.find<SettingsPageController>();
        settingsPageController.markWalletAsBackedUp(seedPhrase);
      } else {
        final settingsPageController = Get.put(SettingsPageController());
        settingsPageController.markWalletAsBackedUp(seedPhrase);
      }

      Get
        ..back() // close current
        ..back() // close seeds
        ..back(); // close bottom sheet
      Get.bottomSheet(VerifyPhraseSuccessSheet(), isScrollControlled: true);
    } else {
      selectedPhrase.value = '';
      isPhraseSelected.value = false;
      showError.value = true;
      HapticFeedback.vibrate();
    }
    return;
    if (secondPhrase.value == false) {
      keyIndex.value = 1;
      selectedPhrase.value = '';
      isPhraseSelected.value = false;
      secondPhrase.value = true;
    } else if (thirdPhrase.value == false) {
      if (selectedPhrase.value == "spare") {
        keyIndex.value = 2;
        selectedPhrase.value = '';
        isPhraseSelected.value = false;
        showError.value = false;
        thirdPhrase.value = true;
        isPhraseVerified.value = false;
      } else {
        keyIndex.value = 1;
        selectedPhrase.value = '';
        isPhraseSelected.value = false;
        showError.value = true;
      }
    }
  }
}
