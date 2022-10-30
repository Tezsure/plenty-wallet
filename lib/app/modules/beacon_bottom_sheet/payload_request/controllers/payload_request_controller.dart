import 'dart:convert';

import 'package:beacon_flutter/enums/enums.dart';
import 'package:beacon_flutter/models/beacon_request.dart';
import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/payload_request/views/payload_request_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

import 'package:dartez/src/soft-signer/soft_signer.dart' show SignerCurve;

class PayloadRequestController extends GetxController {
  final BeaconRequest beaconRequest = Get.arguments;
  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;
  RxList<AccountModel> accountModels = <AccountModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    accountModels.value =
        await UserStorageService().getAllAccount(isSecretDataRequired: true);
  }

  confirm() async {
    try {
      final AccountSecretModel? accountSecret = await UserStorageService()
          .readAccountSecrets(accountModels[0].publicKeyHash!);
      if (accountSecret != null && beaconRequest.request?.payload != null) {
        final signer = Dartez.createSigner(
            Dartez.writeKeyWithHint(
                accountSecret.secretKey,
                accountSecret.publicKeyHash!.startsWith("tz2")
                    ? 'spsk'
                    : 'edsk'),
            signerCurve: accountSecret.publicKeyHash!.startsWith("tz2")
                ? SignerCurve.SECP256K1
                : SignerCurve.ED25519);

        String base58signature = Dartez.signPayload(
            signer: signer, payload: beaconRequest.request!.payload!);

        final Map response = await beaconPlugin.signPayloadResponse(
            id: beaconRequest.request!.id!,
            signature: base58signature,
            type: SigningType.micheline);

        final bool success =
            json.decode(response['success'].toString()) as bool;

        if (success) {
          if (Get.isSnackbarOpen == true) {
            Get.close(1);
          } else {
            Get.back();
          }

          Get.snackbar(
            'Success',
            'Successfully signed payload',
            backgroundColor: ColorConst.Secondary,
            colorText: Colors.white,
          );
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
      Get.snackbar('Error', '$e',
          backgroundColor: ColorConst.Error, colorText: Colors.white);
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
