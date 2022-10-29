import 'dart:convert';

import 'package:beacon_flutter/models/beacon_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

class PairRequestController extends GetxController {
  final BeaconRequest beaconRequest = Get.arguments;
  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;
  RxList<AccountModel> accountModels = <AccountModel>[].obs;
  @override
  void onInit() async {
    super.onInit();
    accountModels.value =
        await UserStorageService().getAllAccount(isSecretDataRequired: true);
  }

  accept() async {
    try {
      final AccountSecretModel? accountSecret = await UserStorageService()
          .readAccountSecrets(accountModels[0].publicKeyHash!);
      if (accountSecret != null) {
        final Map response = await beaconPlugin.permissionResponse(
          id: beaconRequest.request!.id!,
          publicKey: accountSecret.publicKey, // publicKey of crypto account
          address:
              accountSecret.publicKeyHash, // walletAddress of crypto account
        );

        final bool success =
            json.decode(response['success'].toString()) as bool;

        if (success) {
          Get.back();
          Get.snackbar('Connected', 'Connected to ${beaconRequest.peer?.name}',
              backgroundColor: ColorConst.Secondary, colorText: Colors.white);
        } else {
          Get.back();
          Get.snackbar('Error', 'Error while accepting permission',
              backgroundColor: ColorConst.Error, colorText: Colors.white);
        }
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
