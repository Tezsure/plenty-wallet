import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';

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
    isContiuneButtonEnable.value = true;
  }
}
