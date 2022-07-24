import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ImportWalletPageController extends GetxController {
  //? VARIABLES

  Rx<TextEditingController> phraseTextController = TextEditingController().obs;
  Rx<String> phraseText = "".obs;

  //? FUNCTION

  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      phraseTextController.value.text = cdata.text!;
      phraseText.value = cdata.text!;
    }
  }

  void onTextChange(String value) => phraseText.value = value;

  @override
  void dispose() {
    phraseTextController.value.dispose();
    super.dispose();
  }
}
