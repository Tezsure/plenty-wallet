import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/iaf/iaf_service.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/iaf/widgets/iaf_success_sheet.dart';
import 'package:plenty_wallet/utils/common_functions.dart';

class IAFController extends GetxController {
  final IAFService _iafService = IAFService();
  AccountModel selectedAccount;
  IAFController(this.selectedAccount);
  final TextEditingController emailController = TextEditingController();
  Rx<bool?> isVerified = null.obs;
  RxBool isButtonEnabled = false.obs;
  RxBool isLoading = false.obs;

  setUp(AccountModel selectedaccount) {
    selectedAccount = selectedaccount;
    isVerified = null.obs;
    isButtonEnabled.value = false;
    isLoading.value = false;
    emailController.clear();
  }

  onChange(String value) {
    isVerified = null.obs;

    isButtonEnabled.value = value.isEmail;
  }

  Future<void> verify() async {
    await checkEmailStatus();
  }

  Future<void> claim() async {
    isLoading.value = true;
    bool isClaimSuccess = await _iafService.claimNFT(
        emailController.text, selectedAccount.publicKeyHash!);
    isLoading.value = false;
    if (isClaimSuccess) {
      Get.back();
      CommonFunctions.bottomSheet(
        const IAFClaimSuccessSheet(),
      );
    }
  }

  Future<void> checkEmailStatus() async {
    isLoading.value = true;
    isVerified = (await _iafService.checkEmailStatus(
            emailController.text, selectedAccount.publicKeyHash!))
        .obs;
    isLoading.value = false;

    log("isVerified:$isVerified");
    isButtonEnabled.value = isVerified.value!;
  }
}
