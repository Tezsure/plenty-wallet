import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../mock/mock_data.dart';

class BackupWalletController extends GetxController {
  //? Variables

  Rx<bool> phraseCopy = false.obs;

  //? FUNCTION

  Future<void> paste() async {
    await Clipboard.setData(
            ClipboardData(text: MockData.secretPhrase.toString()))
        .whenComplete(() => phraseCopy.value = true);
  }
}
