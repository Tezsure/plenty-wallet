import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';

class AccountsWidgetController extends GetxController {
  final List<String> imagePath = [
    'assets/svg/accounts/account_1.svg',
    'assets/svg/accounts/account_2.svg',
    'assets/svg/accounts/account_3.svg'
  ]; // Background Images for Accounts container

  final RxInt selectedAccountIndex = 0.obs; // Current Visible Account Container

  /// Change the current index to the new index of visible account container
  void onPageChanged(int index) {
    selectedAccountIndex.value = index;
  }

  /// add account functions
  TextEditingController accountNameController = TextEditingController();
  var currentSelectedType = AccountProfileImageType.assets;

  RxString selectedImagePath = "".obs;

  RxBool isPrimaryAccount = false.obs;
  RxBool isHiddenAccount = false.obs;

  initAddAccount() {
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
  }

  closeAddAccount() {
    accountNameController.clear();
  }
}
