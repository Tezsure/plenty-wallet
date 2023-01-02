import 'dart:math';

import 'package:dartez/models/key_store_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/helpers/on_going_tx_helper.dart';
import 'package:naan_wallet/app/data/services/operation_service/operation_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_batch_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/dapp_browser/controllers/dapp_browser_controller.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/buy_nft_success_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/fees_summary.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/review_nft.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_model.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:simple_gql/simple_gql.dart';

class BuyNFTController extends GetxController {
  Rx<AccountTokenModel?> selectedToken = null.obs;
  String url = "";

  List<String> mainUrl = [];
  final selectedNFT = Rxn<NftTokenModel?>();
  final RxBool loading = true.obs;
  RxString priceInToken = ''.obs;

  RxMap<String, String> fees = <String, String>{
    "netowrkFee": "calculating...",
    "interfaceFee": "calculating...",
    "totalFee": "calculating...",
    "totalFeeInTez": "calculating...",
  }.obs;

  RxMap<String, dynamic> operation = <String, dynamic>{}.obs;
  final error = "".obs;

  void selectMethod(AccountTokenModel token) async {
    try {
      selectedToken = token.obs;
      final accountToken = Get.find<AccountSummaryController>();
      Get.back();
      Get.bottomSheet(
        ReviewNFTSheet(),
        isScrollControlled: true,
        settings: RouteSettings(
          arguments: url,
        ),
      );

      priceInToken.value =
          (((int.parse(selectedNFT.value!.lowestAsk) / 1e6) * 1.10) /
                  (double.parse(token.currentPrice.toString())))
              .toString(); // todo check calculation

      if (token.symbol == "USDt") {
        //check user balance
        print("USDt balance: ${token.balance.toString()}");

        if (double.parse(token.balance.toString()) <
            double.parse(priceInToken.value)) {
          fees.value = <String, String>{
            "netowrkFee": "0.0",
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
                  """[ { "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken.value) * 1e6).toStringAsFixed(0)}" } ] } ] } ] ] } ]"""),
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
          "netowrkFee": networkFee,
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
            "netowrkFee": "0.0",
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
                  """[ { "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken.value) * 1e12).toStringAsFixed(0)}" } ] } ] } ] ] } ]"""),
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
          "netowrkFee": networkFee,
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
            "netowrkFee": "0.0",
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
                  """{ "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "int": "${(double.parse(priceInToken.value) * 1e18).toStringAsFixed(0)}" } ] } ] }"""),
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
          "netowrkFee": networkFee,
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
            "netowrkFee": "0.0",
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
                  """[ { "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken.value) * 1e6).toStringAsFixed(0)}" } ] } ] } ] ] } ]"""),
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
          "netowrkFee": networkFee,
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
            "netowrkFee": "0.0",
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
                  """{ "prim": "Pair", "args": [ { "string": "${accountToken.selectedAccount.value.publicKeyHash!}" }, { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "int": "${(double.parse(priceInToken.value) * 1e6).toStringAsFixed(0)}" } ] } ] }"""),
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
          "netowrkFee": networkFee,
          "interfaceFee": interfaceFee,
          "totalFee": totalFee,
          "totalFeeInTez": totalFeeInTez,
        };

        loading.value = false;
      }

      print("NFT Price in Token: $priceInToken.value ${token.symbol}");
    } catch (e) {
      error.value = "Error: $e";
      fees.value = fees.value = <String, String>{
        "netowrkFee": "0.0",
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
  }

  getNFTdata() async {
    try {
      DappBrowserController dappBrowserController =
          Get.find<DappBrowserController>();
      url = dappBrowserController.url.value;
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

  void buyWithCreditCard() {
    print("buy with credit card");
    if (selectedNFT.value == null) return;
    Get.back();
/*     Get.bottomSheet(
      const DappBrowserView(
        tagString: "2",
      ),
      settings: RouteSettings(
        arguments:
            "https://naan-nft-credit-card.netlify.app/?fa=${mainUrl[0]}&tokenId=${mainUrl[1]}&address=tz1WDRu8H4dHbUwygocLsmaXgHthGiV6JGJG&askId=${selectedNFT.value!.tokenId}&askPrice=${selectedNFT.value!.lowestAsk}&name=${selectedNFT.value!.name}",
      ),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: const Color.fromARGB(09, 255, 255, 255),
    ); */
    DappBrowserController dappBrowserController =
        Get.find<DappBrowserController>();

    dappBrowserController.webViewController!.loadUrl(
        urlRequest: URLRequest(
            url: Uri.parse(
                "https://naan-nft-credit-card.netlify.app/?fa=${mainUrl[0]}&tokenId=${mainUrl[1]}&address=tz1WDRu8H4dHbUwygocLsmaXgHthGiV6JGJG&askId=${selectedNFT.value!.tokenId}&askPrice=${selectedNFT.value!.lowestAsk}&name=${selectedNFT.value!.name}")));
  }

  void openFeeSummary() {
    Get.bottomSheet(
      FeesSummarySheet(),
      settings: RouteSettings(
        arguments: url,
      ),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: const Color.fromARGB(09, 255, 255, 255),
    );
  }

  void openSuccessSheet() async {
    final verified = await AuthService().verifyBiometricOrPassCode();
    if (verified) {
      final txHash = await OperationService()
          .injectOperation(operation, ServiceConfig.currentSelectedNode);
      Get.find<DappBrowserController>().showButton.value = false;
      //todo start tracking tx here

      Get.back();
      Get.bottomSheet(
        const BuyNftSuccessSheet(),
        settings: RouteSettings(
          arguments: url,
        ),
        enterBottomSheetDuration: const Duration(milliseconds: 180),
        exitBottomSheetDuration: const Duration(milliseconds: 150),
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        barrierColor: const Color.fromARGB(09, 255, 255, 255),
      );
    }
  }

  Future<void> onConfirm(OperationModel operationModel, String opHash) async {
    DataHandlerService().onGoingTxStatusHelpers.add(OnGoingTxStatusHelper(
        opHash: opHash,
        status: TransactionStatus.pending,
        transactionAmount: operationModel.amount == 0.0
            ? "1 ${operationModel.model.nodes}"
            : operationModel.amount!.toStringAsFixed(6).removeTrailing0 +
                " " +
                (operationModel.model as AccountTokenModel).symbol!,
        tezAddress: operationModel.receiveAddress!.tz1Short()));
    transactionStatusSnackbar(
      status: TransactionStatus.pending,
      tezAddress: operationModel.receiveAddress!.tz1Short(),
      transactionAmount: operationModel.amount == 0.0
          ? "1 ${operationModel.model.nodes}"
          : operationModel.amount!.toStringAsFixed(6).removeTrailing0 +
              " " +
              (operationModel.model as AccountTokenModel).symbol!,
    );
  }
}
