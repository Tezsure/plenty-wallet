import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BackupWalletController extends GetxController {
  //? Variables

  Rx<bool> phraseCopy = false.obs;

  //? FUNCTION
  List<String> seedPhrase = <String>[];

  Future<void> onInit() async {
    seedPhrase = (Get.arguments as String).split(" ");
  }

  Future<void> paste() async {
    await Clipboard.setData(
      ClipboardData(
        text: seedPhrase.join().toString(),
      ),
    ).whenComplete(() => phraseCopy.value = true);
  }
}
