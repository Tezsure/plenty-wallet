import 'dart:convert';

import 'package:beacon_flutter/models/beacon_request.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/widgets/account_selector/account_selector.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

class PairRequestController extends GetxController {
  final BeaconRequest beaconRequest = Get.arguments;

  final RxList<AccountModel> accountModels =
      Get.find<HomePageController>().userAccounts;

  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;
  final selectedAccount = 0.obs;

  changeAccount() async {
    final selectedIndex = await Get.bottomSheet(
      AccountSelector(
        accountModels: accountModels,
        index: selectedAccount.value,
      ),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      barrierColor: Colors.white.withOpacity(0.09),
      isScrollControlled: true,
    );
    if (selectedIndex != null) {
      selectedAccount.value = selectedIndex;
    }
  }

  accept() async {
    try {
    print("accept ${beaconRequest.request.toString()}");
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
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Error while accepting permission, $e',
          backgroundColor: ColorConst.Error, colorText: Colors.white);
    }
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
