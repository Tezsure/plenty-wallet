import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dartez/models/key_store_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/helpers/on_going_tx_helper.dart';
import 'package:plenty_wallet/app/data/services/operation_service/operation_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/operation_batch_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:plenty_wallet/app/modules/dapp_browser/controllers/dapp_browser_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/buy_nft_success_sheet.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/fees_summary.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/review_nft.dart';
import 'package:plenty_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:plenty_wallet/app/modules/wert/views/wert_browser_view.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:simple_gql/simple_gql.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyNFTController extends GetxController {
  final selectedToken = Rxn<AccountTokenModel>(null);
  String url = "";

  List<String> mainUrl = [];
  final selectedNFT = Rxn<NftTokenModel?>();
  final RxBool loading = true.obs;
  RxString priceInToken = ''.obs;

  RxMap<String, String> fees = <String, String>{
    "networkFee": "calculating...",
    "interfaceFee": "calculating...",
    "totalFee": "calculating...",
    "totalFeeInTez": "calculating...",
  }.obs;

  final List<String> displayCoins = [
    "tez",
    'USDt',
    'uUSD',
    'kUSD',
    'EURL',
    "ctez",
  ];

  final RxDouble xtzPrice = 0.0.obs;
  RxList accountTokens = <AccountTokenModel>[].obs;

  RxMap<String, dynamic> operation = <String, dynamic>{}.obs;
  final error = "".obs;

  void selectMethod(AccountTokenModel token,
      {String senderAddress = ""}) async {
    if (selectedNFT.value == null) return;
    try {
      selectedToken.value = token;
      final accountToken = Get.find<AccountSummaryController>();
      Get.back();
      CommonFunctions.bottomSheet(
        ReviewNFTSheet(
          senderAddress: senderAddress,
        ),
      );
      print("selected token: ${token.symbol}");
      if (token.symbol!.toLowerCase() == "tez".toLowerCase()) {
        priceInToken.value =
            ((int.parse(selectedNFT.value!.lowestAsk) / 1e6) * 1.01).toString();
      } else {
        priceInToken.value =
            (((int.parse(selectedNFT.value!.lowestAsk) / 1e6) * 1.05) /
                    (double.parse(token.currentPrice.toString())))
                .toString();
      } // todo check calculation

      print("price in token: ${priceInToken.value}");
      if (token.symbol!.toLowerCase() == "tez".toLowerCase()) {
        print("tezos balance: ${token.balance.toString()}");

        if (double.parse(token.balance.toString()) <
            double.parse(priceInToken.value)) {
          fees.value = <String, String>{
            "networkFee": "0.0",
            "interfaceFee": "0.0",
            "totalFee": "0.0",
            "totalFeeInTez": "0.0",
          };
          error.value =
              "Insufficient Balance, You don't have enough ${token.symbol} to buy this NFT";

          return;
        }
        print(
            "amount : ${(double.parse(priceInToken.value) * 1e6).ceilToDouble().toStringAsFixed(0)}");
        List<OperationModelBatch> opreateList = [
          OperationModelBatch(
              destination: "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef",
              amount: (double.parse(priceInToken.value) * 1e6).ceilToDouble(),
              entrypoint: "purchaseToken",
              parameters:
                  """{"prim": "Pair","args": [{"int": "${selectedNFT.value!.tokenId}"},{"prim": "Pair","args": [{"int": "${selectedNFT.value!.lowestAsk}"},{"string": "${accountToken.selectedAccount.value.publicKeyHash!}"}]}]}"""),
        ];
        operation.value = await OperationService().preApplyOperationBatch(
          opreateList,
          ServiceConfig.currentSelectedNode,
          KeyStoreModel(
            publicKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .publicKey,
            secretKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .secretKey,
            publicKeyHash: accountToken.selectedAccount.value.publicKeyHash!,
          ),
        );
        String networkFee =
            ((int.parse(operation['gasEstimation']) / pow(10, 6)) *
                    accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        String interfaceFee =
            (((int.parse(selectedNFT.value!.lowestAsk) / 1e6) *
                        accountToken.xtzPrice.value) /
                    100)
                .toStringAsFixed(4); //todo 1% fee for now

        String totalFee =
            (double.parse(networkFee) + double.parse(interfaceFee))
                .toStringAsFixed(4);

        String totalFeeInTez =
            (double.parse(totalFee) / accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        fees.value = <String, String>{
          "networkFee": networkFee,
          "interfaceFee": interfaceFee,
          "totalFee": totalFee,
          "totalFeeInTez": totalFeeInTez,
        };

        loading.value = false;
      } else if (token.symbol == "USDt") {
        //check user balance
        print("USDt balance: ${token.balance.toString()}");

        if (double.parse(token.balance.toString()) <
            double.parse(priceInToken.value)) {
          fees.value = <String, String>{
            "networkFee": "0.0",
            "interfaceFee": "0.0",
            "totalFee": "0.0",
            "totalFeeInTez": "0.0",
          };
          error.value =
              "Insufficient Balance, You don't have enough ${token.symbol} to buy this NFT";

          return;
        }
        List<OperationModelBatch> opreateList = [
          OperationModelBatch(
              destination: "KT1XnTn74bUtxHfDtBmm2bGZAQfhPbvKWR8o",
              amount: 0,
              entrypoint: "transfer",
              parameters:
                  """[ { "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, [ { "prim": "Pair", "args": [ { "string": "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken.value) * 1e6).toStringAsFixed(0)}" } ] } ] } ] ] } ]"""),
          OperationModelBatch(
              destination: "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef",
              amount: 0,
              entrypoint: "routerSwap",
              parameters:
                  """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1D1NcffeDR3xQ75fUFoJXZzD6WQp96Je3L" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${selectedNFT.value!.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken.value) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.tokenId}" }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.lowestAsk}" }, { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" } ] } ] } ] }"""),
        ];
        operation.value = await OperationService().preApplyOperationBatch(
          opreateList,
          ServiceConfig.currentSelectedNode,
          KeyStoreModel(
            publicKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .publicKey,
            secretKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .secretKey,
            publicKeyHash: accountToken.selectedAccount.value.publicKeyHash!,
          ),
        );
        String networkFee =
            ((int.parse(operation['gasEstimation']) / pow(10, 6)) *
                    accountToken.xtzPrice.value)
                .toStringAsFixed(4);
        // print(operation["opPair"].toString());
        String interfaceFee =
            (((int.parse(selectedNFT.value!.lowestAsk) / 1e6) *
                        accountToken.xtzPrice.value) /
                    100)
                .toStringAsFixed(4); //todo 1% fee for now

        String totalFee =
            (double.parse(networkFee) + double.parse(interfaceFee))
                .toStringAsFixed(4);

        String totalFeeInTez =
            (double.parse(totalFee) / accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        fees.value = <String, String>{
          "networkFee": networkFee,
          "interfaceFee": interfaceFee,
          "totalFee": totalFee,
          "totalFeeInTez": totalFeeInTez,
        };

        loading.value = false;
      } else if (token.symbol == "uUSD") {
        //check user balance
        print("uUSD balance: ${token.balance.toString()}");

        if (double.parse(token.balance.toString()) <
            double.parse(priceInToken.value)) {
          fees.value = <String, String>{
            "networkFee": "0.0",
            "interfaceFee": "0.0",
            "totalFee": "0.0",
            "totalFeeInTez": "0.0",
          };
          error.value =
              "Insufficient Balance, You don't have enough ${token.symbol} to buy this NFT";

          return;
        }
        List<OperationModelBatch> opreateList = [
          OperationModelBatch(
              destination: "KT1XRPEPXbZK25r3Htzp2o1x7xdMMmfocKNW",
              amount: 0,
              entrypoint: "transfer",
              parameters:
                  """[ { "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, [ { "prim": "Pair", "args": [ { "string": "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken.value) * 1e12).toStringAsFixed(0)}" } ] } ] } ] ] } ]"""),
          OperationModelBatch(
              destination: "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef",
              amount: 0,
              entrypoint: "routerSwap",
              parameters:
                  """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1Ji4hVDeQ5Ru7GW1Tna9buYSs3AppHLwj9" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1UsSfaXyqcjSVPeiD7U1bWgKy3taYN7NWY" }, { "int": "2" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1Dhy1gVW3PSC9cms9QJ7xPMPPpip2V9aA6" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "2" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${selectedNFT.value!.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken.value) * 1e12).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.tokenId}" }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.lowestAsk}" }, { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" } ] } ] } ] }"""),
        ];
        operation.value = await OperationService().preApplyOperationBatch(
          opreateList,
          ServiceConfig.currentSelectedNode,
          KeyStoreModel(
            publicKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .publicKey,
            secretKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .secretKey,
            publicKeyHash: accountToken.selectedAccount.value.publicKeyHash!,
          ),
        );
        String networkFee =
            ((int.parse(operation['gasEstimation']) / pow(10, 6)) *
                    accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        String interfaceFee =
            (((int.parse(selectedNFT.value!.lowestAsk) / 1e6) *
                        accountToken.xtzPrice.value) /
                    100)
                .toStringAsFixed(4); //todo 1% fee for now

        String totalFee =
            (double.parse(networkFee) + double.parse(interfaceFee))
                .toStringAsFixed(4);

        String totalFeeInTez =
            (double.parse(totalFee) / accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        fees.value = <String, String>{
          "networkFee": networkFee,
          "interfaceFee": interfaceFee,
          "totalFee": totalFee,
          "totalFeeInTez": totalFeeInTez,
        };

        loading.value = false;
      } else if (token.symbol == "kUSD") {
        //check user balance
        print("kUSD balance: ${token.balance.toString()}");

        if (double.parse(token.balance.toString()) <
            double.parse(priceInToken.value)) {
          fees.value = <String, String>{
            "networkFee": "0.0",
            "interfaceFee": "0.0",
            "totalFee": "0.0",
            "totalFeeInTez": "0.0",
          };
          error.value =
              "Insufficient Balance, You don't have enough ${token.symbol} to buy this NFT";

          return;
        }
        List<OperationModelBatch> opreateList = [
          OperationModelBatch(
              destination: "KT1K9gCRgaLRFKTErYt1wVxA3Frb9FjasjTV",
              amount: 0,
              entrypoint: "transfer",
              parameters:
                  """{ "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, { "prim": "Pair", "args": [ { "string": "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef" }, { "int": "${(double.parse(priceInToken.value) * 1e18).toStringAsFixed(0)}" } ] } ] }"""),
          OperationModelBatch(
              destination: "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef",
              amount: 0,
              entrypoint: "routerSwap",
              parameters:
                  """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1HgFcDE8ZXNdT1aXXKpMbZc6GkUS2VHiPo" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1UsSfaXyqcjSVPeiD7U1bWgKy3taYN7NWY" }, { "int": "2" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1Dhy1gVW3PSC9cms9QJ7xPMPPpip2V9aA6" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "2" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${selectedNFT.value!.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken.value) * 1e18).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.tokenId}" }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.lowestAsk}" }, { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" } ] } ] } ] }"""),
        ];
        operation.value = await OperationService().preApplyOperationBatch(
          opreateList,
          ServiceConfig.currentSelectedNode,
          KeyStoreModel(
            publicKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .publicKey,
            secretKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .secretKey,
            publicKeyHash: accountToken.selectedAccount.value.publicKeyHash!,
          ),
        );
        String networkFee =
            ((int.parse(operation['gasEstimation']) / pow(10, 6)) *
                    accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        String interfaceFee =
            (((int.parse(selectedNFT.value!.lowestAsk) / 1e6) *
                        accountToken.xtzPrice.value) /
                    100)
                .toStringAsFixed(4); //todo 1% fee for now

        String totalFee =
            (double.parse(networkFee) + double.parse(interfaceFee))
                .toStringAsFixed(4);

        String totalFeeInTez =
            (double.parse(totalFee) / accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        fees.value = <String, String>{
          "networkFee": networkFee,
          "interfaceFee": interfaceFee,
          "totalFee": totalFee,
          "totalFeeInTez": totalFeeInTez,
        };

        loading.value = false;
      } else if (token.symbol == "EURL") {
        //check user balance
        print("EURL balance: ${token.balance.toString()}");

        if (double.parse(token.balance.toString()) <
            double.parse(priceInToken.value)) {
          fees.value = <String, String>{
            "networkFee": "0.0",
            "interfaceFee": "0.0",
            "totalFee": "0.0",
            "totalFeeInTez": "0.0",
          };
          error.value =
              "Insufficient Balance, You don't have enough ${token.symbol} to buy this NFT";

          return;
        }
        List<OperationModelBatch> opreateList = [
          OperationModelBatch(
              destination: "KT1JBNFcB5tiycHNdYGYCtR3kk6JaJysUCi8",
              amount: 0,
              entrypoint: "transfer",
              parameters:
                  """[ { "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, [ { "prim": "Pair", "args": [ { "string": "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken.value) * 1e6).toStringAsFixed(0)}" } ] } ] } ] ] } ]"""),
          OperationModelBatch(
              destination: "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef",
              amount: 0,
              entrypoint: "routerSwap",
              parameters:
                  """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1LqEgLikLE2obnyzgPJA6vMtnnG5agXVCn" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${selectedNFT.value!.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken.value) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.tokenId}" }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.lowestAsk}" }, { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" } ] } ] } ] }"""),
        ];
        operation.value = await OperationService().preApplyOperationBatch(
          opreateList,
          ServiceConfig.currentSelectedNode,
          KeyStoreModel(
            publicKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .publicKey,
            secretKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .secretKey,
            publicKeyHash: accountToken.selectedAccount.value.publicKeyHash!,
          ),
        );
        String networkFee =
            ((int.parse(operation['gasEstimation']) / pow(10, 6)) *
                    accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        String interfaceFee =
            (((int.parse(selectedNFT.value!.lowestAsk) / 1e6) *
                        accountToken.xtzPrice.value) /
                    100)
                .toStringAsFixed(4); //todo 1% fee for now

        String totalFee =
            (double.parse(networkFee) + double.parse(interfaceFee))
                .toStringAsFixed(4);

        String totalFeeInTez =
            (double.parse(totalFee) / accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        fees.value = <String, String>{
          "networkFee": networkFee,
          "interfaceFee": interfaceFee,
          "totalFee": totalFee,
          "totalFeeInTez": totalFeeInTez,
        };

        loading.value = false;
      } else if (token.symbol == "ctez") {
        //check user balance
        print("ctez balance: ${token.balance.toString()}");

        if (double.parse(token.balance.toString()) <
            double.parse(priceInToken.value)) {
          fees.value = <String, String>{
            "networkFee": "0.0",
            "interfaceFee": "0.0",
            "totalFee": "0.0",
            "totalFeeInTez": "0.0",
          };
          error.value =
              "Insufficient Balance, You don't have enough ${token.symbol} to buy this NFT";

          return;
        }
        List<OperationModelBatch> opreateList = [
          OperationModelBatch(
              destination: "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4",
              amount: 0,
              entrypoint: "transfer",
              parameters:
                  """{ "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, { "prim": "Pair", "args": [ { "string": "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef" }, { "int": "${(double.parse(priceInToken.value) * 1e6).toStringAsFixed(0)}" } ] } ] }"""),
          OperationModelBatch(
              destination: "KT1KSYWH1Vn5K2GnkzDTdDXoF6njjZVoajef",
              amount: 0,
              entrypoint: "routerSwap",
              parameters:
                  """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${selectedNFT.value!.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken.value) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.tokenId}" }, { "prim": "Pair", "args": [ { "int": "${selectedNFT.value!.lowestAsk}" }, { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" } ] } ] } ] }"""),
        ];
        operation.value = await OperationService().preApplyOperationBatch(
          opreateList,
          ServiceConfig.currentSelectedNode,
          KeyStoreModel(
            publicKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .publicKey,
            secretKey: (await UserStorageService().readAccountSecrets(
                    accountToken.selectedAccount.value.publicKeyHash!))!
                .secretKey,
            publicKeyHash: accountToken.selectedAccount.value.publicKeyHash!,
          ),
        );
        String networkFee =
            ((int.parse(operation['gasEstimation']) / pow(10, 6)) *
                    accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        String interfaceFee =
            (((int.parse(selectedNFT.value!.lowestAsk) / 1e6) *
                        accountToken.xtzPrice.value) /
                    100)
                .toStringAsFixed(4); //todo 1% fee for now

        String totalFee =
            (double.parse(networkFee) + double.parse(interfaceFee))
                .toStringAsFixed(4);

        String totalFeeInTez =
            (double.parse(totalFee) / accountToken.xtzPrice.value)
                .toStringAsFixed(4);

        fees.value = <String, String>{
          "networkFee": networkFee,
          "interfaceFee": interfaceFee,
          "totalFee": totalFee,
          "totalFeeInTez": totalFeeInTez,
        };

        loading.value = false;
      }

      //print("NFT Price in Token: $priceInToken.value ${token.symbol}");
    } catch (e) {
      error.value = "Error: $e";
      fees.value = fees.value = <String, String>{
        "networkFee": "0.0",
        "interfaceFee": "0.0",
        "totalFee": "0.0",
        "totalFeeInTez": "0.0",
      };

      print("errorc $e");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getNFTdata();

    final controller = Get.find<AccountSummaryController>();
    xtzPrice.value = controller.xtzPrice.value;
    await controller.fetchAllTokens();
    for (int index = 0; index < displayCoins.length; index++) {
      try {
        final token = controller.tokensList.firstWhereOrNull((p0) =>
            displayCoins[index].toLowerCase() == p0.symbol!.toLowerCase());

        var accountToken = controller.userTokens.firstWhereOrNull((p0) =>
            displayCoins[index].toLowerCase() == p0.symbol!.toLowerCase());
        if (token != null && accountToken == null) {
          accountToken = AccountTokenModel(
              name: token.name!,
              symbol: token.symbol!,
              iconUrl: token.thumbnailUri,
              balance: 0,
              currentPrice: token.currentPrice,
              contractAddress: token.tokenAddress!,
              tokenId: token.tokenId!,
              decimals: token.decimals!);
        }

        if (displayCoins[index].toLowerCase() == "tez") {
          accountToken = controller.userTokens.firstWhereOrNull(
                  (element) => element.symbol!.toLowerCase() == "tez") ??
              AccountTokenModel(
                  name: "Tezos",
                  symbol: "tez",
                  iconUrl: "assets/tezos_logo.png",
                  balance: 0,
                  currentPrice: controller.xtzPrice.value,
                  contractAddress: "xtz",
                  tokenId: "0",
                  decimals: 6);
        }

        if (accountToken != null) {
          accountTokens.add(accountToken);
        }
      } catch (e) {
        print("=============================$e");
      }
    }
  }

  getNFTdata() async {
    try {
      try {
        DappBrowserController dappBrowserController =
            Get.find<DappBrowserController>();
        url = dappBrowserController.url.value;
      } catch (e) {
        url = Get.arguments;
      }

      mainUrl = url
          .toString()
          .replaceFirst("https://objkt.com/asset/", '')
          .split("/");
      var response;
      if (mainUrl[0].startsWith('KT1')) {
        response = await GQLClient(
          'https://data.objkt.com/v3/graphql',
        ).query(
          query: r'''
          query NftDetails($address: String!, $tokenId: String!) {
            token(where: {token_id: {_eq: $tokenId}, fa_contract: {_eq: $address}}) {
              description
              name
              fa_contract
              thumbnail_uri
              listings(limit: 1,where: {status: {_eq: "active"}}, order_by: {price: asc}) {
                bigmap_key
                price
              }
            }
          }
      ''',
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      } else {
        response = await GQLClient(
          'https://data.objkt.com/v3/graphql',
        ).query(
          query: r'''
            query NftDetails($address: String!, $tokenId: String!) {
              token(where: {token_id: {_eq: $tokenId}, fa: {path: {_eq: $address}}}) {
                description
                listings(limit: 1, where: {status: {_eq: "active"}}, order_by: {price: asc}) {
                  bigmap_key
                  price
                }
                name
                thumbnail_uri
                fa_contract
              }
            }
      ''',
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      }
      print("nft response ${response}");
      selectedNFT.value = NftTokenModel(
          tokenId: response.data["token"][0]["listings"][0]["bigmap_key"]
              .toString(), //cheat just for this module( Assiging buyId to tokenId)
          artifactUri: response.data["token"][0]["thumbnail_uri"],
          lowestAsk:
              response.data["token"][0]["listings"][0]["price"].toString(),
          name: response.data["token"][0]["name"],
          description: response.data["token"][0]["description"],
          faContract: response.data["token"][0]["fa_contract"]);
    } catch (e) {
      print(e);
    }
  }

  void buyWithCreditCard() async {
    print("buy with credit card");
    if (selectedNFT.value == null) return;
    Get.back();
/*     Get.bottomSheet(
      const DappBrowserView(
        tagString: "2",
      ),
      settings: RouteSettings(
        arguments:
            ,
      ),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: const Color.fromARGB(09, 255, 255, 255),
    ); */
    final accountToken = Get.find<AccountSummaryController>();
    String encodedName =
        base64Url.encode(utf8.encode(selectedNFT.value!.name.toString()));
    final url =
        "https://naan-nft-credit-card.netlify.app/?fa=${mainUrl[0]}&tokenId=${mainUrl[1]}&address=${accountToken.selectedAccount.value.publicKeyHash!}&askId=${selectedNFT.value!.tokenId}&askPrice=${selectedNFT.value!.lowestAsk}&name=${encodedName}&ipfs=${selectedNFT.value!.artifactUri!.replaceAll("ipfs://", "")}";
/*     CommonFunctions.bottomSheet(
      const WertBrowserView(),
      fullscreen: true,
      settings: RouteSettings(
        arguments: url,
      ),
    ); */
    Platform.isIOS
        ? await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)
        : CommonFunctions.bottomSheet(
            const WertBrowserView(),
            fullscreen: true,
            settings: RouteSettings(
              arguments: url,
            ),
          );
  }

  void openFeeSummary() {
    Get.put(this);
    CommonFunctions.bottomSheet(
      FeesSummarySheet(),
      settings: RouteSettings(
        arguments: url,
      ),
    );
  }

  void openSuccessSheet({String sendAddress = ""}) async {
    final verified = await AuthService().verifyBiometricOrPassCode();
    if (verified) {
      final txHash = await OperationService()
          .injectOperation(operation, ServiceConfig.currentSelectedNode);
      try {
        Get.find<DappBrowserController>().showButton.value = false;
      } catch (e) {}

      Get.back();

      await CommonFunctions.bottomSheet(
        const BuyNftSuccessSheet(),
        settings: RouteSettings(
          arguments: url,
        ),
      );
      // start tracking tx here
      onConfirm(selectedToken.value!,
          double.parse(priceInToken.value).toStringAsFixed(3), txHash,
          senderAddress: sendAddress);
    }
  }

  onConfirm(AccountTokenModel token, String amount, String opHash,
      {String senderAddress = ""}) {
    DataHandlerService().onGoingTxStatusHelpers.add(OnGoingTxStatusHelper(
        opHash: opHash,
        status: TransactionStatus.pending,
        transactionAmount: "$amount ${token.symbol!}",
        isBrowser: true,
        saveAddress: senderAddress.isNotEmpty,
        senderAddress: senderAddress,
        tezAddress: "${opHash.substring(0, 6)}...."));
    transactionStatusSnackbar(
        status: TransactionStatus.pending,
        tezAddress: "${opHash.substring(0, 6)}....",
        transactionAmount: "$amount ${token.symbol!}",
        isBrowser: true);
  }
}
