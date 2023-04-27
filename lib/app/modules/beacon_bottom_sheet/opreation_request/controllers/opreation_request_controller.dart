import 'dart:convert';

import 'package:beacon_flutter/enums/enums.dart';
import 'package:beacon_flutter/models/beacon_request.dart';
import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/operation_service/operation_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_batch_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_model.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/biometric/views/biometric_view.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/models/transfer_model.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'dart:math';

import 'package:naan_wallet/utils/constants/constants.dart';

class OpreationRequestController extends GetxController {
  final BeaconRequest beaconRequest = Get.arguments;

  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;

  final Rx<bool> isBiometric = false.obs;

  final accountModels = Rxn<AccountModel>();

  final error = "".obs;

  final dollarPrice = 0.0.obs;
  bool getXtz = false;
  double xtzPrice = 0.0;
  RxMap<String, dynamic> operation = <String, dynamic>{}.obs;

  final fees = "calculating...".obs;
  List<TokenPriceModel> tokenPriceModels = <TokenPriceModel>[];
  RxList<TransferModel> transfers = <TransferModel>[].obs;
  int? callbackHash;
  @override
  void onInit() async {
    try {
      print(" req: ${beaconRequest.request}");
      isBiometric.value = await AuthService().getBiometricAuth();
      accountModels.value = Get.find<HomePageController>()
          .userAccounts
          .firstWhereOrNull((element) =>
              element.publicKeyHash == beaconRequest.request!.sourceAddress);

      callback(value) {
        if (!getXtz) {
          xtzPrice = value;
          var amount = (beaconRequest.operationDetails!
                      .map((e) => e.amount == null ? 0 : int.parse(e.amount!))
                      .reduce((int value, int element) => value + element) /
                  pow(10, 6))
              .toString();
          dollarPrice.value =
              dollarPrice.value + (double.parse(amount) * value);

          transfers.add(TransferModel(
              amount: amount,
              dollarAmount: (double.parse(amount) * value).toStringAsFixed(2),
              symbol: "tez"));
        }
        getXtz = true;
      }

      callbackHash = callback.hashCode;

      if (beaconRequest.operationDetails != null &&
          accountModels.value != null) {
        DataHandlerService()
            .renderService
            .xtzPriceUpdater
            .registerCallback(callback);

        tokenPriceModels =
            await DataHandlerService().renderService.getTokenPriceModels();

/*         tokenPriceModels.forEach((element) {
          print(
              "tokenPriceModels ${element.symbol} ${element.currentPrice} ${element.address} ${element.tokenId}");
        }); */
        if (beaconRequest.operationDetails![0].kind ==
            OperationKind.origination) {
          var operationModel = OperationModel(
              code: beaconRequest.operationDetails![0].code.toString(),
              storage: beaconRequest.operationDetails![0].storage.toString(),
              amount: double.parse(
                  beaconRequest.operationDetails![0].amount ?? "0"),
              keyStoreModel: KeyStoreModel(
                publicKey: (await UserStorageService().readAccountSecrets(
                        accountModels.value!.publicKeyHash!))!
                    .publicKey,
                secretKey: (await UserStorageService().readAccountSecrets(
                        accountModels.value!.publicKeyHash!))!
                    .secretKey,
                publicKeyHash: accountModels.value!.publicKeyHash!,
              ));

          var op = await OperationService().preApplyContractOrigination(
            operationModel,
            ServiceConfig.currentSelectedNode,
          );
          operation.value = op;
          fees.value =
              ((int.parse(op['gasEstimation']) / pow(10, 6)) * xtzPrice)
                  .toStringAsFixed(4);
          print("operation ${operation.toString()}");

          return;
        }

        for (var e in beaconRequest.operationDetails!) {
          if (e.entrypoint == "transfer") {
            try {
              parseFA12(e.parameters, e.destination);
            } catch (e) {
              print(e);
            }
            try {
              parseFA2(e.parameters, e.destination);
            } catch (e) {
              print(e);
            }
          }
        }

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

        var op = await OperationService().preApplyOperationBatch(
            operationModels,
            ServiceConfig.currentSelectedNode,
            KeyStoreModel(
              publicKey: (await UserStorageService()
                      .readAccountSecrets(accountModels.value!.publicKeyHash!))!
                  .publicKey,
              secretKey: (await UserStorageService()
                      .readAccountSecrets(accountModels.value!.publicKeyHash!))!
                  .secretKey,
              publicKeyHash: accountModels.value!.publicKeyHash!,
            ));
        operation.value = op;
        fees.value = ((int.parse(op['gasEstimation']) / pow(10, 6)) * xtzPrice)
            .toStringAsFixed(4);
        print("operation ${operation.toString()}");
      } else {
        error.value = "Operation details is null";
        fees.value = "0.0";
        throw Exception("Operation details is null");
      }
    } catch (e) {
      if (e.toString() ==
          "type 'String' is not a subtype of type 'int' of 'index'") {
        error.value = "Error: Low balance";
      } else {
        error.value = "Error: $e";
      }

      fees.value = "0.0";
      print("errorc $e");
      //throw Exception(e);
    }
    super.onInit();
  }

