import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';

import '../../home_page/controllers/home_page_controller.dart';

class ManageAccountPageController extends GetxController {
  final homePageController = Get.find<HomePageController>();
  Rx<ScrollController> scrollcontroller = ScrollController().obs;

  RxBool isScrolling = false.obs;
  RxBool isRearranging = false.obs;

  void makePrimaryAccount(int index) {
    if (index == 0) return;
    for (var element in homePageController.userAccounts) {
      element.isAccountPrimary = false;
    }
    AccountModel account = homePageController.userAccounts[index];
    account.isAccountPrimary = true;
    homePageController.userAccounts
      ..removeAt(index)
      ..insert(0, account);
  }

  void removeAccount(int index) {
    if (homePageController.userAccounts.length > 1) {
      homePageController
        ..userAccounts.removeAt(index)
        ..userAccounts[0].isAccountPrimary = true;
    } else {
      print("You can't delete your only account");
    }
  }
}
