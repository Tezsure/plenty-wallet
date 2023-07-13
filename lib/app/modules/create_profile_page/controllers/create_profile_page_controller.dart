import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';

class CreateProfilePageController extends GetxController {
  String? previousRoute;
  FocusNode accountNameFocus = FocusNode();
  TextEditingController accountNameController =
      TextEditingController(text: 'Account 1');
  var currentSelectedType = AccountProfileImageType.assets;

  RxBool isContiuneButtonEnable = false.obs;

  RxString selectedImagePath = "".obs;

  @override
  void onInit() {
    super.onInit();
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
    accountNameFocus.requestFocus();
    try {
      if (Get.find<HomePageController>().initialized) {
        accountNameController.text =
            "Wallet ${Get.find<HomePageController>().userAccounts.isEmpty ? 1 : Get.find<HomePageController>().userAccounts.length + 1}";
      }
    } catch (e) {}
    isContiuneButtonEnable.value = true;
  }
}
