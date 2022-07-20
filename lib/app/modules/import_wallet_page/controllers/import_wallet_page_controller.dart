import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ImportWalletPageController extends GetxController {
  //? VARIABLES

  final phraseTextController = TextEditingController().obs;

  //? FUNCTION

   paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      phraseTextController.value.text = cdata.text!;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    phraseTextController.value.dispose();
    super.dispose();
  }
}
