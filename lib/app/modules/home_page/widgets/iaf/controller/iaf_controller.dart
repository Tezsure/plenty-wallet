import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';

class IAFController extends GetxController {
  AccountModel selectedAccount;
  IAFController(this.selectedAccount);
  final TextEditingController emailController = TextEditingController();
  RxBool isverified = false.obs;
  onChange(String value) {
    if (value.isEmail) {
      isverified.value = true;
    } else {
      isverified.value = false;
    }
  }

  String? validate(String? value) {
    if (value?.isEmail ?? false) {
      return null;
    } else {
      return "unverified";
    }
  }
}
