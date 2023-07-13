import 'dart:convert';

import 'package:beacon_flutter/enums/enums.dart';
import 'package:beacon_flutter/models/beacon_request.dart';
import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';

import 'package:plenty_wallet/utils/constants/constants.dart';

class PayloadRequestController extends GetxController {
  final BeaconRequest beaconRequest = Get.arguments;

  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;

  final accountModel = Rxn<AccountModel>();

  @override
  void onInit() async {
    accountModel.value = Get.find<HomePageController>().userAccounts.firstWhere(
        (element) =>
            element.publicKeyHash == beaconRequest.request!.sourceAddress);
    if (accountModel.value == null) {
      beaconPlugin.signPayloadResponse(
        id: beaconRequest.request!.id!,
        signature: null,
      );
      Get.back();
      Get.snackbar('Error', 'Connect wallet not found',
          backgroundColor: ColorConst.Error, colorText: Colors.white);
    }
    super.onInit();
  }

  confirm() async {
    try {
      NaanAnalytics.logEvent(NaanAnalyticsEvents.DAPP_CLICK, param: {
        "type": beaconRequest.type!,
        "name": beaconRequest.peer?.name,
        "address": accountModel.value!.publicKeyHash
      });
      if (beaconRequest.request?.payload != null) {
        final Map response = await beaconPlugin.signPayloadResponse(
            id: beaconRequest.request!.id!,
            signature: Dartez.signPayload(
                signer: Dartez.createSigner((await UserStorageService()
                        .readAccountSecrets(
                            accountModel.value!.publicKeyHash!))!
                    .secretKey!),
                payload: beaconRequest.request!.payload!),
            type: SigningType.micheline);

        final bool success =
            json.decode(response['success'].toString()) as bool;

        if (success) {
          AppConstant.hapticFeedback();
          if (Get.isSnackbarOpen == true) {
            Get.close(1);
          } else {
            Get.back();
          }

/*           Get.snackbar(
            'Success',
            'Successfully signed payload',
            backgroundColor: ColorConst.Secondary,
            colorText: Colors.white,
          ); */
        } else {
          throw Exception('Error while Signing payload');
        }
      } else {
        throw Exception('Error while Signing payload');
      }
    } catch (e) {
      if (Get.isSnackbarOpen == true) {
        Get.close(1);
      } else {
        Get.back();
      }
/*       Get.snackbar('Error', '$e',
          backgroundColor: ColorConst.Error, colorText: Colors.white); */

      transactionStatusSnackbar(
          status: TransactionStatus.error,
          transactionAmount: "Error",
          tezAddress: e.toString());
    }
  }

  reject() {
    beaconPlugin.signPayloadResponse(
      id: beaconRequest.request!.id!,
      signature: null,
    );
    Get.back();
  }
}
