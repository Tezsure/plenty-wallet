import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DelegateWidgetController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final RxString bakerAddress = ''.obs;
  final RxInt selectedBaker = 0.obs;
  final RxBool isBakerAddressSelected = false.obs;
  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void onTextChanged(String value) {
    bakerAddress.value = value;
  }

  void onSelectedBakerChanged(int value) {
    selectedBaker.value = value;
    isBakerAddressSelected.value = true;
  }
}
