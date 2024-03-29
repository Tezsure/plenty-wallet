import 'dart:convert';

import 'package:beacon_flutter/models/beacon_request.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/beacon_bottom_sheet/widgets/account_selector/account_selector.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';

class PairRequestController extends GetxController {
  final BeaconRequest beaconRequest = Get.arguments;
  final HomePageController homePageController = Get.find<HomePageController>();
  final RxList<AccountModel> accountModels = <AccountModel>[].obs;

  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;
  final selectedAccount = 0.obs;

  @override
  onInit() {
    super.onInit();
    accountModels.value = homePageController.userAccounts
        .where((p0) => p0.isWatchOnly == false)
        .toList();
    if (homePageController
        .userAccounts[homePageController.selectedIndex.value].isWatchOnly) {
      selectedAccount.value = 0;
    } else {
      selectedAccount.value = accountModels.indexWhere((element) =>
          element.publicKeyHash ==
          homePageController
              .userAccounts[homePageController.selectedIndex.value]
              .publicKeyHash);
    }
  }

  changeAccount() async {
    final selectedIndex = await CommonFunctions.bottomSheet(
      AccountSwitchSelector(
        accountModels: accountModels,
        index: selectedAccount.value,
      ),
    );
    if (selectedIndex != null) {
      selectedAccount.value = selectedIndex;
    }
  }

  accept() async {
    AuthService auth = AuthService();

    bool result = await auth.verifyBiometricOrPassCode();
    if (result) {
      final Map response = await beaconPlugin.permissionResponse(
        id: beaconRequest.request!.id!,
        publicKey: (await UserStorageService().readAccountSecrets(
                accountModels[selectedAccount.value].publicKeyHash!))!
            .publicKey, // publicKey of crypto account
        address: accountModels[selectedAccount.value]
            .publicKeyHash, // walletAddress of crypto account
      );

      final bool success = json.decode(response['success'].toString()) as bool;

      if (success) {
        Get.back();
/*         Get.snackbar('Connected', 'Connected to ${beaconRequest.peer?.name}',
            backgroundColor: ColorConst.Secondary, colorText: Colors.white); */
      } else {
        Get.back();
        Get.snackbar('Error', 'Error while accepting permission',
            backgroundColor: ColorConst.Error, colorText: Colors.white);
      }
    }
    // try {

    // } catch (e) {
    //   Get.back();
    //   Get.snackbar('Error', 'Error while accepting permission, $e',
    //       backgroundColor: ColorConst.Error, colorText: Colors.white);
    // }
  }

  reject() async {
    await beaconPlugin.permissionResponse(
      id: beaconRequest.request!.id!,
      publicKey: null,
      address: null,
    );
    Get.back();
  }
}