  confirm() async {
    try {
      AppConstant.hapticFeedback();
      AuthService authService = AuthService();
      bool isBioEnabled = await authService.getBiometricAuth();

      if (isBioEnabled) {
        final bioResult = await CommonFunctions.bottomSheet(
            const BiometricView(),
            settings: RouteSettings(arguments: isBioEnabled));
        if (bioResult == null) {
          return;
        }
        if (!bioResult) {
          return;
        }
      } else {
        var isValid = await Get.toNamed('/passcode-page', arguments: [
          true,
        ]);
        if (isValid == null) {
          return;
        }
        if (!isValid) {
          return;
        }
      }
      print("operation ${operation.toString()}");
      final txHash = await OperationService()
          .injectOperation(operation, ServiceConfig.currentSelectedNode);
      NaanAnalytics.logEvent(NaanAnalyticsEvents.DAPP_CLICK, param: {
        "txHash": txHash,
        "type": "transaction",
        "address": accountModels.value?.publicKeyHash,
        "transfers": transfers
            .map(
              (e) => {
                "amount": "${e.amount} ${e.symbol}",
                "dollar_amount": e.dollarAmount
              },
            )
            .toString(),
      });
      print("txHash $txHash");

      final Map response = await beaconPlugin.operationResponse(
        id: beaconRequest.request!.id!,
        transactionHash: txHash.toString().replaceAll('\n', ''),
      );

      final bool success = json.decode(response['success'].toString()) as bool;

      if (success) {
        Get.back();
/*         Get.snackbar('Opreation submitted', 'Opreation submitted successfully',
            backgroundColor: ColorConst.Secondary, colorText: Colors.white); */
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
    if (baseData is! Map) return data;
    if (!baseData.containsKey("args") && baseData.containsKey("bytes")) {
      if (baseData['bytes'].toString().startsWith("0x")) {
        baseData['bytes'] = baseData['bytes'].toString().substring(2);
        return jsonEncode(baseData);
      }
    }
    if (!baseData.containsKey("args") ||
        baseData['args'] is! List ||
        baseData['args'][0] is! Map) {
      return data;
    }
    for (var key in baseData['args'][0].keys) {
      if (key == 'expressions') {
        baseData['args'][0] = baseData['args'][0][key];
      }
    }
    return jsonEncode(baseData);
  }

  parseFA12(parameters, destination) async {
    try {
      var param = jsonDecode(Dartez.normalizePrimitiveRecordOrder(
          formatParameters(jsonEncode(parameters is List
              ? parameters
              : parameters.containsKey("expressions")
                  ? parameters['expressions']
                  : parameters))));
      var x = param["args"];
      var from, to, amount;
      if (x[0]["string"] is String) {
        from = x[0]["string"];
      }
      var y = x[1]["args"];
      if (y[0]["string"] is String) {
        to = y[0]["string"];
      }
      if (y[1]["int"] is String) {
        amount = y[1]["int"];
      }
      if (from != null && to != null && amount != null) {
/*         print(
            "Selected FA1 from: $from, to: $to, amount: $amount, tokenAddress: $destination"); */

        TokenPriceModel tokenPriceModel = tokenPriceModels.firstWhere(
            (element) =>
                element.tokenAddress.toString().toLowerCase() ==
                destination.toString().toLowerCase());

        transfers.add(TransferModel(
            thumbnailUri: iconBuilder(
                tokenPriceModel.thumbnailUri, destination.toString()),
            symbol: tokenPriceModel.symbol,
            amount: (double.parse(amount) /
                    pow(10, int.parse(tokenPriceModel.decimals.toString())))
                .toStringAsFixed(2),
            dollarAmount: (double.parse((double.parse(amount) /
                            pow(10,
                                int.parse(tokenPriceModel.decimals.toString())))
                        .toStringAsFixed(2)) *
                    (tokenPriceModel.currentPrice ?? 0))
                .toStringAsFixed(2)));

        dollarPrice.value = dollarPrice.value +
            (double.parse((double.parse(amount) /
                        pow(10, int.parse(tokenPriceModel.decimals.toString())))
                    .toStringAsFixed(2)) *
                (tokenPriceModel.currentPrice ?? 0));
        return;
      }
/*       print(
          "not selected FA1 from: $from, to: $to, amount: $amount, tokenAddress: $destination"); */
    } catch (e) {
      throw Exception(e);
    }
  }

  parseFA2(parameters, destination) async {
    try {
      var param = jsonDecode(Dartez.normalizePrimitiveRecordOrder(
          formatParameters(jsonEncode(parameters is List
              ? parameters
              : parameters.containsKey("expressions")
                  ? parameters['expressions']
                  : parameters))));
      var from, to, amount, tokenId;
      for (var x in param) {
        if (x["args"][0]["string"] is String) {
          from = x["args"][0]["string"];
        }
        for (var y in x["args"][1]) {
          if (y["args"][0]["string"] is String) {
            to = y["args"][0]["string"];
          }
          if (y["args"][1]["args"][0]["int"] is String) {
            tokenId = y["args"][1]["args"][0]["int"];
          }
          if (y["args"][1]["args"][1]["int"] is String) {
            amount = y["args"][1]["args"][1]["int"];
          }
        }
      }
      if (from != null && to != null && amount != null && tokenId != null) {
        var tokenPriceModel = tokenPriceModels.firstWhere((element) =>
            element.tokenAddress.toString().toLowerCase() ==
                destination.toString().toLowerCase() &&
            element.tokenId == tokenId.toString());
        transfers.add(TransferModel(
            thumbnailUri: iconBuilder(
                tokenPriceModel.thumbnailUri, destination.toString()),
            symbol: tokenPriceModel.symbol,
            amount: (double.parse(amount) /
                    pow(10, int.parse(tokenPriceModel.decimals.toString())))
                .toStringAsFixed(2),
            dollarAmount: (double.parse((double.parse(amount) /
                            pow(10,
                                int.parse(tokenPriceModel.decimals.toString())))
                        .toStringAsFixed(2)) *
                    (tokenPriceModel.currentPrice ?? 0))
                .toStringAsFixed(2)));
        dollarPrice.value = dollarPrice.value +
            (double.parse((double.parse(amount) /
                        pow(10, int.parse(tokenPriceModel.decimals.toString())))
                    .toStringAsFixed(2)) *
                (tokenPriceModel.currentPrice ?? 0));
        /*        print(
            "Selected fa2 from: $from, to: $to, amount: $amount, tokenId: $tokenId, tokenAddress: $destination"); */
        return;
      }
/*       print(
          "not selected fa2 from: $from, to: $to, amount: $amount, tokenAddress: $destination"); */
    } catch (e) {
      throw Exception(e);
    }
  }

 static String iconBuilder(thumbnailUri, contract) {
    if (thumbnailUri != null &&
        thumbnailUri.isNotEmpty &&
        thumbnailUri.startsWith("ipfs")) {
      return 'https://cloudflare-ipfs.com/ipfs/${thumbnailUri!.substring(7)}';
    } else if (thumbnailUri != null &&
        thumbnailUri!.isNotEmpty &&
        thumbnailUri!.startsWith("http")) {
      return thumbnailUri;
    } else {
      return 'https://services.tzkt.io/v1/avatars/$contract';
    }
  }

  @override
  void onClose() {
    super.onClose();

    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .removeCallback(callbackHash);
    print("Closed operation callback");
  }
}
