import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BackupWalletController extends GetxController {
  //? Variables

  Rx<bool> phraseCopy = false.obs;

  //? FUNCTION
  List<String> seedPhrase = <String>[];

  @override
  Future<void> onInit() async {
    seedPhrase = (Get.arguments as String).split(" ");
    super.onInit();
  }

  Future<void> paste() async {
    await Clipboard.setData(
      ClipboardData(
        text: seedPhrase.join().toString(),
      ),
    ).whenComplete(() => phraseCopy.value = true);
  }
}
