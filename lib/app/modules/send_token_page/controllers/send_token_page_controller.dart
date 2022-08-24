import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendTokenPageController extends GetxController {
  TextEditingController recipientController = TextEditingController();
  FocusNode recipientFocusNode = FocusNode();
  RxString amount = ''.obs;

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
