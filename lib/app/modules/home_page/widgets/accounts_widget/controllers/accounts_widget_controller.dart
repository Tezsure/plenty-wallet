import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountsWidgetController extends GetxController {
  ScrollController? scrollController;
  RxList accountsList =
      (List.generate(5, (index) => index, growable: true)).obs;

  final RxInt selectedAccountIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }
}
