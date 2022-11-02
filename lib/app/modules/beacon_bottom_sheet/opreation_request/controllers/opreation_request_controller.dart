import 'dart:convert';

import 'package:beacon_flutter/models/beacon_request.dart';
import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/operation_service/operation_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_batch_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'dart:math';

class OpreationRequestController extends GetxController {
  final BeaconRequest beaconRequest = Get.arguments;

  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;

  Rx<AccountModel>? accountModels;

  final error = "".obs;

  final dollarPrice = 0.0.obs;

  RxMap<String, dynamic> operation = <String, dynamic>{}.obs;

  final amount = "0".obs;

  final fees = "0.023".obs;

  @override
  void onInit() async {
    try {
      accountModels = Get.find<HomePageController>()
          .userAccounts
          .firstWhere((element) =>
              element.publicKeyHash == beaconRequest.request!.sourceAddress)
          .obs;

      if (beaconRequest.operationDetails != null && accountModels != null) {
        DataHandlerService()
            .renderService
            .xtzPriceUpdater
            .registerCallback((value) {
          dollarPrice.value = value;

          amount.value = (beaconRequest.operationDetails!
                      .map((e) => e.amount == null ? 0 : int.parse(e.amount!))
                      .reduce((int value, int element) => value + element) /
                  pow(10, 6))
              .toString();
          print("amount $amount fees $fees dollar $dollarPrice");
        });

        var operationModels = beaconRequest.operationDetails!.map((e) {
          return OperationModelBatch(
              destination: e.destination!,
              amount: e.amount == null ? 0.0 : double.parse(e.amount!),
              entrypoint: e.entrypoint!,
              parameters: Dartez.normalizePrimitiveRecordOrder(
                  formatParameters(jsonEncode(e.parameters is List
                      ? e.parameters
                      : e.parameters.containsKey("expressions")
                          ? e.parameters['expressions']
                          : e.parameters))));
        }).toList();

        operation.value = await OperationService().preApplyOperationBatch(
            operationModels,
            ServiceConfig.currentSelectedNode,
            KeyStoreModel(
              publicKey: (await UserStorageService()
                      .readAccountSecrets(accountModels!.value.publicKeyHash!))!
                  .publicKey,
              secretKey: (await UserStorageService()
                      .readAccountSecrets(accountModels!.value.publicKeyHash!))!
                  .secretKey,
              publicKeyHash: accountModels!.value.publicKeyHash!,
            ));
        print("operation ${operation.toString()}");
      } else {
        error.value = "Operation details is null";
        throw Exception("Operation details is null");
      }
    } catch (e) {
      error.value = "Error: $e";
      print("errorc $e");
    }
    super.onInit();
  }

  confirm() async {
    try {
      final txHash = await OperationService()
          .injectOperation(operation, ServiceConfig.currentSelectedNode);

      print("txHash $txHash");

      final Map response = await beaconPlugin.operationResponse(
        id: beaconRequest.request!.id!,
        transactionHash: txHash.toString().replaceAll('\n', ''),
      );

      final bool success = json.decode(response['success'].toString()) as bool;

      if (success) {
        Get.back();
        Get.snackbar('Opreation submitted', 'Opreation submitted successfully',
            backgroundColor: ColorConst.Secondary, colorText: Colors.white);
      } else {
        throw "Operation response failed";
      }
    } catch (e) {
      print("errora $e");
      Get.snackbar('Error', 'Error while injecting operation',
          backgroundColor: ColorConst.Error, colorText: Colors.white);
      Get.back();
    }
  }

  reject() {
    beaconPlugin.operationResponse(
      id: beaconRequest.request!.id!,
      transactionHash: null,
    );
    Get.back();
  }

  formatParameters(String data) {
    var baseData = jsonDecode(data);
    if (!(baseData is Map)) return data;
    if (!baseData.containsKey("args") && baseData.containsKey("bytes")) {
      if (baseData['bytes'].toString().startsWith("0x")) {
        baseData['bytes'] = baseData['bytes'].toString().substring(2);
        return jsonEncode(baseData);
      }
    }
    if (!baseData.containsKey("args") ||
        !(baseData['args'] is List) ||
        !(baseData['args'][0] is Map)) {
      return data;
    }
    for (var key in baseData['args'][0].keys) {
      if (key == 'expressions') {
        baseData['args'][0] = baseData['args'][0][key];
      }
    }
    return jsonEncode(baseData);
  }
}
