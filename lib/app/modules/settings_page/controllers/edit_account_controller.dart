import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';

class EditAccountPageController extends GetxController {
  TextEditingController accountNameController = TextEditingController();
  var currentSelectedType = AccountProfileImageType.assets;

  RxString selectedImagePath = "".obs;

  RxBool isPrimaryAccount = false.obs;
  RxBool isHiddenAccount = false.obs;

  @override
  void onInit() {
    super.onInit();
    accountNameController.text = '';
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
  }
}
