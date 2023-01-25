import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/iaf/widgets/iaf_success_sheet.dart';

class IAFController extends GetxController {
  AccountModel selectedAccount;
  IAFController(this.selectedAccount);
  final TextEditingController emailController = TextEditingController();
  RxBool isverified = false.obs;
  onChange(String value) {
    if (value.isEmail) {
      // isverified.value = true;
    } else {
      // isverified.value = false;
    }
  }

  verify() {
    isverified.value = true;
  }

  claim() {
    Get.back();
    Get.bottomSheet(IAFClaimSuccessSheet(), isScrollControlled: true);
    isverified.value = false;
  }
}
