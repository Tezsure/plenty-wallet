import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendPageController extends GetxController {
  TextEditingController recipientController = TextEditingController();
  FocusNode recipientFocusNode = FocusNode();
  RxString amount = ''.obs;
  RxBool isNFTPage = false.obs;

  void onNFTClick() {
    isNFTPage.value = true;
  }

  void onTokenClick() {
    isNFTPage.value = false;
  }

  @override
  void onReady() {
    recipientController = TextEditingController();
    super.onReady();
  }

  @override
  void onInit() {
    recipientFocusNode.requestFocus();
    super.onInit();
  }

  @override
  void onClose() {
    recipientFocusNode
      ..unfocus()
      ..dispose();
    recipientController.dispose();
    super.onClose();
  }
}
