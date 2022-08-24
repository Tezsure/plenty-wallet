import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ReceivePageController extends GetxController {
  RxBool isCopied = false.obs;

  copyAddress(String address) {
    Clipboard.setData(ClipboardData(text: address));
    isCopied.value = true;
  }
}
