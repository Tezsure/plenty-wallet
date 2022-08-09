import 'package:get/get.dart';

class VerifyPhrasePageController extends GetxController {
  List<String> get phrase1 => ['food', 'expose', 'demand', 'human'];
  List<String> get phrase2 => ['food', 'awake', 'spare', 'matter'];
  List<String> get phrase3 => ['food', 'time', 'demand', 'human'];
  List<String> get phraseKeys => [
        'Which word is the #2 word\nof your secret phrase?',
        'Which word is the #5 word\nof your secret phrase?',
        'Which word is the #12 word\nof your secret phrase?',
      ];
  List<List<String>> get phraseList => [phrase1, phrase2, phrase3];
  final RxInt keyIndex = 0.obs;
  final RxInt? phraseIndex = 0.obs;
  final RxBool isPhraseSelected = false.obs;
  final RxBool isPhraseVerified = false.obs;
  final RxString selectedPhrase = ''.obs;
  final RxBool showError = false.obs;

  final RxBool secondPhrase = false.obs;
  final RxBool thirdPhrase = false.obs;

  void selectSecretPhrase({required int index}) {
    phraseIndex?.value = index;
    isPhraseSelected.value = true;
    selectedPhrase.value = phraseList[keyIndex.value].elementAt(index);
  }

  void verifySecretPhrase() {
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
        isPhraseVerified.value = true;
      } else {
        keyIndex.value = 1;
        selectedPhrase.value = '';
        isPhraseSelected.value = false;
        showError.value = true;
      }
    }
  }
}
