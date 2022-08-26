import 'package:get/get.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';

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
    listSeeds = Get.arguments.toString().split(" ");
    phrase1 = listSeeds.sublist(0, 4).toList();
    phrase2 = listSeeds.sublist(4, 8).toList();
    phrase3 = listSeeds.sublist(8).toList();
    phraseList = [phrase1, phrase2, phrase3];
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
      Get.back(); // close current
      Get.back(); // close seeds
      Get.back(); // close bottom sheet
    } else {
      selectedPhrase.value = '';
      isPhraseSelected.value = false;
      showError.value = true;
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
