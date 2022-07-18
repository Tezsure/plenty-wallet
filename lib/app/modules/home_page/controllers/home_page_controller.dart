import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/mock/mock_data.dart';

class HomePageController extends GetxController {
  HomePageController() {
    Get.offNamed(Routes.CREATE_WALLET_PAGE);
  }
  var currentAccountName = "Account 1".obs; // current selected account's name
  var currentAccountBalance =
      254.25548493832.obs; // current selected account's balacne

  var dappSearchTextController = TextEditingController()
      .obs; // text controller for search bar in dapp search widget

  var listOfTokens = MockData().listOfTokens.obs;

  var tezosHeadlineList = MockData().tezosHeadlineList.obs;

  var listOfNFTTokens = MockData().listOfNFTTokens.obs;
  var currentNFTIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    startNFTChangeTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  startNFTChangeTimer() {
    Future.delayed(Duration(seconds: 3), () {
      if (currentNFTIndex == listOfNFTTokens.length - 1) {
        currentNFTIndex.value = 0;
        startNFTChangeTimer();
      } else {
        currentNFTIndex.value++;
        startNFTChangeTimer();
      }
    });
  }
}
